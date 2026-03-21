-- Composes user-visible chat messages (no side effects).
-- Used by Chat to keep string policy (length, prefixes) in one place.

local F = {}
local MAX_CHAT_LEN = 220 -- keep well under WoW's 255 chat limit (leave room for color codes)
local DEFAULT_POINTS = 1
local DEFAULT_QUESTION_COUNT = 10
local DEFAULT_ELAPSED = 0
local SINGULAR_SECOND = 1
local ELLIPSIS = "..."
local ELLIPSIS_LEN = #ELLIPSIS

local function join(arr, sep)
  -- Utility for readable list formatting; keeps nil-safe behavior.
  return table.concat(arr or {}, sep or ", ")
end

local function normalizeConnectionsWord(word)
  -- Connections board output should be visually uniform in chat.
  local text = tostring(word or "")
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  return text:upper()
end

-- Clamp a question chat line to avoid hitting chat length limits.
local function clampQuestionMessage(prefix, questionText, suffix)
  local body = tostring(questionText or "")
  local budget = MAX_CHAT_LEN - (#prefix + #suffix)
  if budget < 0 then budget = 0 end
  if #body > budget then
    local cut = math.max(0, budget - ELLIPSIS_LEN)
    body = body:sub(1, cut) .. ELLIPSIS
  end
  return prefix .. body .. suffix
end

function F.formatStart(meta)
  -- Start announcement includes mode and total count (and team-steal hints).
  -- Called when the host starts a game before the first question is asked.
  local modeLabel = meta.modeLabel or "Fastest answer wins"
  local total = meta.total or DEFAULT_QUESTION_COUNT
  local base = string.format("[Trivia] Game starting! Mode: %s. Questions: %d.", modeLabel, total)
  if meta.mode == "TEAM_STEAL" then
    base = base .. " Team Steal: answer with 'final: <answer>'. Others can steal after a miss/timeout using the same prefix."
  end
  if #base > MAX_CHAT_LEN then
    base = base:sub(1, MAX_CHAT_LEN - ELLIPSIS_LEN) .. ELLIPSIS
  end
  return base
end

function F.formatQuestion(index, total, question, activeTeamName)
  -- Question line includes category, points, and (optionally) active team.
  -- Used for the host's "announce question" action.
  local prefix = string.format("[Trivia] Q%d/%d: ", index, total)
  local suffix = string.format(" (Category: %s, %s pts)", question.category or "General", tostring(question.points or DEFAULT_POINTS))
  if activeTeamName and activeTeamName ~= "" then
    suffix = suffix .. string.format(" [Active team: %s]", activeTeamName)
  end
  return clampQuestionMessage(prefix, question.question, suffix)
end

-- Optional: announce a list of participants for a multi-team head-to-head round
-- participants: array of { team = "Team Name", player = "Player Name" }
function F.formatParticipants(participants)
  -- Head-to-head modes can announce the selected representatives.
  local parts = {}
  for _, p in ipairs(participants or {}) do
    local team = p.team or "Team"
    local player = p.player or "Player"
    table.insert(parts, string.format("%s (%s)", player, team))
  end
  return string.format("[Trivia] Head-to-Head: %s", table.concat(parts, " vs "))
end

function F.formatRerollParticipant(teamName, playerName, prevName)
  -- Used when reselecting a head-to-head participant mid-round.
  local team = teamName or "Team"
  local player = playerName or "Player"
  local prev = prevName and (" (was " .. prevName .. ")") or ""
  return string.format("[Trivia] Head-to-Head: %s now selecting %s%s", team, player, prev)
end

function F.formatActiveTeamReminder(teamName)
  -- Team-steal reminder while waiting for a final answer.
  if teamName and teamName ~= "" then
    return string.format("[Trivia] Waiting on %s to answer (use 'final: ...').", teamName)
  end
end

function F.formatSteal(teamName, question, timer)
  -- Prompt the next team that they have a steal window.
  local label = teamName or "Next team"
  local base = string.format("[Trivia] Steal attempt for %s: %s", label, question and question.question or "the last question")
  if timer then base = base .. string.format(" (%ds)", timer) end
  return base
end

-- When a team misses (incorrect or timeout) and the next team can steal (before opening the steal window).
function F.formatIncorrect(teamName, nextTeamName, reason)
  -- Used when a team misses and the next team can attempt a steal.
  local current = teamName or "Team"
  local nextUp = nextTeamName or "Next team"
  local missText = (reason == "timeout") and "timed out" or "was incorrect"
  return string.format("[Trivia] %s %s. Next up: %s can steal (host: click the button to offer the steal).", current, missText, nextUp)
end

function F.formatWarning(remainingSeconds)
  -- Warning line is short and rounded to avoid frequent spam.
  -- Called by UI timer ticks when remaining time crosses thresholds.
  local seconds = tonumber(remainingSeconds)
  if seconds and seconds >= 0 then
    local rounded = math.ceil(seconds)
    local label = (rounded == SINGULAR_SECOND) and "1 second" or (tostring(rounded) .. " seconds")
    return string.format("[Trivia] %s remaining!", label)
  end
  return "[Trivia] Time remaining!"
end

function F.formatHint(text)
  -- Optional hint line; only emits if a hint is present.
  if text and text ~= "" then
    return "[Trivia] Hint: " .. text
  end
end

local function formatWinnerNames(winners)
  -- Helper for all-correct mode: build a compact winner list.
  local parts = {}
  for _, row in ipairs(winners or {}) do
    if row.teamName then
      local members = row.teamMembers and #row.teamMembers > 0 and (" (" .. table.concat(row.teamMembers, ", ") .. ")") or ""
      table.insert(parts, string.format("%s%s (+%s pts)", row.teamName or "Team", members, tostring(row.points or DEFAULT_POINTS)))
    else
      table.insert(parts, string.format("%s (+%s pts)", row.name or "?", tostring(row.points or DEFAULT_POINTS)))
    end
  end
  return table.concat(parts, ", ")
end

function F.formatWinner(name, elapsed, points, teamName, teamMembers)
  -- Single-winner announcement (solo or team).
  if teamName then
    local members = teamMembers and #teamMembers > 0 and (" (" .. table.concat(teamMembers, ", ") .. ")") or ""
    return string.format("[Trivia] %s answered correctly in %.2fs.%s %s has earned +%s points!", name or "Player", elapsed or DEFAULT_ELAPSED, members, teamName, tostring(points or DEFAULT_POINTS))
  else
    return string.format("[Trivia] %s answered correctly in %.2fs! (+%s pts)", name, elapsed or DEFAULT_ELAPSED, tostring(points or DEFAULT_POINTS))
  end
end

function F.formatWinners(winners, question, mode)
  -- All-correct shows a list; other modes announce the top winner only.
  -- Called when a question closes with one or more correct answers.
  if not winners or #winners == 0 then
    local answersText = question and (question.displayAnswers and table.concat(question.displayAnswers, ", ") or (question.answers and table.concat(question.answers, ", "))) or nil
    return F.formatNoWinner(answersText)
  end
  if mode == "ALL_CORRECT" then
    return string.format("[Trivia] Time's up! %d answered correctly: %s", #winners, formatWinnerNames(winners))
  else
    local first = winners[1]
    return F.formatWinner(first.name, first.elapsed or DEFAULT_ELAPSED, first.points or (question and question.points) or DEFAULT_POINTS, first.teamName, first.teamMembers)
  end
end

function F.formatNoWinner(answersText)
  -- Used when time expires with no correct answers.
  if answersText and answersText ~= "" then
    return string.format("[Trivia] Time is up! No correct answers. Acceptable answers: %s", answersText)
  end
  return "[Trivia] Time is up! No correct answers. Moving on."
end

function F.formatSkipped()
  -- Used when the host skips a question.
  return "[Trivia] Question skipped by host. Moving on."
end

function F.formatEndHeader()
  -- Used at the start of end-of-game scoreboard output.
  return "[Trivia] Game over! Final scores:"
end

function F.formatEndRow(entry)
  -- Row for end-of-game scores (supports teams).
  if entry.members and #entry.members > 0 then
    return string.format("[Trivia] %s - %d pts (%d correct) (%s)", entry.name, entry.points, entry.correct, table.concat(entry.members, ", "))
  end
  return string.format("[Trivia] %s - %d pts (%d correct)", entry.name, entry.points, entry.correct)
end

function F.formatEndFastest(fastestName, fastestTime)
  -- Optional end-of-game fastest-answer line.
  if fastestName and fastestTime then
    return string.format("[Trivia] Speed record this game: %s (%.2fs)", fastestName, fastestTime)
  end
end

function F.formatThanks()
  -- Closing line to end the session.
  return "[Trivia] Thanks for playing!"
end

-- Connections mode formatters

--- Format a Connections puzzle announcement with word grid.
---@param index number Current puzzle index
---@param total number Total puzzles
---@param words string[] Array of 16 (or fewer) words to display
---@param groupsFound number Number of groups already found
---@return string[] messages Array of chat messages
function F.formatConnectionsPuzzle(index, total, words, groupsFound)
  local messages = {}

  -- Header line
  if groupsFound and groupsFound > 0 then
    local remaining = 4 - groupsFound
    table.insert(messages, string.format("[Trivia] %d groups found! %d remaining.", groupsFound, remaining))
  else
    table.insert(messages, string.format("[Trivia] Connections Puzzle %d/%d: Find 4 groups of 4!", index, total))
  end

  -- Display words in rows of 4
  if words and #words > 0 then
    local row = {}
    for i, word in ipairs(words) do
      table.insert(row, normalizeConnectionsWord(word))
      if #row == 4 then
        table.insert(messages, "[Trivia] | " .. table.concat(row, " | ") .. " |")
        row = {}
      end
    end
    -- Handle remaining words if not a multiple of 4
    if #row > 0 then
      table.insert(messages, "[Trivia] | " .. table.concat(row, " | ") .. " |")
    end
  end

  return messages
end

--- Format a solved group announcement.
---@param solver string Player who solved the group
---@param theme string The theme of the group
---@param words string[] The 4 words in the group
---@param points number Points awarded
---@return string
function F.formatGroupSolved(solver, theme, words, points)
  local displayWords = {}
  for _, w in ipairs(words or {}) do
    table.insert(displayWords, normalizeConnectionsWord(w))
  end
  local wordsStr = table.concat(displayWords, ", ")
  return string.format("[Trivia] %s found '%s': %s (+%d pts)",
    solver or "Someone",
    theme or "Group",
    wordsStr,
    points or 100)
end

--- Format remaining words display with status.
---@param words string[] Remaining words
---@param groupsFound number Groups already solved
---@param noNewAnswers boolean Whether there were no new correct answers
---@return string[] messages
function F.formatConnectionsRemaining(words, groupsFound, noNewAnswers)
  local messages = {}

  if noNewAnswers then
    if groupsFound and groupsFound > 0 then
      local remaining = 4 - groupsFound
      table.insert(messages, string.format("[Trivia] %d groups found! %d remaining. (No new correct answers)", groupsFound, remaining))
    else
      table.insert(messages, "[Trivia] No correct answers yet. Find 4 groups of 4!")
    end
  else
    if groupsFound and groupsFound > 0 then
      local remaining = 4 - groupsFound
      table.insert(messages, string.format("[Trivia] %d groups found! %d remaining.", groupsFound, remaining))
    end
  end

  -- Display remaining words in rows of 4
  if words and #words > 0 then
    local row = {}
    for i, word in ipairs(words) do
      table.insert(row, normalizeConnectionsWord(word))
      if #row == 4 then
        table.insert(messages, "[Trivia] | " .. table.concat(row, " | ") .. " |")
        row = {}
      end
    end
    if #row > 0 then
      table.insert(messages, "[Trivia] | " .. table.concat(row, " | ") .. " |")
    end
  end

  return messages
end

--- Format puzzle complete announcement.
---@param solvers table[] Array of { name, totalPoints } for each player who contributed
---@return string
function F.formatConnectionsComplete(solvers)
  if not solvers or #solvers == 0 then
    return "[Trivia] Puzzle complete! No groups were solved."
  end

  local parts = {}
  for _, s in ipairs(solvers) do
    table.insert(parts, string.format("%s (%d pts)", s.name or "?", s.totalPoints or 0))
  end

  return string.format("[Trivia] Puzzle complete! Solvers: %s", table.concat(parts, ", "))
end

TriviaClassic_MessageFormatter = F
