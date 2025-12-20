local MODE_ALL_CORRECT = "ALL_CORRECT"

local handler = {
  createState = function()
    return { correctThisQuestion = {} }
  end,
  beginQuestion = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
    ctx.data.correctThisQuestion = {}
  end,
  handleCorrect = function(game, ctx, sender, elapsed)
    local bucket = ctx.data.correctThisQuestion or {}
    if bucket[sender] then
      return nil -- already credited for this question
    end
    bucket[sender] = elapsed
    ctx.lastWinnerName = sender
    ctx.lastWinnerTime = elapsed
    local points = game:_recordCorrectAnswer(sender, elapsed)
    return {
      winner = sender,
      elapsed = elapsed,
      points = points,
      mode = ctx.key,
      totalWinners = ctx:GetWinnerCount(),
    }
  end,
  onTimeout = function(_, ctx)
    local bucket = ctx.data.correctThisQuestion or {}
    if bucket and next(bucket) then
      ctx.pendingWinner = true
      ctx.pendingNoWinner = false
    else
      ctx.pendingWinner = false
      ctx.pendingNoWinner = true
    end
  end,
  pendingWinners = function(game, ctx)
    local winners = {}
    local bucket = ctx.data.correctThisQuestion or {}
    local pts = game:_currentPoints()
    for name, elapsed in pairs(bucket) do
      table.insert(winners, {
        name = name,
        elapsed = elapsed,
        points = pts,
      })
    end
    table.sort(winners, function(a, b)
      return (a.elapsed or math.huge) < (b.elapsed or math.huge)
    end)
    return winners
  end,
  winnerCount = function(ctx)
    local bucket = ctx.data.correctThisQuestion or {}
    local count = 0
    for _ in pairs(bucket) do
      count = count + 1
    end
    return count
  end,
  resetProgress = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.data.correctThisQuestion = {}
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
      return { command = "announce_no_winner", label = "Announce No Winner", enabled = true }
    end
    if game:HasMoreQuestions() then
      return { command = "announce_question", label = "Next", enabled = true }
    end
    return { command = "end_game", label = "End", enabled = true }
  end,
}

-- View and Format hooks for All Correct mode to keep specifics encapsulated
handler.view = {
  onWinnerFound = function(game, ctx, result)
    local winnerName = result and result.winner or ctx.lastWinnerName or "Someone"
    local elapsed = result and result.elapsed or ctx.lastWinnerTime or 0
    local total = (ctx.GetWinnerCount and ctx:GetWinnerCount()) or (result and result.totalWinners) or 1
    local suffix = (total == 1) and "" or "s"
    return string.format("%s answered correctly in %.2fs. %d player%s credited so far; waiting until time expires.", winnerName, elapsed, total, suffix)
  end,
  evaluateAnswer = function(game, ctx, sender, rawMsg)
    if not game:IsQuestionOpen() then return nil end
    local q = game:GetCurrentQuestion()
    if not q or not q.answers then return nil end
    local A = game.deps.answer
    local candidate = rawMsg
    if A and A.match and A.match(candidate, q) then
      local elapsed = math.max(0.01, game:Now() - (game.state.questionStartTime or game:Now()))
      if ctx.handler and ctx.handler.handleCorrect then
        return ctx.handler.handleCorrect(game, ctx, sender, elapsed)
      end
    end
    return nil
  end,
}

handler.format = {
  formatWinners = function(winners, question)
    local parts = {}
    for _, row in ipairs(winners or {}) do
      table.insert(parts, string.format("%s (+%s pts)", row.name or "?", tostring(row.points or (question and question.points) or 1)))
    end
    return string.format("[Trivia] Time's up! %d answered correctly: %s", #winners, table.concat(parts, ", "))
  end,
}

TriviaClassic_RegisterMode(MODE_ALL_CORRECT, handler)

