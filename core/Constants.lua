-- Channel definitions used by chat routing and UI display.
-- Each entry ties WoW events (incoming) to a send key (outbound).
local CHANNELS = {
  { key = "GUILD", label = "Guild", events = { "CHAT_MSG_GUILD" }, sendKey = "GUILD" },
  { key = "PARTY", label = "Party", events = { "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER" }, sendKey = "PARTY" },
  { key = "RAID", label = "Raid", events = { "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER" }, sendKey = "RAID" },
  { key = "SAY", label = "Say", events = { "CHAT_MSG_SAY" }, sendKey = "SAY" },
  { key = "YELL", label = "Yell", events = { "CHAT_MSG_YELL" }, sendKey = "YELL" },
  { key = "CUSTOM", label = "Custom", events = { "CHAT_MSG_CHANNEL" }, sendKey = "CHANNEL" },
}

-- Default channel if user has not selected one or has an invalid setting.
local DEFAULT_CHANNEL = "GUILD"

-- Game mode definitions used for UI labels and validation.
-- Rules are implemented elsewhere; this is the authoritative list of keys.
local GAME_MODES = {
  { key = "FASTEST", label = "Fastest answer wins" },
  { key = "ALL_CORRECT", label = "All correct answers score (timer based)" },
  { key = "TEAM", label = "Team competition (teams score on correct answers)" },
  { key = "TEAM_STEAL", label = "Team steal (active team, steal with final answer)" },
  { key = "HEAD_TO_HEAD", label = "Head-to-head: one per team, fastest wins" },
}

-- Default mode key if a saved selection is missing/invalid.
local DEFAULT_MODE = "FASTEST"

-- Build lookup tables once for quick access and to avoid repeated iteration.
local channelMap = {}
for _, ch in ipairs(CHANNELS) do
  channelMap[ch.key] = ch
end

local modeMap = {}
for _, mode in ipairs(GAME_MODES) do
  modeMap[mode.key] = mode
end

--- Returns the channel list in display order.
function TriviaClassic_GetChannels()
  return CHANNELS
end

--- Returns the channel lookup map by key.
function TriviaClassic_GetChannelMap()
  return channelMap
end

--- Returns the default channel key.
function TriviaClassic_GetDefaultChannel()
  return DEFAULT_CHANNEL
end

--- Returns the game mode list in display order.
function TriviaClassic_GetGameModes()
  return GAME_MODES
end

--- Returns the game mode lookup map by key.
function TriviaClassic_GetModeMap()
  return modeMap
end

--- Returns the default game mode key.
function TriviaClassic_GetDefaultMode()
  return DEFAULT_MODE
end

--- Returns a user-facing label for a mode key (fallbacks to default).
function TriviaClassic_GetModeLabel(key)
  if modeMap[key] then
    return modeMap[key].label
  end
  return modeMap[DEFAULT_MODE].label
end
