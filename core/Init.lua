local addonName, addonPrivate = ...
addonPrivate = addonPrivate or {}

--- Public API table for the Trivia Classic addon.
---@class TriviaClassic
---@field repo Repo
---@field chat Chat
---@field game Game|nil
---@field DEFAULT_TIMER integer

local TriviaClassic = {}
_G.TriviaClassic = TriviaClassic

local SCHEMA_VERSION = 1
local MODE_MAP = TriviaClassic_GetModeMap()
local DEFAULT_TIMER = 20
local MIN_TIMER = 5
local MAX_TIMER = 120
local DEFAULT_STEAL_TIMER = 20
local MIN_STEAL_TIMER = 5
local MAX_STEAL_TIMER = 120
local DEBUG_ENABLED = false

local normalizeName = TriviaClassic_NormalizeName
local normalizeKey = TriviaClassic_NormalizeKey
local clampNumber = TriviaClassic_ClampNumber

local runtime = TriviaClassic_GetRuntime and TriviaClassic_GetRuntime() or nil

local function getDB()
  local storage = runtime and runtime.storage
  local db = storage and storage.get and storage.get() or nil
  if not db then
    db = {}
    if storage and storage.set then
      storage.set(db)
    else
      _G.TriviaClassicCharacterDB = db
    end
  end
  return db
end

local function clampTimerValue(seconds)
  return clampNumber(seconds, MIN_TIMER, MAX_TIMER, DEFAULT_TIMER)
end

local function normalizeAxisConfig(config)
  if type(config) ~= "table" then
    return nil
  end
  local participation = config.participation
  local flow = config.flow
  local scoring = config.scoring
  local attempt = config.attempt
  if not TriviaClassic_IsValidParticipation(participation) then
    participation = nil
  end
  if not TriviaClassic_IsValidFlow(flow) then
    flow = nil
  end
  if not TriviaClassic_IsValidScoring(scoring) then
    scoring = nil
  end
  if not TriviaClassic_IsValidAttempt(attempt) then
    attempt = nil
  end
  if not participation or not flow or not scoring then
    return nil
  end
  if not attempt then
    attempt = "MULTI"
  end
  return {
    participation = participation,
    flow = flow,
    scoring = scoring,
    attempt = attempt,
  }
end

local function ensureAxisConfig(db)
  local normalized = normalizeAxisConfig(db.modeConfig)
  if normalized then
    db.modeConfig = normalized
    return normalized
  end
  local fallback = TriviaClassic_GetModeAxisConfig(db.mode or TriviaClassic_GetDefaultMode())
  db.modeConfig = fallback
  return fallback
end

local function ensureTeamStore()
  local db = getDB()
  db.teams = db.teams or { teams = {}, playerTeam = {}, waiting = {} }
  db.teams.teams = db.teams.teams or {}
  db.teams.playerTeam = db.teams.playerTeam or {}
  db.teams.waiting = db.teams.waiting or {}
  db.teams.config = db.teams.config or {}
  return db
end

TriviaClassic.repo = TriviaClassic_CreateRepo()
TriviaClassic.chat = TriviaClassic_CreateChat(runtime and runtime.chatTransport)
TriviaClassic.game = nil

local function initDatabase()
  local db = getDB()
  db.schema = db.schema or SCHEMA_VERSION
  db.scores = db.scores or {}
  db.leaderboard = db.leaderboard or {}
  -- Track all-time fastest correct answer across all games for this character
  -- Format: { name = "Player", time = 1.23 }
  if not db.fastest then
    db.fastest = nil
  end
  if not db.mode or not MODE_MAP[db.mode] then
    db.mode = TriviaClassic_GetDefaultMode()
  end
  ensureAxisConfig(db)
  db.timer = clampTimerValue(db.timer or DEFAULT_TIMER)
  ensureTeamStore()
  if not db.teams.config.stealTimer then
    db.teams.config.stealTimer = DEFAULT_STEAL_TIMER
  end
end

local function initGame()
  local deps = {
    clock = runtime and runtime.clock,
    date = runtime and runtime.date,
    answer = runtime and runtime.answer,
    getTimer = runtime and runtime.chatTransport and runtime.chatTransport.getTimer,
    getStealTimer = runtime and runtime.chatTransport and runtime.chatTransport.getStealTimer,
  }
  TriviaClassic.game = TriviaClassic_CreateGame(TriviaClassic.repo, getDB(), deps)
  TriviaClassic.game:SetMode(TriviaClassic:GetGameMode())
  TriviaClassic.game:SetModeConfig(TriviaClassic:GetGameAxisConfig())
