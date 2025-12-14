local MODE_TEAM = "TEAM"

local handler = {
  createState = function()
    return {}
  end,
  beginQuestion = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
    ctx.lastTeamName = nil
    ctx.lastTeamMembers = nil
  end,
  handleCorrect = function(game, ctx, sender, elapsed)
    local teamName, teamMembers = game:_resolveTeamInfo(sender)
    if not teamName then
      return nil
    end
    ctx.pendingWinner = true
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = sender
    ctx.lastWinnerTime = elapsed
    ctx.lastTeamName = teamName
    ctx.lastTeamMembers = teamMembers
    game.state.questionOpen = false
    local points = game:_recordCorrectAnswer(sender, elapsed)
    return {
      winner = sender,
      elapsed = elapsed,
      points = points,
      mode = ctx.key,
      teamName = teamName,
      teamMembers = teamMembers,
      totalWinners = 1,
    }
  end,
  onTimeout = function(_, ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = true
  end,
  pendingWinners = function(game, ctx)
    if not ctx.lastTeamName then
      return {}
    end
    return {
      {
        teamName = ctx.lastTeamName,
        teamMembers = ctx.lastTeamMembers,
        elapsed = ctx.lastWinnerTime,
        points = game:_currentPoints(),
      },
    }
  end,
  winnerCount = function(ctx)
    if ctx.pendingWinner and ctx.lastTeamName then
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

TriviaClassic_RegisterMode(MODE_TEAM, handler)

