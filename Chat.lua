local Chat = {}
Chat.__index = Chat

local channelMap = TriviaClassic_GetChannelMap()
local channels = TriviaClassic_GetChannels()

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

function Chat:new()
  local o = {
    channelKey = TriviaClassic_GetDefaultChannel(),
    customName = nil,
    customNameLower = nil,
    customId = nil,
  }
  setmetatable(o, self)
  return o
end

function Chat:SetChannel(key)
  local entry = channelMap[key or TriviaClassic_GetDefaultChannel()]
  self.channelKey = entry and entry.key or TriviaClassic_GetDefaultChannel()
  if key ~= "CUSTOM" then
    self.customName = nil
    self.customNameLower = nil
    self.customId = nil
  end
end

function Chat:SetCustomChannel(name)
  if not name or name == "" then
    return
  end
  self.channelKey = "CUSTOM"
  self.customName = name
  self.customNameLower = name:lower()
  JoinChannelByName(name)
  local id = GetChannelName(name)
  self.customId = id ~= 0 and id or nil
end

function Chat:EnsureCustomChannel()
  if self.channelKey ~= "CUSTOM" or not self.customName then
    return true
  end
  if not self.customId then
    JoinChannelByName(self.customName)
    local id = GetChannelName(self.customName)
    self.customId = id ~= 0 and id or nil
  end
  return self.customId ~= nil
end

function Chat:AcceptsEvent(event, channelName)
  return shouldAccept(event, self.channelKey, channelName, self.customNameLower)
end

local function safeSendMessage(msg, entry, customId)
  if entry.key == "CUSTOM" then
    SendChatMessage(msg, "CHANNEL", nil, customId)
  else
    SendChatMessage(msg, entry.sendKey or entry.key or "GUILD")
  end
end

function Chat:Send(msg)
  local entry = channelMap[self.channelKey]
  if not entry then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff5050[Trivia]|r Invalid channel configured.")
    return
  end
  if self.channelKey == "RAID" and not IsInRaid() then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff5050[Trivia]|r You are not in a raid.")
    return
  end
  if self.channelKey == "PARTY" and not IsInGroup() then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff5050[Trivia]|r You are not in a party.")
    return
  end

  if self.channelKey == "CUSTOM" then
    if not self:EnsureCustomChannel() then
      DEFAULT_CHAT_FRAME:AddMessage("|cffff5050[Trivia]|r Could not join custom channel '" .. (self.customName or "?") .. "'.")
      return
    end
  end

  safeSendMessage(msg, entry, self.customId)
end

local function formatNames(setNames)
  if type(setNames) == "table" then
    return table.concat(setNames, ", ")
  end
  return setNames or "unknown sets"
end

function Chat:SendStart(meta)
  local modeLabel = meta.modeLabel or (meta.mode and TriviaClassic_GetModeLabel(meta.mode)) or "Fastest answer wins"
  self:Send(string.format("[Trivia] Game starting! Mode: %s. %d questions drawn from %s.", modeLabel, meta.total, formatNames(meta.setNames)))
end

function Chat:SendQuestion(index, total, question, activeTeamName)
  local msg = string.format("[Trivia] Q%d/%d: %s (Category: %s, %s pts)", index, total, question.question, question.category or "General", tostring(question.points or 1))
  if activeTeamName and activeTeamName ~= "" then
    msg = msg .. string.format(" [Active team: %s]", activeTeamName)
  end
  self:Send(msg)
end
function Chat:SendActiveTeamReminder(teamName)
  if teamName and teamName ~= "" then
    self:Send(string.format("[Trivia] Waiting on %s to answer (use 'final: ...').", teamName))
  end
end

function Chat:SendSteal(teamName, question, timer)
  local label = teamName or "Next team"
  local base = string.format("[Trivia] Steal attempt for %s: %s", label, question and question.question or "the last question")
  if timer then
    base = base .. string.format(" (%ds)", timer)
  end
  self:Send(base)
end

function Chat:SendWarning()
  self:Send("[Trivia] 10 seconds remaining!")
end

function Chat:SendHint(text)
  if text and text ~= "" then
    self:Send("[Trivia] Hint: " .. text)
  end
end

local function formatWinnerNames(winners)
  local parts = {}
  for _, row in ipairs(winners or {}) do
    if row.teamName then
      local members = row.teamMembers and #row.teamMembers > 0 and (" (" .. table.concat(row.teamMembers, ", ") .. ")") or ""
      table.insert(parts, string.format("%s%s (+%s pts)", row.teamName or "Team", members, tostring(row.points or 1)))
    else
      table.insert(parts, string.format("%s (+%s pts)", row.name or "?", tostring(row.points or 1)))
    end
  end
  return table.concat(parts, ", ")
end

function Chat:SendWinner(name, elapsed, points, teamName, teamMembers)
  if teamName then
    local members = teamMembers and #teamMembers > 0 and (" (" .. table.concat(teamMembers, ", ") .. ")") or ""
    self:Send(string.format("[Trivia] %s answered correctly in %.2fs!%s (+%s pts)", teamName, elapsed or 0, members, tostring(points or 1)))
  else
    self:Send(string.format("[Trivia] %s answered correctly in %.2fs! (+%s pts)", name, elapsed or 0, tostring(points or 1)))
  end
end

function Chat:SendWinners(winners, question, mode)
  if not winners or #winners == 0 then
    self:SendNoWinner(question and (question.displayAnswers and table.concat(question.displayAnswers, ", ") or (question.answers and table.concat(question.answers, ", "))) or nil)
    return
  end
  if mode == "ALL_CORRECT" then
    self:Send(string.format("[Trivia] Time's up! %d answered correctly: %s", #winners, formatWinnerNames(winners)))
  else
    local first = winners[1]
    self:SendWinner(first.name, first.elapsed or 0, first.points or (question and question.points) or 1, first.teamName, first.teamMembers)
  end
end

function Chat:SendNoWinner(answersText)
  if answersText and answersText ~= "" then
    self:Send(string.format("[Trivia] Time is up! No correct answers. Acceptable answers: %s", answersText))
  else
    self:Send("[Trivia] Time is up! No correct answers. Moving on.")
  end
end

function Chat:SendSkipped()
  self:Send("[Trivia] Question skipped by host. Moving on.")
end

function Chat:SendEnd(rows, fastestName, fastestTime)
  self:Send("[Trivia] Game over! Final scores:")
  if not rows or #rows == 0 then
    self:Send("[Trivia] No correct answers recorded.")
  else
    for _, entry in ipairs(rows) do
      local line = nil
      if entry.members and #entry.members > 0 then
        line = string.format("%s - %d pts (%d correct) (%s)", entry.name, entry.points, entry.correct, table.concat(entry.members, ", "))
      else
        line = string.format("%s - %d pts (%d correct)", entry.name, entry.points, entry.correct)
      end
      self:Send("[Trivia] " .. line)
    end
  end
  if fastestName and fastestTime then
    self:Send(string.format("[Trivia] Speed record this game: %s (%.2fs)", fastestName, fastestTime))
  end
  self:Send("[Trivia] Thanks for playing!")
end

function TriviaClassic_CreateChat()
  return Chat:new()
end