end

--- Returns all registered question sets.
---@return table sets
function TriviaClassic:GetAllSets()
  return self.repo:GetAllSets()
end

--- Registers a TriviaBot-format set into the repository.
---@param label string|nil
---@param triviaTable table
function TriviaClassic:RegisterTriviaBotSet(label, triviaTable)
  self.repo:RegisterTriviaBotSet(label, triviaTable)
end

--- Configures the outbound chat channel (or custom channel).
---@param key string Channel key or "CUSTOM"
---@param customName string|nil Custom channel name when key is "CUSTOM"
function TriviaClassic:SetChannel(key, customName)
  if key == "CUSTOM" then
    self.chat:SetCustomChannel(customName)
  else
    self.chat:SetChannel(key)
  end
end

--- Returns the active channel key.
---@return string
function TriviaClassic:GetChannelKey()
  return self.chat.channelKey
end

--- Sets the game mode key.
---@param modeKey string
function TriviaClassic:SetGameMode(modeKey)
  local modeMap = MODE_MAP or TriviaClassic_GetModeMap()
  if not modeMap[modeKey] then
    modeKey = TriviaClassic_GetDefaultMode()
  end
  local db = getDB()
  db.mode = modeKey
  db.modeConfig = TriviaClassic_GetModeAxisConfig(modeKey)
  if self.game and self.game.SetMode then
    self.game:SetMode(modeKey)
    if self.game.SetModeConfig then
      self.game:SetModeConfig(db.modeConfig)
    end
  end
end

--- Gets the current valid game mode key.
---@return string
function TriviaClassic:GetGameMode()
  local db = getDB()
  local modeKey = db.mode or TriviaClassic_GetDefaultMode()
  local modeMap = MODE_MAP or TriviaClassic_GetModeMap()
  if modeMap[modeKey] then
    return modeKey
  end
  return TriviaClassic_GetDefaultMode()
end

--- Sets the axis-based game config (participation/flow/scoring).
---@param config table
function TriviaClassic:SetGameAxisConfig(config)
  local db = getDB()
  local normalized = normalizeAxisConfig(config)
  if not normalized then
    normalized = TriviaClassic_GetModeAxisConfig(self:GetGameMode())
  end
  db.modeConfig = normalized
  local mappedMode = TriviaClassic_GetModeKeyFromAxisConfig(normalized)
  if mappedMode then
    db.mode = mappedMode
  end
  if self.game and self.game.SetModeConfig then
    self.game:SetModeConfig(normalized)
    if mappedMode and self.game.SetMode then
      self.game:SetMode(mappedMode)
    end
  end
end

--- Gets the axis-based game config (participation/flow/scoring).
---@return table
function TriviaClassic:GetGameAxisConfig()
  local db = getDB()
  local normalized = normalizeAxisConfig(db.modeConfig)
  if not normalized then
    normalized = ensureAxisConfig(db)
  end
  return normalized
end

--- Returns the display label for the current mode.
---@return string
function TriviaClassic:GetGameModeLabel()
  return TriviaClassic_GetModeLabel(self:GetGameMode())
end

-- Team data helpers
--- Adds a team or ensures it exists.
---@param teamName string
---@return boolean ok
function TriviaClassic:AddTeam(teamName)
  local db = ensureTeamStore()
  local key = normalizeKey(teamName)
  if not key then return false end
  local teams = db.teams.teams
  teams[key] = teams[key] or { name = normalizeName(teamName), members = {} }
  return true
end

--- Removes a team and clears member mappings.
---@param teamName string
---@return boolean ok
function TriviaClassic:RemoveTeam(teamName)
  local db = ensureTeamStore()
  local key = normalizeKey(teamName)
  if not key then return false end
  local teams = db.teams.teams
  if not teams[key] then return false end
  -- remove member mappings
  local playerTeam = db.teams.playerTeam or {}
  for player, tkey in pairs(playerTeam) do
    if tkey == key then
      playerTeam[player] = nil
    end
  end
  teams[key] = nil
  return true
end

