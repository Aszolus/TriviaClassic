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

local function normalizeName(text)
  if not text then return nil end
  local trimmed = tostring(text):gsub("^%s+", ""):gsub("%s+$", "")
  if trimmed == "" then return nil end
  return trimmed
end

local function normalizeKey(text)
  local name = normalizeName(text)
  return name and name:lower() or nil
end

local function clampTimerValue(seconds)
  local n = tonumber(seconds)
  if not n then
    return DEFAULT_TIMER
  end
  if n < MIN_TIMER then
    n = MIN_TIMER
  elseif n > MAX_TIMER then
    n = MAX_TIMER
  end
  return math.floor(n + 0.5)
end

local function ensureTeamStore()
  TriviaClassicCharacterDB.teams = TriviaClassicCharacterDB.teams or { teams = {}, playerTeam = {}, waiting = {} }
  TriviaClassicCharacterDB.teams.teams = TriviaClassicCharacterDB.teams.teams or {}
  TriviaClassicCharacterDB.teams.playerTeam = TriviaClassicCharacterDB.teams.playerTeam or {}
  TriviaClassicCharacterDB.teams.waiting = TriviaClassicCharacterDB.teams.waiting or {}
  TriviaClassicCharacterDB.teams.config = TriviaClassicCharacterDB.teams.config or {}
end

TriviaClassic.repo = TriviaClassic_CreateRepo()
TriviaClassic.chat = TriviaClassic_CreateChat()
TriviaClassic.game = nil

local function initDatabase()
  TriviaClassicCharacterDB = TriviaClassicCharacterDB or {}
  TriviaClassicCharacterDB.schema = TriviaClassicCharacterDB.schema or SCHEMA_VERSION
  TriviaClassicCharacterDB.scores = TriviaClassicCharacterDB.scores or {}
  TriviaClassicCharacterDB.leaderboard = TriviaClassicCharacterDB.leaderboard or {}
  -- Track all-time fastest correct answer across all games for this character
  -- Format: { name = "Player", time = 1.23 }
  if not TriviaClassicCharacterDB.fastest then
    TriviaClassicCharacterDB.fastest = nil
  end
  if not TriviaClassicCharacterDB.mode or not MODE_MAP[TriviaClassicCharacterDB.mode] then
    TriviaClassicCharacterDB.mode = TriviaClassic_GetDefaultMode()
  end
  TriviaClassicCharacterDB.timer = clampTimerValue(TriviaClassicCharacterDB.timer or DEFAULT_TIMER)
  if not TriviaClassicCharacterDB.teams.config.stealTimer then
    TriviaClassicCharacterDB.teams.config.stealTimer = DEFAULT_STEAL_TIMER
  end
  ensureTeamStore()
end

local function initGame()
  TriviaClassic.game = TriviaClassic_CreateGame(TriviaClassic.repo, TriviaClassicCharacterDB)
  TriviaClassic.game:SetMode(TriviaClassic:GetGameMode())
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
  TriviaClassicCharacterDB.mode = modeKey
  if self.game and self.game.SetMode then
    self.game:SetMode(modeKey)
  end
end

--- Gets the current valid game mode key.
---@return string
function TriviaClassic:GetGameMode()
  local modeKey = TriviaClassicCharacterDB and TriviaClassicCharacterDB.mode or TriviaClassic_GetDefaultMode()
  local modeMap = MODE_MAP or TriviaClassic_GetModeMap()
  if modeMap[modeKey] then
    return modeKey
  end
  return TriviaClassic_GetDefaultMode()
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
  ensureTeamStore()
  local key = normalizeKey(teamName)
  if not key then return false end
  local teams = TriviaClassicCharacterDB.teams.teams
  teams[key] = teams[key] or { name = normalizeName(teamName), members = {} }
  return true
end

--- Removes a team and clears member mappings.
---@param teamName string
---@return boolean ok
function TriviaClassic:RemoveTeam(teamName)
  ensureTeamStore()
  local key = normalizeKey(teamName)
  if not key then return false end
  local teams = TriviaClassicCharacterDB.teams.teams
  if not teams[key] then return false end
  -- remove member mappings
  local playerTeam = TriviaClassicCharacterDB.teams.playerTeam or {}
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
  ensureTeamStore()
  local playerKey = normalizeKey(playerName)
  local teamKey = normalizeKey(teamName)
  if not playerKey or not teamKey then return false end
  self:AddTeam(teamName) -- ensure team exists
  local teams = TriviaClassicCharacterDB.teams.teams
  local playerTeam = TriviaClassicCharacterDB.teams.playerTeam
  playerTeam[playerKey] = teamKey
  teams[teamKey].members[playerKey] = normalizeName(playerName)
  -- remove from waiting list if present
  TriviaClassicCharacterDB.teams.waiting[playerKey] = nil
  return true
end

