-- Composes user-visible chat messages (no side effects)

local F = {}
local MAX_CHAT_LEN = 220 -- keep well under WoW's 255 chat limit (leave room for color codes)
local MAX_START_SETNAMES = 3 -- only list a few set names in the start message

local function join(arr, sep)
  return table.concat(arr or {}, sep or ", ")
end

-- Clamp a question chat line to avoid hitting chat length limits.
local function clampQuestionMessage(prefix, questionText, suffix)
  local body = tostring(questionText or "")
  local budget = MAX_CHAT_LEN - (#prefix + #suffix)
  if budget < 0 then budget = 0 end
  if #body > budget then
    local cut = math.max(0, budget - 3)
    body = body:sub(1, cut) .. "..."
  end
  return prefix .. body .. suffix
end

function F.formatStart(meta)
  local modeLabel = meta.modeLabel or "Fastest answer wins"
  local total = meta.total or 0
  local base = string.format("[Trivia] Game starting! Mode: %s. Questions: %d.", modeLabel, total)
  if meta.mode == "TEAM_STEAL" then
    base = base .. " Team Steal: answer with 'final: <answer>'. Others can steal after a miss/timeout using the same prefix."
  end
  if #base > MAX_CHAT_LEN then
    base = base:sub(1, MAX_CHAT_LEN - 3) .. "..."
  end
  return base
end

function F.formatQuestion(index, total, question, activeTeamName)
  local prefix = string.format("[Trivia] Q%d/%d: ", index, total)
  local suffix = string.format(" (Category: %s, %s pts)", question.category or "General", tostring(question.points or 1))
  if activeTeamName and activeTeamName ~= "" then
    suffix = suffix .. string.format(" [Active team: %s]", activeTeamName)
  end
  return clampQuestionMessage(prefix, question.question, suffix)
end

-- Optional: announce a list of participants for a multi-team head-to-head round
-- participants: array of { team = "Team Name", player = "Player Name" }
function F.formatParticipants(participants)
  local parts = {}
  for _, p in ipairs(participants or {}) do
    local team = p.team or "Team"
    local player = p.player or "Player"
    table.insert(parts, string.format("%s (%s)", player, team))
  end
  return string.format("[Trivia] Head-to-Head: %s", table.concat(parts, " vs "))
end

function F.formatRerollParticipant(teamName, playerName, prevName)
  local team = teamName or "Team"
  local player = playerName or "Player"
  local prev = prevName and (" (was " .. prevName .. ")") or ""
  return string.format("[Trivia] Head-to-Head: %s now selecting %s%s", team, player, prev)
end

function F.formatActiveTeamReminder(teamName)
  if teamName and teamName ~= "" then
    return string.format("[Trivia] Waiting on %s to answer (use 'final: ...').", teamName)
  end
end

function F.formatSteal(teamName, question, timer)
  local label = teamName or "Next team"
  local base = string.format("[Trivia] Steal attempt for %s: %s", label, question and question.question or "the last question")
  if timer then base = base .. string.format(" (%ds)", timer) end
  return base
end

-- When a team misses (incorrect or timeout) and the next team can steal (before opening the steal window).
function F.formatIncorrect(teamName, nextTeamName, reason)
  local current = teamName or "Team"
  local nextUp = nextTeamName or "Next team"
  local missText = (reason == "timeout") and "timed out" or "was incorrect"
  return string.format("[Trivia] %s %s. Next up: %s can steal (host: click the button to offer the steal).", current, missText, nextUp)
end

function F.formatWarning(remainingSeconds)
  local seconds = tonumber(remainingSeconds)
  if seconds and seconds >= 0 then
    local rounded = math.ceil(seconds)
    local label = (rounded == 1) and "1 second" or (tostring(rounded) .. " seconds")
    return string.format("[Trivia] %s remaining!", label)
  end
  return "[Trivia] Time remaining!"
end

function F.formatHint(text)
  if text and text ~= "" then
    return "[Trivia] Hint: " .. text
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

function F.formatWinner(name, elapsed, points, teamName, teamMembers)
  if teamName then
    local members = teamMembers and #teamMembers > 0 and (" (" .. table.concat(teamMembers, ", ") .. ")") or ""
    return string.format("[Trivia] %s answered correctly in %.2fs.%s %s has earned +%s points!", name or "Player", elapsed or 0, members, teamName, tostring(points or 1))
  else
    return string.format("[Trivia] %s answered correctly in %.2fs! (+%s pts)", name, elapsed or 0, tostring(points or 1))
  end
end

function F.formatWinners(winners, question, mode)
  if not winners or #winners == 0 then
    local answersText = question and (question.displayAnswers and table.concat(question.displayAnswers, ", ") or (question.answers and table.concat(question.answers, ", "))) or nil
    return F.formatNoWinner(answersText)
  end
  if mode == "ALL_CORRECT" then
    return string.format("[Trivia] Time's up! %d answered correctly: %s", #winners, formatWinnerNames(winners))
  else
    local first = winners[1]
    return F.formatWinner(first.name, first.elapsed or 0, first.points or (question and question.points) or 1, first.teamName, first.teamMembers)
  end
end

function F.formatNoWinner(answersText)
  if answersText and answersText ~= "" then
    return string.format("[Trivia] Time is up! No correct answers. Acceptable answers: %s", answersText)
  end
  return "[Trivia] Time is up! No correct answers. Moving on."
end

function F.formatSkipped()
  return "[Trivia] Question skipped by host. Moving on."
end

function F.formatEndHeader()
  return "[Trivia] Game over! Final scores:"
end

function F.formatEndRow(entry)
  if entry.members and #entry.members > 0 then
    return string.format("[Trivia] %s - %d pts (%d correct) (%s)", entry.name, entry.points, entry.correct, table.concat(entry.members, ", "))
  end
  return string.format("[Trivia] %s - %d pts (%d correct)", entry.name, entry.points, entry.correct)
end

function F.formatEndFastest(fastestName, fastestTime)
  if fastestName and fastestTime then
    return string.format("[Trivia] Speed record this game: %s (%.2fs)", fastestName, fastestTime)
  end
end

function F.formatThanks()
  return "[Trivia] Thanks for playing!"
end

TriviaClassic_MessageFormatter = F