--- Assigns a player to a team (creates the team if needed).
---@param playerName string
---@param teamName string
---@return boolean ok
function TriviaClassic:AddPlayerToTeam(playerName, teamName)
  local db = ensureTeamStore()
  local playerKey = normalizeKey(playerName)
  local teamKey = normalizeKey(teamName)
  if not playerKey or not teamKey then return false end
  local teams = db.teams.teams
  local playerTeam = db.teams.playerTeam
  teams[teamKey] = teams[teamKey] or { name = normalizeName(teamName), members = {} }
  playerTeam[playerKey] = teamKey
  teams[teamKey].members[playerKey] = normalizeName(playerName)
  -- remove from waiting list if present
  db.teams.waiting[playerKey] = nil
  return true
end

--- Removes a player from whichever team they belong to.
---@param playerName string
---@return boolean ok
function TriviaClassic:RemovePlayerFromTeam(playerName)
  local db = ensureTeamStore()
  local playerKey = normalizeKey(playerName)
  if not playerKey then return false end
  local playerTeam = db.teams.playerTeam
  local teamKey = playerTeam[playerKey]
  if teamKey then
    local teams = db.teams.teams or {}
    if teams[teamKey] and teams[teamKey].members then
      teams[teamKey].members[playerKey] = nil
    end
  end
  playerTeam[playerKey] = nil
  return true
end

--- Returns sorted team summaries with member display names.
---@return table[] teams
function TriviaClassic:GetTeams()
  local db = ensureTeamStore()
  local list = {}
  for key, team in pairs(db.teams.teams or {}) do
    local members = {}
    for mKey, display in pairs(team.members or {}) do
      table.insert(members, display or mKey)
    end
    table.sort(members, function(a, b) return a:lower() < b:lower() end)
    table.insert(list, { key = key, name = team.name or key, members = members })
  end
  table.sort(list, function(a, b) return a.name:lower() < b.name:lower() end)
  return list
end

--- Returns a map of player key -> team key.
---@return table map
function TriviaClassic:GetTeamMap()
  local db = ensureTeamStore()
  local map = {}
  for playerKey, teamKey in pairs(db.teams.playerTeam or {}) do
    map[playerKey] = teamKey
  end
  return map
end

--- Looks up a player's team.
---@param playerName string
---@return string|nil teamName, string|nil teamKey
function TriviaClassic:GetTeamForPlayer(playerName)
  local db = ensureTeamStore()
  local key = normalizeKey(playerName)
  if not key then return nil end
  local teamKey = db.teams.playerTeam[key]
  if not teamKey then return nil end
  local team = db.teams.teams[teamKey]
  return team and team.name or nil, teamKey
end

--- Adds a player to the waiting list for team placement.
---@param name string
---@return boolean ok
function TriviaClassic:RegisterPlayer(name)
  local db = ensureTeamStore()
  local key = normalizeKey(name)
  local disp = normalizeName(name)
  if not key or not disp then return false end
  db.teams.waiting[key] = disp
  return true
end

--- Removes a player from the waiting list.
---@param name string
---@return boolean ok
function TriviaClassic:UnregisterPlayer(name)
  local db = ensureTeamStore()
  local key = normalizeKey(name)
  if not key then return false end
  db.teams.waiting[key] = nil
  return true
end

--- Returns waiting player display names (sorted).
---@return string[] names
function TriviaClassic:GetWaitingPlayers()
  local db = ensureTeamStore()
  local list = {}
  for key, disp in pairs(db.teams.waiting or {}) do
    table.insert(list, disp or key)
  end
  table.sort(list, function(a, b) return a:lower() < b:lower() end)
  return list
end

--- Sets the per-question timer (seconds, clamped).
---@param seconds number
function TriviaClassic:SetTimer(seconds)
  local clamped = clampTimerValue(seconds)
  local db = getDB()
  db.timer = clamped
end

--- Gets the configured per-question timer (seconds).
---@return integer
function TriviaClassic:GetTimer()
  local db = getDB()
  local value = db.timer
  if value == nil then
    return DEFAULT_TIMER
  end
  return clampTimerValue(value)
end

--- Returns min/max bounds for the per-question timer.
---@return integer min, integer max
function TriviaClassic:GetTimerBounds()
  return MIN_TIMER, MAX_TIMER
end

local function clampStealTimer(seconds)
  return clampNumber(seconds, MIN_STEAL_TIMER, MAX_STEAL_TIMER, DEFAULT_STEAL_TIMER)
end

