local MODE_FASTEST = "FASTEST"

local handler = {
  createState = function()
    return {}
  end,
  beginQuestion = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
  end,
  handleCorrect = function(game, ctx, sender, elapsed)
    ctx.pendingWinner = true
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = sender
    ctx.lastWinnerTime = elapsed
    game.state.questionOpen = false
    local points = game:_recordCorrectAnswer(sender, elapsed)
    return {
      winner = sender,
      elapsed = elapsed,
      points = points,
      mode = ctx.key,
      totalWinners = 1,
    }
  end,
  onTimeout = function(_, ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = true
  end,
  pendingWinners = function(game, ctx)
    if not ctx.lastWinnerName then
      return {}
    end
    return {
      {
        name = ctx.lastWinnerName,
        elapsed = ctx.lastWinnerTime,
        points = game:_currentPoints(),
      },
    }
  end,
  winnerCount = function(ctx)
    if ctx.pendingWinner and ctx.lastWinnerName then
      return 1
    end
    return 0
  end,
  primaryAction = function(game, ctx)
    if not game:IsGameActive() then
      return { command = "waiting", label = "Start", enabled = false }
    end
    if game:IsQuestionOpen() then
      return { command = "waiting", label = "Waiting...", enabled = false }
    end
    if ctx.pendingWinner then
      return { command = "announce_winner", label = "Announce Winner", enabled = true }
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

TriviaClassic_RegisterMode(MODE_FASTEST, handler)

