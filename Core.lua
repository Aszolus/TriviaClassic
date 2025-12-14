local addonName, addonPrivate = ...
addonPrivate = addonPrivate or {}

local TriviaClassic = {}
_G.TriviaClassic = TriviaClassic

local DEFAULT_TIMER = 20
local SCHEMA_VERSION = 1
local MODE_MAP = TriviaClassic_GetModeMap()

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

function TriviaClassic:StartGame(selectedIds, desiredCount, allowedCategories)
  if self.game and self.game.SetMode then
    self.game:SetMode(self:GetGameMode())
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

function TriviaClassic:GetPendingWinners()
  if self.game and self.game.GetPendingWinners then
    return self.game:GetPendingWinners()
  end
  return {}
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

local function handleIncomingChat(event, msg, sender, languageName, channelNameFull, _, _, _, _, channelBase)
  -- channelNameFull example: "1. Custom"; channelBase example: "Custom"
  local channelName = channelBase or channelNameFull
  if not TriviaClassic.chat:AcceptsEvent(event, channelName) then
    return
  end
  local winner = TriviaClassic.game:HandleChatAnswer(msg, sender)
  if winner and TriviaClassicUI and TriviaClassicUI.OnWinnerFound then
    TriviaClassicUI:OnWinnerFound(winner)
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