--- Sets the steal timer (seconds).
---@param seconds number
function TriviaClassic:SetStealTimer(seconds)
  local db = ensureTeamStore()
  db.teams.config = db.teams.config or {}
  db.teams.config.stealTimer = clampStealTimer(seconds)
end

--- Gets the configured steal timer (seconds).
---@return integer
function TriviaClassic:GetStealTimer()
  local db = ensureTeamStore()
  db.teams.config = db.teams.config or {}
  local value = db.teams.config.stealTimer
  if value == nil then
    return DEFAULT_STEAL_TIMER
  end
  return clampStealTimer(value)
end

--- Returns min/max bounds for the steal timer.
---@return integer min, integer max
function TriviaClassic:GetStealTimerBounds()
  return MIN_STEAL_TIMER, MAX_STEAL_TIMER
end

--- Enables or disables debug logging.
---@param enabled boolean
function TriviaClassic:EnableDebugLogging(enabled)
  DEBUG_ENABLED = enabled and true or false
end

--- Returns whether debug logging is enabled.
---@return boolean
function TriviaClassic:IsDebugLogging()
  return DEBUG_ENABLED
end

--- Starts a new game with the given selection.
---@param selectedIds string[] Set ids selected by the user
---@param desiredCount integer|nil Optional number of questions to draw
---@param allowedCategories table|nil Global or per-set category allow map
---@return table|nil meta Returns game metadata or nil if no questions
function TriviaClassic:StartGame(selectedIds, desiredCount, allowedCategories)
  if self.game and self.game.SetMode then
    self.game:SetMode(self:GetGameMode())
  end
  if self.game and self.game.SetTeams then
    self.game:SetTeams(self:GetTeamMap())
  end
  return self.game:Start(selectedIds, desiredCount, allowedCategories, self:GetGameMode())
end

--- Advances to the next question.
---@return table|nil question, integer|nil index, integer|nil total
function TriviaClassic:NextQuestion()
  return self.game:NextQuestion()
end

--- Marks the current question as timed out.
function TriviaClassic:MarkTimeout()
  return self.game:MarkTimeout()
end

--- Skips the current question (keeping total constant).
function TriviaClassic:SkipCurrentQuestion()
  return self.game:SkipCurrent()
end

--- Whether there is a pending winner announcement.
---@return boolean
function TriviaClassic:IsPendingWinner()
  return self.game:IsPendingWinner()
end

--- Whether there is a pending no-winner announcement.
---@return boolean
function TriviaClassic:IsPendingNoWinner()
  return self.game:IsPendingNoWinner()
end

--- Whether the current question is open for answers.
---@return boolean
function TriviaClassic:IsQuestionOpen()
  return self.game:IsQuestionOpen()
end

--- Whether more questions remain in this game.
---@return boolean
function TriviaClassic:HasMoreQuestions()
  return self.game:HasMoreQuestions()
end

--- Current (asked) question index and total.
---@return integer index, integer total
function TriviaClassic:GetCurrentQuestionIndex()
  if not self.game or not self.game.GetCurrentQuestionIndex then
    return 0, 0
  end
  return self.game:GetCurrentQuestionIndex()
end

--- Whether a game session is active.
---@return boolean
function TriviaClassic:IsGameActive()
  if not self.game or not self.game.IsGameActive then
    return false
  end
  return self.game:IsGameActive()
end

--- Ends the current game if one is active.
function TriviaClassic:EndGame()
  if self.game and self.game.EndGame then
    return self.game:EndGame()
  end
end

--- Returns the current question (if any).
---@return table|nil
function TriviaClassic:GetCurrentQuestion()
  if not self.game or not self.game.GetCurrentQuestion then
    return nil
  end
  return self.game:GetCurrentQuestion()
end

--- Returns the last winner details.
---@return string|nil name, number|nil elapsed, integer|nil points, string|nil teamName
function TriviaClassic:GetLastWinner()
  if not self.game or not self.game.GetLastWinner then
    return nil, nil, nil, nil
  end
  return self.game:GetLastWinner()
end

--- Returns the active team (if team mode).
---@return string|nil teamName, string|nil teamKey
function TriviaClassic:GetActiveTeam()
  if not self.game or not self.game.GetActiveTeam then
    return nil, nil
  end
  return self.game:GetActiveTeam()
end

--- Returns the primary UI action for the current state.
---@return table action
function TriviaClassic:GetPrimaryAction()
  if not self.game or not self.game.GetPrimaryAction then
    return { command = "waiting", label = "Start", enabled = false }
  end
  return self.game:GetPrimaryAction()
