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

TriviaClassic_RegisterMode(MODE_ALL_CORRECT, handler)

