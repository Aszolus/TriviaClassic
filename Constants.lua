local CHANNELS = {
  { key = "GUILD", label = "Guild", events = { "CHAT_MSG_GUILD" }, sendKey = "GUILD" },
  { key = "PARTY", label = "Party", events = { "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER" }, sendKey = "PARTY" },
  { key = "RAID", label = "Raid", events = { "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER" }, sendKey = "RAID" },
  { key = "SAY", label = "Say", events = { "CHAT_MSG_SAY" }, sendKey = "SAY" },
  { key = "YELL", label = "Yell", events = { "CHAT_MSG_YELL" }, sendKey = "YELL" },
  { key = "CUSTOM", label = "Custom", events = { "CHAT_MSG_CHANNEL" }, sendKey = "CHANNEL" },
}

local DEFAULT_CHANNEL = "GUILD"

local GAME_MODES = {
  { key = "FASTEST", label = "Fastest answer wins" },
  { key = "ALL_CORRECT", label = "All correct answers score (timer based)" },
  { key = "TEAM", label = "Team competition (teams score on correct answers)" },
}

local DEFAULT_MODE = "FASTEST"

local channelMap = {}
for _, ch in ipairs(CHANNELS) do
  channelMap[ch.key] = ch
end

local modeMap = {}
for _, mode in ipairs(GAME_MODES) do
  modeMap[mode.key] = mode
end

function TriviaClassic_GetChannels()
  return CHANNELS
end

function TriviaClassic_GetChannelMap()
  return channelMap
end

function TriviaClassic_GetDefaultChannel()
  return DEFAULT_CHANNEL
end

function TriviaClassic_GetGameModes()
  return GAME_MODES
end

function TriviaClassic_GetModeMap()
  return modeMap
end

function TriviaClassic_GetDefaultMode()
  return DEFAULT_MODE
end

function TriviaClassic_GetModeLabel(key)
  if modeMap[key] then
    return modeMap[key].label
  end
  return modeMap[DEFAULT_MODE].label
end
