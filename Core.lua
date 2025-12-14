local addonName, addonPrivate = ...
addonPrivate = addonPrivate or {}

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

function TriviaClassic:GetAllSets()
  return self.repo:GetAllSets()
end

function TriviaClassic:RegisterTriviaBotSet(label, triviaTable)
  self.repo:RegisterTriviaBotSet(label, triviaTable)
end

function TriviaClassic:SetChannel(key, customName)
  if key == "CUSTOM" then
    self.chat:SetCustomChannel(customName)
  else
    self.chat:SetChannel(key)
  end
end

function TriviaClassic:GetChannelKey()
  return self.chat.channelKey
end

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

function TriviaClassic:GetGameMode()
  local modeKey = TriviaClassicCharacterDB and TriviaClassicCharacterDB.mode or TriviaClassic_GetDefaultMode()
  local modeMap = MODE_MAP or TriviaClassic_GetModeMap()
  if modeMap[modeKey] then
    return modeKey
  end
  return TriviaClassic_GetDefaultMode()
end

function TriviaClassic:GetGameModeLabel()
  return TriviaClassic_GetModeLabel(self:GetGameMode())
end

-- Team data helpers
function TriviaClassic:AddTeam(teamName)
  ensureTeamStore()
  local key = normalizeKey(teamName)
  if not key then return false end
  local teams = TriviaClassicCharacterDB.teams.teams
  teams[key] = teams[key] or { name = normalizeName(teamName), members = {} }
  return true
end

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

function TriviaClassic:GetTeamMap()
  ensureTeamStore()
  local map = {}
  for playerKey, teamKey in pairs(TriviaClassicCharacterDB.teams.playerTeam or {}) do
    map[playerKey] = teamKey
  end
  return map
end

function TriviaClassic:GetTeamForPlayer(playerName)
  ensureTeamStore()
  local key = normalizeKey(playerName)
  if not key then return nil end
  local teamKey = TriviaClassicCharacterDB.teams.playerTeam[key]
  if not teamKey then return nil end
  local team = TriviaClassicCharacterDB.teams.teams[teamKey]
  return team and team.name or nil, teamKey
end

function TriviaClassic:RegisterPlayer(name)
  ensureTeamStore()
  local key = normalizeKey(name)
  local disp = normalizeName(name)
  if not key or not disp then return false end
  TriviaClassicCharacterDB.teams.waiting[key] = disp
  return true
end

function TriviaClassic:UnregisterPlayer(name)
  ensureTeamStore()
  local key = normalizeKey(name)
  if not key then return false end
  TriviaClassicCharacterDB.teams.waiting[key] = nil
  return true
end

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

function TriviaClassic:SetTimer(seconds)
  local clamped = clampTimerValue(seconds)
  TriviaClassicCharacterDB.timer = clamped
end

function TriviaClassic:GetTimer()
  local value = TriviaClassicCharacterDB and TriviaClassicCharacterDB.timer
  if value == nil then
    return DEFAULT_TIMER
  end
  return clampTimerValue(value)
end

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

function TriviaClassic:SetStealTimer(seconds)
  ensureTeamStore()
  TriviaClassicCharacterDB.teams.config = TriviaClassicCharacterDB.teams.config or {}
  TriviaClassicCharacterDB.teams.config.stealTimer = clampStealTimer(seconds)
end

function TriviaClassic:GetStealTimer()
  ensureTeamStore()
  TriviaClassicCharacterDB.teams.config = TriviaClassicCharacterDB.teams.config or {}
  local value = TriviaClassicCharacterDB.teams.config.stealTimer
  if value == nil then
    return DEFAULT_STEAL_TIMER
  end
  return clampStealTimer(value)
end

function TriviaClassic:GetStealTimerBounds()
  return MIN_STEAL_TIMER, MAX_STEAL_TIMER
end

function TriviaClassic:EnableDebugLogging(enabled)
  DEBUG_ENABLED = enabled and true or false
end

function TriviaClassic:IsDebugLogging()
  return DEBUG_ENABLED
end

function TriviaClassic:StartGame(selectedIds, desiredCount, allowedCategories)
  if self.game and self.game.SetMode then
    self.game:SetMode(self:GetGameMode())
  end
  if self.game and self.game.SetTeams then
    self.game:SetTeams(self:GetTeamMap())
  end
  return self.game:Start(selectedIds, desiredCount, allowedCategories, self:GetGameMode())
end

function TriviaClassic:NextQuestion()
  return self.game:NextQuestion()
end

function TriviaClassic:MarkTimeout()
  return self.game:MarkTimeout()
end

function TriviaClassic:SkipCurrentQuestion()
  return self.game:SkipCurrent()
end

function TriviaClassic:IsPendingWinner()
  return self.game:IsPendingWinner()
end

function TriviaClassic:IsPendingNoWinner()
  return self.game:IsPendingNoWinner()
end

function TriviaClassic:IsQuestionOpen()
  return self.game:IsQuestionOpen()
end

function TriviaClassic:HasMoreQuestions()
  return self.game:HasMoreQuestions()
end

function TriviaClassic:GetCurrentQuestionIndex()
  if not self.game or not self.game.GetCurrentQuestionIndex then
    return 0, 0
  end
  return self.game:GetCurrentQuestionIndex()
end

function TriviaClassic:IsGameActive()
  if not self.game or not self.game.IsGameActive then
    return false
  end
  return self.game:IsGameActive()
end

function TriviaClassic:EndGame()
  if self.game and self.game.EndGame then
    return self.game:EndGame()
  end
end

function TriviaClassic:GetCurrentQuestion()
  if not self.game or not self.game.GetCurrentQuestion then
    return nil
  end
  return self.game:GetCurrentQuestion()
end

function TriviaClassic:GetLastWinner()
  if not self.game or not self.game.GetLastWinner then
    return nil, nil, nil, nil
  end
  return self.game:GetLastWinner()
end

function TriviaClassic:GetActiveTeam()
  if not self.game or not self.game.GetActiveTeam then
    return nil, nil
  end
  return self.game:GetActiveTeam()
end

function TriviaClassic:GetPrimaryAction()
  if not self.game or not self.game.GetPrimaryAction then
    return { command = "waiting", label = "Start", enabled = false }
  end
  return self.game:GetPrimaryAction()
end

function TriviaClassic:PerformPrimaryAction(command)
  if not self.game or not self.game.PerformPrimaryAction then
    return nil
  end
  return self.game:PerformPrimaryAction(command)
end

function TriviaClassic:GetPendingWinners()
  if not self.game or not self.game.GetPendingWinners then
    return {}
  end
  return self.game:GetPendingWinners()
end

function TriviaClassic:GetSessionScoreboard()
  if not self.game or not self.game.GetSessionScoreboard then
    return {}, nil, nil
  end
  return self.game:GetSessionScoreboard()
end

function TriviaClassic:GetLeaderboard(limit)
  if not self.game or not self.game.GetLeaderboard then
    return {}, nil, nil
  end
  return self.game:GetLeaderboard(limit)
end

function TriviaClassic:CompleteWinnerBroadcast()
  if not self.game or not self.game.CompleteWinnerBroadcast then
    return true
  end
  return self.game:CompleteWinnerBroadcast()
end

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
