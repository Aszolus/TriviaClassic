-- Chat helper for broadcasting and filtering trivia messages.
-- Used by core init to check incoming chat, and by UI/game to send announcements.
---@class Chat
---@field channelKey string Current target channel key (e.g. "GUILD", "PARTY", "CUSTOM")
---@field customName string|nil Name of the custom channel, if any
---@field customNameLower string|nil Lowercased custom channel name cache
---@field customId integer|nil Numeric channel id for custom channel

local Chat = {}
Chat.__index = Chat

local channelMap = TriviaClassic_GetChannelMap()
-- Hard clamp any message to avoid exceeding chat length limits.
local MAX_CHAT_LEN = 245

-- Normalize channel name to a lowercase label (e.g., "1. Custom" -> "custom").
local function baseChannelName(raw)
  if not raw then
    return nil
  end
  if type(raw) == "number" then
    raw = tostring(raw)
  end
  local _, _, clean = raw:find("^[%d]+%.%s*(.+)$")
  return (clean or raw):lower()
end

-- Decide whether an incoming chat event matches the current channel config.
local function shouldAccept(event, key, channelName, customTarget)
  local entry = channelMap[key]
  if not entry then
    return false
  end
  if key == "CUSTOM" then
    return event == "CHAT_MSG_CHANNEL" and baseChannelName(channelName) == (customTarget or "")
  end
  for _, ev in ipairs(entry.events or {}) do
    if ev == event then
      return true
    end
  end
  return false
end

--- Creates a new Chat instance.
---@return Chat
function Chat:new(transport)
  local runtime = TriviaClassic_GetRuntime()
  local resolved = transport or (runtime and runtime.chatTransport)
  local o = {
    -- Defaults are safe for first login (guild if available).
    channelKey = TriviaClassic_GetDefaultChannel(),
    customName = nil,
    customNameLower = nil,
    customId = nil,
    transport = resolved,
  }
  setmetatable(o, self)
  return o
end

--- Sets the outbound channel by key.
---@param key string Channel key from `TriviaClassic_GetChannelMap()` or "CUSTOM".
function Chat:SetChannel(key)
  local entry = channelMap[key or TriviaClassic_GetDefaultChannel()]
  self.channelKey = entry and entry.key or TriviaClassic_GetDefaultChannel()
  if key ~= "CUSTOM" then
    self.customName = nil
    self.customNameLower = nil
    self.customId = nil
  end
end

--- Sets and joins a custom channel by name.
---@param name string
function Chat:SetCustomChannel(name)
  if not name or name == "" then
    return
  end
  self.channelKey = "CUSTOM"
  self.customName = name
  self.customNameLower = name:lower()
  self.transport.joinChannel(name)
  -- Cache channel id for faster send; can be refreshed later.
  self.customId = self.transport.getChannelId(name)
end

--- Ensures the custom channel is joined and has an id.
---@return boolean joined
function Chat:EnsureCustomChannel()
  if self.channelKey ~= "CUSTOM" or not self.customName then
    return true
  end
  if not self.customId then
    self.transport.joinChannel(self.customName)
    self.customId = self.transport.getChannelId(self.customName)
  end
  return self.customId ~= nil
end

--- Whether an incoming chat event is relevant for this chat config.
---@param event string WoW chat event
---@param channelName string|nil Full channel name from event (e.g., "1. Custom")
---@return boolean
function Chat:AcceptsEvent(event, channelName)
  return shouldAccept(event, self.channelKey, channelName, self.customNameLower)
end

--- Sends a raw message to the configured channel.
---@param msg string
function Chat:Send(msg)
  msg = tostring(msg or "")
  if #msg > MAX_CHAT_LEN then
    msg = msg:sub(1, MAX_CHAT_LEN - 3) .. "..."
  end

  local entry = channelMap[self.channelKey]
  if not entry then
    self.transport.system("|cffff5050[Trivia]|r Invalid channel configured.")
    return
  end
  -- Validate channel state before sending (raid/party/custom).
  if self.channelKey == "RAID" and not self.transport.isInRaid() then
    self.transport.system("|cffff5050[Trivia]|r You are not in a raid.")
    return
  end
  if self.channelKey == "PARTY" and not self.transport.isInGroup() then
    self.transport.system("|cffff5050[Trivia]|r You are not in a party.")
    return
  end

  if self.channelKey == "CUSTOM" then
    if not self:EnsureCustomChannel() then
      self.transport.system("|cffff5050[Trivia]|r Could not join custom channel '" .. (self.customName or "?") .. "'.")
      return
    end
  end

  self.transport.send(msg, entry, self.customId)
