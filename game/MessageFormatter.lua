-- Composes user-visible chat messages (no side effects)

local F = {}

local function join(arr, sep)
  return table.concat(arr or {}, sep or ", ")
end

function F.formatStart(meta)
  local modeLabel = meta.modeLabel or "Fastest answer wins"
  local total = meta.total or 0
  local setNames = type(meta.setNames) == "table" and join(meta.setNames, ", ") or (meta.setNames or "unknown sets")
  return string.format("[Trivia] Game starting! Mode: %s. %d questions drawn from %s.", modeLabel, total, setNames)
end

function F.formatQuestion(index, total, question, activeTeamName)
  local msg = string.format("[Trivia] Q%d/%d: %s (Category: %s, %s pts)", index, total, question.question, question.category or "General", tostring(question.points or 1))
  if activeTeamName and activeTeamName ~= "" then
    msg = msg .. string.format(" [Active team: %s]", activeTeamName)
  end
  return msg
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

function F.formatWarning()
  return "[Trivia] 10 seconds remaining!"
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
    return string.format("[Trivia] %s answered correctly in %.2fs!%s (+%s pts)", teamName, elapsed or 0, members, tostring(points or 1))
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
