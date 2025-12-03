local addonName, addonPrivate = ...
addonPrivate = addonPrivate or {}

local TriviaClassic = {}
_G.TriviaClassic = TriviaClassic

local DEFAULT_TIMER = 20

TriviaClassic.repo = TriviaClassic_CreateRepo()
TriviaClassic.chat = TriviaClassic_CreateChat()
TriviaClassic.game = nil

local function initDatabase()
  TriviaClassicCharacterDB = TriviaClassicCharacterDB or { scores = {}, leaderboard = {} }
  TriviaClassicCharacterDB.scores = TriviaClassicCharacterDB.scores or {}
  TriviaClassicCharacterDB.leaderboard = TriviaClassicCharacterDB.leaderboard or {}
end

local function initGame()
  TriviaClassic.game = TriviaClassic_CreateGame(TriviaClassic.repo, TriviaClassicCharacterDB)
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

function TriviaClassic:StartGame(selectedIds, desiredCount)
  return self.game:Start(selectedIds, desiredCount)
end

function TriviaClassic:NextQuestion()
  return self.game:NextQuestion()
end

function TriviaClassic:MarkTimeout()
  return self.game:MarkTimeout()
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
  return self.game:GetCurrentQuestionIndex()
end

function TriviaClassic:IsGameActive()
  return self.game:IsGameActive()
end

function TriviaClassic:EndGame()
  return self.game:EndGame()
end

function TriviaClassic:GetCurrentQuestion()
  return self.game:GetCurrentQuestion()
end

function TriviaClassic:GetLastWinner()
  return self.game:GetLastWinner()
end

function TriviaClassic:GetSessionScoreboard()
  return self.game:GetSessionScoreboard()
end

function TriviaClassic:GetLeaderboard(limit)
  return self.game:GetLeaderboard(limit)
end

function TriviaClassic:CompleteWinnerBroadcast()
  return self.game:CompleteWinnerBroadcast()
end

function TriviaClassic:CompleteNoWinnerBroadcast()
  return self.game:CompleteNoWinnerBroadcast()
end

TriviaClassic.DEFAULT_TIMER = DEFAULT_TIMER

local debugLog = {}
local function logDebug(message)
  table.insert(debugLog, message)
  if #debugLog > 50 then
    table.remove(debugLog, 1)
  end
end

local function handleIncomingChat(event, msg, sender, languageName, channelNameFull, _, _, _, _, channelBase)
  -- channelNameFull example: "1. Custom"; channelBase example: "Custom"
  local channelName = channelBase or channelNameFull
  if not TriviaClassic.chat:AcceptsEvent(event, channelName) then
    logDebug(string.format("Ignored: event=%s channel=%s sender=%s", tostring(event), tostring(channelName), tostring(sender)))
    return
  end
  logDebug(string.format("Check: event=%s channel=%s sender=%s msg=%s", tostring(event), tostring(channelName), tostring(sender), tostring(msg)))
  local winner = TriviaClassic.game:HandleChatAnswer(msg, sender)
  if winner and TriviaClassicUI and TriviaClassicUI.OnWinnerFound then
    TriviaClassicUI:OnWinnerFound(winner.winner, winner.elapsed)
    logDebug(string.format("Winner: %s time=%.2f", winner.winner, winner.elapsed or 0))
  elseif winner then
    logDebug("Winner detected but UI not ready")
  end
end

function TriviaClassic_GetDebugLog()
  return debugLog
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
      if not next(TriviaClassic.repo.sets) and addonPrivate and not addonPrivate.__tcRegistered and addonPrivate[1] then
        TriviaClassic.repo:RegisterTriviaBotSet("Embedded Sets", addonPrivate)
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