end

--- Announces the start of a game.
---@param meta table Game metadata (e.g., total, setNames, mode/modeLabel)
function Chat:SendStart(meta)
  -- Format-only; all sending goes through Send().
  local F = TriviaClassic_MessageFormatter
  self:Send(F.formatStart(meta))
end

--- Announces a question to chat.
---@param index integer Current question index (1-based)
---@param total integer Total questions in this game
---@param question table Question object (fields: question, category, points, ...)
---@param activeTeamName string|nil Optional active team label
function Chat:SendQuestion(index, total, question, activeTeamName)
  -- Called from host flow when a new question is announced.
  local F = TriviaClassic_MessageFormatter
  self:Send(F.formatQuestion(index, total, question, activeTeamName))
end
--- Reminds which team is active for final answers.
---@param teamName string|nil Team name
function Chat:SendActiveTeamReminder(teamName)
  local F = TriviaClassic_MessageFormatter
  local msg = F.formatActiveTeamReminder(teamName)
  if msg then self:Send(msg) end
end

--- Announces a steal opportunity.
---@param teamName string|nil Team attempting the steal
---@param question table|nil The question object (optional for context)
---@param timer integer|nil Seconds allowed for steal
function Chat:SendSteal(teamName, question, timer)
  local F = TriviaClassic_MessageFormatter
  self:Send(F.formatSteal(teamName, question, timer))
end

--- Warns that only a short time remains.
---@param remainingSeconds number|nil Seconds remaining on the timer
function Chat:SendWarning(remainingSeconds)
  local F = TriviaClassic_MessageFormatter
  self:Send(F.formatWarning(remainingSeconds))
end

--- Announces a hint, if provided.
---@param text string|nil
function Chat:SendHint(text)
  local F = TriviaClassic_MessageFormatter
  local msg = F.formatHint(text)
  if msg then self:Send(msg) end
end

--- Announces a single winner (player or team).
---@param name string|nil Player name if solo
---@param elapsed number Time in seconds
---@param points integer Points awarded
---@param teamName string|nil Team name if team win
---@param teamMembers string[]|nil Team member display names
function Chat:SendWinner(name, elapsed, points, teamName, teamMembers)
  local F = TriviaClassic_MessageFormatter
  self:Send(F.formatWinner(name, elapsed, points, teamName, teamMembers))
end

--- Announces winners list (all-correct mode) or delegates to SendWinner.
---@param winners table[]
---@param question table|nil
---@param mode string|nil
function Chat:SendWinners(winners, question, mode)
  local F = TriviaClassic_MessageFormatter
  local msg = F.formatWinners(winners, question, mode)
  if msg then self:Send(msg) end
end

--- Announces that no one answered correctly.
---@param answersText string|nil Display-form acceptable answers
function Chat:SendNoWinner(answersText)
  local F = TriviaClassic_MessageFormatter
  self:Send(F.formatNoWinner(answersText))
end

--- Announces that the host skipped the question.
function Chat:SendSkipped()
  local F = TriviaClassic_MessageFormatter
  self:Send(F.formatSkipped())
end

--- Announces end-of-game scores and fastest time.
---@param rows table[] Scoreboard rows
---@param fastestName string|nil
---@param fastestTime number|nil
function Chat:SendEnd(rows, fastestName, fastestTime)
  local F = TriviaClassic_MessageFormatter
  self:Send(F.formatEndHeader())
  if not rows or #rows == 0 then
    self:Send("[Trivia] No correct answers recorded.")
  else
    for _, entry in ipairs(rows) do
      self:Send(F.formatEndRow(entry))
    end
  end
  local fastest = F.formatEndFastest(fastestName, fastestTime)
  if fastest then self:Send(fastest) end
  self:Send(F.formatThanks())
end

--- Factory: creates a new Chat.
---@return Chat
function TriviaClassic_CreateChat(transport)
  return Chat:new(transport)
end
