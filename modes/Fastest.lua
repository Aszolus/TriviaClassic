-- Fastest mode: first correct answer wins, others are ignored.
-- Mode state (ctx) fields:
-- - pendingWinner: true after a correct answer until UI announces it.
-- - pendingNoWinner: true after timeout with no correct answers.
-- - lastWinnerName/lastWinnerTime: cached for announcements/scoreboard.
local MODE_FASTEST = "FASTEST"

local handler = {
  createState = function()
    -- Fresh per-game state object (reset on mode switch).
    return {}
  end,
  beginQuestion = function(ctx)
    -- Called when a question opens; clears previous question flags/results.
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
  end,
  handleCorrect = function(game, ctx, sender, elapsed)
    -- First correct answer closes the question and sets pending winner.
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
    -- No correct answers before timer end -> pending no-winner announcement.
    ctx.pendingWinner = false
    ctx.pendingNoWinner = true
  end,
  pendingWinners = function(game, ctx)
    -- Used by presenter to format the winner announcement.
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
    -- UI uses this to decide whether to show a winner badge/state.
    if ctx.pendingWinner and ctx.lastWinnerName then
      return 1
    end
    return 0
  end,
  primaryAction = function(game, ctx)
    -- Override default flow to surface winner/no-winner announcements.
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

