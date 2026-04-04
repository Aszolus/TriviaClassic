local MODE_TRUMP_QUOTE = "TRUMP_QUOTE"
local MAX_CHAT_LEN = 220
local ELLIPSIS = "..."

local function normalizePlayerKey(name)
  return tostring(name or ""):lower()
end

local function clampMessage(prefix, body, suffix)
  local text = tostring(body or "")
  local budget = MAX_CHAT_LEN - (#prefix + #suffix)
  if budget < 0 then
    budget = 0
  end
  if #text > budget then
    local cut = math.max(0, budget - #ELLIPSIS)
    text = text:sub(1, cut) .. ELLIPSIS
  end
  return prefix .. text .. suffix
end

local function clampText(text)
  local body = tostring(text or "")
  if #body > MAX_CHAT_LEN then
    local cut = math.max(0, MAX_CHAT_LEN - #ELLIPSIS)
    body = body:sub(1, cut) .. ELLIPSIS
  end
  return body
end

local function shortenPlayerName(name)
  local text = tostring(name or "?")
  local short = text:match("^([^-]+)%-.+$")
  if short and short ~= "" then
    return short
  end
  return text
end

local function getNormalizedAnswer(game, value)
  local A = game and game.deps and game.deps.answer
  if A and A.normalize then
    return A.normalize(value)
  end
  return tostring(value or ""):lower():gsub("%s+", "")
end

local function getVerdict(game, question)
  if not question then
    return nil
  end
  if type(question.verdict) == "string" and question.verdict ~= "" then
    return getNormalizedAnswer(game, question.verdict)
  end
  local answers = question.answers or {}
  if answers[1] then
    return getNormalizedAnswer(game, answers[1])
  end
  return nil
end

local function verdictLabel(game, question, fallback)
  local verdict = getVerdict(game, question) or getNormalizedAnswer(game, fallback)
  if verdict == "real" then
    return "REAL"
  end
  if verdict == "fake" then
    return "FAKE"
  end
  local text = tostring(fallback or "")
  if text == "" then
    return "UNKNOWN"
  end
  return text:upper()
end

local function extractVote(game, rawMsg)
  local A = game and game.deps and game.deps.answer
  local candidate = (A and A.extract and A.extract(rawMsg)) or rawMsg
  local normalized = getNormalizedAnswer(game, candidate)
  if normalized == "real" or normalized == "fake" then
    return normalized
  end
  return nil
end

local function buildPendingWinners(game, ctx)
  local winners = {}
  local verdict = getVerdict(game, game and game:GetCurrentQuestion())
  local points = game:_currentPoints()
  for _, vote in pairs((ctx.data and ctx.data.votesByPlayer) or {}) do
    if vote.guess == verdict then
      table.insert(winners, {
        name = vote.name,
        elapsed = vote.elapsed,
        points = points,
      })
    end
  end
  table.sort(winners, function(a, b)
    local aElapsed = a.elapsed or math.huge
    local bElapsed = b.elapsed or math.huge
    if aElapsed == bElapsed then
      return tostring(a.name or ""):lower() < tostring(b.name or ""):lower()
    end
    return aElapsed < bElapsed
  end)
  return winners
end

local function getCorrectVoteCount(game, ctx)
  return #buildPendingWinners(game, ctx)
end

local function formatRevealSuffix(question)
  local reveal = question and question.reveal
  if reveal and reveal ~= "" then
    return " " .. reveal
  end
  return ""
end

local function buildCompactWinnerSummary(base, winners)
  local names = {}
  for _, row in ipairs(winners or {}) do
    table.insert(names, shortenPlayerName(row.name))
  end

  local prefix = base .. ": "
  local shown = {}
  for i, name in ipairs(names) do
    local trialNames = table.concat(shown, ", ")
    if trialNames ~= "" then
      trialNames = trialNames .. ", "
    end
    trialNames = trialNames .. name

    local remaining = #names - i
    local tail = (remaining > 0) and string.format(", +%d more", remaining) or ""
    local candidate = prefix .. trialNames .. tail .. "."
    if #candidate <= MAX_CHAT_LEN then
      table.insert(shown, name)
    else
      break
    end
  end

  if #shown == 0 then
    return clampText(base .. ".")
  end

  local remaining = #names - #shown
  local tail = (remaining > 0) and string.format(", +%d more", remaining) or ""
  return prefix .. table.concat(shown, ", ") .. tail .. "."
end

local handler = {
  createState = function()
    return {
      votesByPlayer = {},
    }
  end,

  beginQuestion = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
    ctx.data.votesByPlayer = {}
  end,

  evaluateAnswer = function(game, ctx, sender, rawMsg)
    if not game:IsQuestionOpen() then
      return nil
    end

    local question = game:GetCurrentQuestion()
    if not question then
      return nil
    end

    local vote = extractVote(game, rawMsg)
    if not vote then
      return nil
    end

    local verdict = getVerdict(game, question)
    if verdict ~= "real" and verdict ~= "fake" then
      return nil
    end

    local key = normalizePlayerKey(sender)
    local bucket = ctx.data.votesByPlayer or {}
    local existing = bucket[key]
    if existing and existing.guess == vote then
      return nil
    end

    local elapsed = math.max(0.01, game:Now() - (game.state.questionStartTime or game:Now()))
    bucket[key] = {
      name = sender,
      guess = vote,
      elapsed = elapsed,
    }
    ctx.data.votesByPlayer = bucket
    ctx.lastWinnerName = sender
    ctx.lastWinnerTime = elapsed

    return {
      winner = sender,
      elapsed = elapsed,
      mode = ctx.key,
      vote = vote,
      totalWinners = getCorrectVoteCount(game, ctx),
    }
  end,

  onTimeout = function(game, ctx)
    local winners = buildPendingWinners(game, ctx)
    if #winners > 0 then
      for _, row in ipairs(winners) do
        game:_recordCorrectAnswer(row.name, row.elapsed, row.points)
      end
      ctx.pendingWinner = true
      ctx.pendingNoWinner = false
      ctx.lastWinnerName = winners[1].name
      ctx.lastWinnerTime = winners[1].elapsed
    else
      ctx.pendingWinner = false
      ctx.pendingNoWinner = true
    end
  end,

  pendingWinners = function(game, ctx)
    return buildPendingWinners(game, ctx)
  end,

  winnerCount = function(ctx)
    local game = ctx and ctx.gameRef
    if not game then
      return 0
    end
    return getCorrectVoteCount(game, ctx)
  end,

  resetProgress = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.data.votesByPlayer = {}
  end,

  primaryAction = function(game, ctx)
    if not game:IsGameActive() then
      return { command = "waiting", label = "Start", enabled = false }
    end
    if game:IsQuestionOpen() then
      return { command = "waiting", label = "Waiting...", enabled = false }
    end
    if ctx.pendingWinner then
      return { command = "announce_winner", label = "Announce Results", enabled = true }
    end
    if ctx.pendingNoWinner then
      return { command = "announce_no_winner", label = "Reveal Answer", enabled = true }
    end
    if game:HasMoreQuestions() then
      return { command = "announce_question", label = "Next", enabled = true }
    end
    return { command = "end_game", label = "End", enabled = true }
  end,
}

handler.view = {
  onWinnerFound = function(_game, _ctx, result)
    local playerName = result and result.winner or "Someone"
    local vote = result and result.vote or "?"
    return string.format("%s voted %s. Last valid guess counts until time expires.", playerName, tostring(vote):upper())
  end,
}

handler.format = {
  formatStart = function(meta)
    local total = meta and meta.total or 0
    local text = string.format("[Trivia] Game starting! Trump Quote Check. Questions: %d. Decide whether each quote is REAL or FAKE. Type REAL or FAKE before time expires. Your last valid guess counts. +1 for each correct final guess.", total)
    if #text > MAX_CHAT_LEN then
      text = text:sub(1, MAX_CHAT_LEN - #ELLIPSIS) .. ELLIPSIS
    end
    return text
  end,

  formatQuestion = function(index, total, question, _activeTeamName)
    local prefix = string.format("[Trivia] Q%d/%d: REAL or FAKE? \"", index or 0, total or 0)
    local suffix = "\" Type REAL or FAKE now."
    return clampMessage(prefix, question and question.question or "", suffix)
  end,

  formatWinners = function(winners, question)
    if not winners or #winners == 0 then
      return handler.format.formatNoWinner(nil, question)
    end
    local summary = string.format("[Trivia] Time's up! %s.%s %d correct final guesses",
      verdictLabel(nil, question),
      formatRevealSuffix(question),
      #winners)
    return buildCompactWinnerSummary(summary, winners)
  end,

  formatNoWinner = function(answersText, question)
    return string.format("[Trivia] Time's up! %s. No correct final guesses.%s",
      verdictLabel(nil, question, answersText),
      formatRevealSuffix(question))
  end,
}

TriviaClassic_RegisterMode(MODE_TRUMP_QUOTE, handler)