end

--- Performs the requested primary action.
---@param command string
---@return any
function TriviaClassic:PerformPrimaryAction(command)
  if not self.game or not self.game.PerformPrimaryAction then
    return nil
  end
  return self.game:PerformPrimaryAction(command)
end

--- Returns any pending winners awaiting broadcast.
---@return table[]
function TriviaClassic:GetPendingWinners()
  if not self.game or not self.game.GetPendingWinners then
    return {}
  end
  return self.game:GetPendingWinners()
end

--- Returns the in-session scoreboard rows and fastest stats.
---@return table[] rows, string|nil fastestName, number|nil fastestTime
function TriviaClassic:GetSessionScoreboard()
  if not self.game or not self.game.GetSessionScoreboard then
    return {}, nil, nil
  end
  return self.game:GetSessionScoreboard()
end

--- Returns the all-time leaderboard rows and fastest stats.
---@param limit integer|nil Optional max rows
---@return table[] rows, string|nil fastestName, number|nil fastestTime
function TriviaClassic:GetLeaderboard(limit)
  if not self.game or not self.game.GetLeaderboard then
    return {}, nil, nil
  end
  return self.game:GetLeaderboard(limit)
end

--- Marks any pending winner broadcast as completed.
---@return boolean
function TriviaClassic:CompleteWinnerBroadcast()
  if not self.game or not self.game.CompleteWinnerBroadcast then
    return true
  end
  return self.game:CompleteWinnerBroadcast()
end

--- Marks any pending no-winner broadcast as completed.
---@return boolean
function TriviaClassic:CompleteNoWinnerBroadcast()
  if not self.game or not self.game.CompleteNoWinnerBroadcast then
    return true
  end
  return self.game:CompleteNoWinnerBroadcast()
end

TriviaClassic.DEFAULT_TIMER = DEFAULT_TIMER

local function handleIncomingChat(event, msg, sender, languageName, channelNameFull, _, _, _, _, channelBase)
  -- channelNameFull example: "1. Custom"; channelBase example: "Custom"
  local channelName = channelBase or channelNameFull
  if not TriviaClassic.chat:AcceptsEvent(event, channelName) then
    return
  end
  -- Player self-registration: message "trivia register" or "trivia join"
  local lowered = tostring(msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  if lowered == "trivia register" or lowered == "trivia join" then
    if TriviaClassic:RegisterPlayer(sender) then
      TriviaClassic.chat.transport.system("|cffffff00[Trivia]|r Registered " .. (sender or "?") .. " for team placement.")
      if TriviaClassic_Emit then TriviaClassic_Emit("teams_updated") end
    end
    return
  end
  local winner = TriviaClassic.game:HandleChatAnswer(msg, sender)
  if winner then
    if winner.pendingSteal then
      if TriviaClassic_Emit then TriviaClassic_Emit("pending_steal", winner) end
    else
      if TriviaClassic_Emit then TriviaClassic_Emit("winner_found", winner) end
    end
  end
end

local channelEvents = {
  "CHAT_MSG_SAY",
  "CHAT_MSG_YELL",
  "CHAT_MSG_PARTY",
  "CHAT_MSG_PARTY_LEADER",
  "CHAT_MSG_RAID",
  "CHAT_MSG_RAID_LEADER",
  "CHAT_MSG_GUILD",
  "CHAT_MSG_WHISPER",
  "CHAT_MSG_CHANNEL",
}

local events = runtime and runtime.events
if events and events.on then
  events:on("ADDON_LOADED", function(_, name)
    if name == addonName then
      initDatabase()
      initGame()
      if addonPrivate and addonPrivate[1] then
        TriviaClassic.repo:RegisterTriviaBotSet("Embedded Sets", addonPrivate)
      end
      if _G.TriviaBot_Questions and _G.TriviaBot_Questions[1] then
        TriviaClassic.repo:RegisterTriviaBotSet("TriviaBot Import", _G.TriviaBot_Questions)
      end
    end
  end)

  events:on("PLAYER_LOGIN", function()
    if TriviaClassicUI and TriviaClassicUI.BuildUI then
      TriviaClassicUI:BuildUI()
    end
  end)

  for _, evt in ipairs(channelEvents) do
    events:on(evt, function(event, ...)
      handleIncomingChat(event, ...)
    end)
  end
end