--- Removes a player from whichever team they belong to.
---@param playerName string
---@return boolean ok
function TriviaClassic:RemovePlayerFromTeam(playerName)
  ensureTeamStore()
  local playerKey = normalizeKey(playerName)
  if not playerKey then return false end
  local playerTeam = TriviaClassicCharacterDB.teams.playerTeam
  local teamKey = playerTeam[playerKey]
  if teamKey then
    local teams = TriviaClassicCharacterDB.teams.teams or {}
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
  ensureTeamStore()
  local list = {}
  for key, team in pairs(TriviaClassicCharacterDB.teams.teams or {}) do
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
  ensureTeamStore()
  local map = {}
  for playerKey, teamKey in pairs(TriviaClassicCharacterDB.teams.playerTeam or {}) do
    map[playerKey] = teamKey
  end
  return map
end

--- Looks up a player's team.
---@param playerName string
---@return string|nil teamName, string|nil teamKey
function TriviaClassic:GetTeamForPlayer(playerName)
  ensureTeamStore()
  local key = normalizeKey(playerName)
  if not key then return nil end
  local teamKey = TriviaClassicCharacterDB.teams.playerTeam[key]
  if not teamKey then return nil end
  local team = TriviaClassicCharacterDB.teams.teams[teamKey]
  return team and team.name or nil, teamKey
end

--- Adds a player to the waiting list for team placement.
---@param name string
---@return boolean ok
function TriviaClassic:RegisterPlayer(name)
  ensureTeamStore()
  local key = normalizeKey(name)
  local disp = normalizeName(name)
  if not key or not disp then return false end
  TriviaClassicCharacterDB.teams.waiting[key] = disp
  return true
end

--- Removes a player from the waiting list.
---@param name string
---@return boolean ok
function TriviaClassic:UnregisterPlayer(name)
  ensureTeamStore()
  local key = normalizeKey(name)
  if not key then return false end
  TriviaClassicCharacterDB.teams.waiting[key] = nil
  return true
end

--- Returns waiting player display names (sorted).
---@return string[] names
function TriviaClassic:GetWaitingPlayers()
  ensureTeamStore()
  local list = {}
  for key, disp in pairs(TriviaClassicCharacterDB.teams.waiting or {}) do
    table.insert(list, disp or key)
  end
  table.sort(list, function(a, b) return a:lower() < b:lower() end)
  return list
end

local function clampTimerValue(seconds)
  local n = tonumber(seconds)
  if not n then
    return DEFAULT_TIMER
  end
  if n < MIN_TIMER then
    n = MIN_TIMER
  elseif n > MAX_TIMER then
    n = MAX_TIMER
  end
  return math.floor(n + 0.5)
end

--- Sets the per-question timer (seconds, clamped).
---@param seconds number
function TriviaClassic:SetTimer(seconds)
  local clamped = clampTimerValue(seconds)
  TriviaClassicCharacterDB.timer = clamped
end

--- Gets the configured per-question timer (seconds).
---@return integer
function TriviaClassic:GetTimer()
  local value = TriviaClassicCharacterDB and TriviaClassicCharacterDB.timer
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
  local n = tonumber(seconds)
  if not n then
    return DEFAULT_STEAL_TIMER
  end
  if n < MIN_STEAL_TIMER then
    n = MIN_STEAL_TIMER
  elseif n > MAX_STEAL_TIMER then
    n = MAX_STEAL_TIMER
  end
  return math.floor(n + 0.5)
end

--- Sets the steal timer (seconds).
---@param seconds number
function TriviaClassic:SetStealTimer(seconds)
  ensureTeamStore()
  TriviaClassicCharacterDB.teams.config = TriviaClassicCharacterDB.teams.config or {}
  TriviaClassicCharacterDB.teams.config.stealTimer = clampStealTimer(seconds)
end

--- Gets the configured steal timer (seconds).
---@return integer
function TriviaClassic:GetStealTimer()
  ensureTeamStore()
  TriviaClassicCharacterDB.teams.config = TriviaClassicCharacterDB.teams.config or {}
  local value = TriviaClassicCharacterDB.teams.config.stealTimer
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
      DEFAULT_CHAT_FRAME:AddMessage("|cffffff00[Trivia]|r Registered " .. (sender or "?") .. " for team placement.")
      if TriviaClassicUI and TriviaClassicUI.UpdateTeamUI then
        TriviaClassicUI:UpdateTeamUI()
      end
    end
    return
  end
  local winner = TriviaClassic.game:HandleChatAnswer(msg, sender)
  if winner and TriviaClassicUI then
    if winner.pendingSteal and TriviaClassicUI.OnPendingSteal then
      TriviaClassicUI:OnPendingSteal(winner)
    elseif TriviaClassicUI.OnWinnerFound then
      TriviaClassicUI:OnWinnerFound(winner)
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

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
for _, evt in ipairs(channelEvents) do
  eventFrame:RegisterEvent(evt)
end
eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local name = ...
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
  elseif event == "PLAYER_LOGIN" then
    if TriviaClassicUI and TriviaClassicUI.BuildUI then
      TriviaClassicUI:BuildUI()
    end
  elseif event:find("CHAT_MSG_") then
    handleIncomingChat(event, ...)
  end
end)
