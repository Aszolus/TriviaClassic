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
  { key = "TEAM_STEAL", label = "Team steal (active team, steal with final answer)" },
  { key = "HEAD_TO_HEAD", label = "Head-to-head: one per team, fastest wins" },
}

local DEFAULT_MODE = "FASTEST"

local PARTICIPATION_TYPES = {
  { key = "INDIVIDUAL", label = "Individual" },
  { key = "TEAM", label = "Team (all members)" },
  { key = "HEAD_TO_HEAD", label = "Head-to-Head (one rep per team)" },
}

local FLOW_TYPES = {
  { key = "OPEN", label = "Open" },
  { key = "TURN_BASED", label = "Turn-based" },
  { key = "TURN_BASED_STEAL", label = "Turn-based + Steal" },
}

local SCORING_TYPES = {
  { key = "FASTEST", label = "Fastest wins" },
  { key = "ALL_CORRECT", label = "All correct score" },
}

local ATTEMPT_TYPES = {
  { key = "MULTI", label = "Multiple attempts" },
  { key = "SINGLE_ATTEMPT", label = "Final answer only (one attempt)" },
}

local channelMap = {}
for _, ch in ipairs(CHANNELS) do
  channelMap[ch.key] = ch
end

local modeMap = {}
for _, mode in ipairs(GAME_MODES) do
  modeMap[mode.key] = mode
end

local participationMap = {}
for _, entry in ipairs(PARTICIPATION_TYPES) do
  participationMap[entry.key] = entry
end

local flowMap = {}
for _, entry in ipairs(FLOW_TYPES) do
  flowMap[entry.key] = entry
end

local scoringMap = {}
for _, entry in ipairs(SCORING_TYPES) do
  scoringMap[entry.key] = entry
end

local attemptMap = {}
for _, entry in ipairs(ATTEMPT_TYPES) do
  attemptMap[entry.key] = entry
end

local MODE_AXIS_MAP = {
  FASTEST = { participation = "INDIVIDUAL", flow = "OPEN", scoring = "FASTEST", attempt = "MULTI" },
  ALL_CORRECT = { participation = "INDIVIDUAL", flow = "OPEN", scoring = "ALL_CORRECT", attempt = "MULTI" },
  TEAM = { participation = "TEAM", flow = "OPEN", scoring = "FASTEST", attempt = "MULTI" },
  TEAM_STEAL = { participation = "TEAM", flow = "TURN_BASED_STEAL", scoring = "FASTEST", attempt = "MULTI" },
  HEAD_TO_HEAD = { participation = "HEAD_TO_HEAD", flow = "OPEN", scoring = "FASTEST", attempt = "MULTI" },
}

local AXIS_MODE_MAP = {
  ["INDIVIDUAL|OPEN|FASTEST"] = "FASTEST",
  ["INDIVIDUAL|OPEN|ALL_CORRECT"] = "ALL_CORRECT",
  ["TEAM|OPEN|FASTEST"] = "TEAM",
  ["TEAM|TURN_BASED_STEAL|FASTEST"] = "TEAM_STEAL",
  ["HEAD_TO_HEAD|OPEN|FASTEST"] = "HEAD_TO_HEAD",
}

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

function TriviaClassic_GetParticipationTypes()
  return PARTICIPATION_TYPES
end

function TriviaClassic_GetFlowTypes()
  return FLOW_TYPES
end

function TriviaClassic_GetScoringTypes()
  return SCORING_TYPES
end

function TriviaClassic_GetAttemptTypes()
  return ATTEMPT_TYPES
end

function TriviaClassic_IsValidParticipation(key)
  return participationMap[key] ~= nil
end

function TriviaClassic_IsValidFlow(key)
  return flowMap[key] ~= nil
end

function TriviaClassic_IsValidScoring(key)
  return scoringMap[key] ~= nil
end

function TriviaClassic_IsValidAttempt(key)
  return attemptMap[key] ~= nil
end

function TriviaClassic_GetModeAxisConfig(modeKey)
  local cfg = MODE_AXIS_MAP[modeKey] or MODE_AXIS_MAP[DEFAULT_MODE]
  return {
    participation = cfg.participation,
    flow = cfg.flow,
    scoring = cfg.scoring,
    attempt = cfg.attempt or "MULTI",
  }
end

function TriviaClassic_GetModeKeyFromAxisConfig(config)
  if type(config) ~= "table" then
    return nil
  end
  if config.attempt and config.attempt ~= "MULTI" then
    return nil
  end
  local key = string.format(
    "%s|%s|%s",
    tostring(config.participation or ""),
    tostring(config.flow or ""),
    tostring(config.scoring or "")
  )
  return AXIS_MODE_MAP[key]
end

local function getAxisLabel(map, key)
  local entry = map and map[key]
  return entry and entry.label or nil
end

function TriviaClassic_GetAxisLabel(config)
  if type(config) ~= "table" then
    return nil
  end
  local participation = getAxisLabel(participationMap, config.participation)
  local flow = getAxisLabel(flowMap, config.flow)
  local scoring = getAxisLabel(scoringMap, config.scoring)
  local attempt = getAxisLabel(attemptMap, config.attempt)
  if not participation or not flow or not scoring or not attempt then
    return nil
  end
  return string.format("%s / %s / %s / %s", participation, flow, scoring, attempt)
end
