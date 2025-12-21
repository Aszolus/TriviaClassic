-- Scoring: Fastest behavior.

local Scoring = {}

function Scoring.createState()
  return {}
end

function Scoring.beginQuestion(ctx)
  ctx.pendingWinner = false
  ctx.pendingNoWinner = false
  ctx.lastWinnerName = nil
  ctx.lastWinnerTime = nil
  ctx.lastTeamName = nil
  ctx.lastTeamMembers = nil
end

function Scoring.handleCorrect(game, ctx, sender, elapsed, modeKey, entry)
  -- Close the question window on the first correct answer.
  ctx.pendingWinner = true
  ctx.pendingNoWinner = false
  ctx.lastWinnerName = sender
  ctx.lastWinnerTime = elapsed
  ctx.lastTeamName = entry.teamName
  ctx.lastTeamMembers = entry.teamMembers
  game.state.questionOpen = false
  local points = game:_recordCorrectAnswer(sender, elapsed)
  return {
    winner = sender,
    elapsed = elapsed,
    points = points,
    mode = modeKey,
    teamName = entry.teamName,
    teamMembers = entry.teamMembers,
    totalWinners = 1,
  }
end

function Scoring.onTimeout(ctx)
  ctx.pendingWinner = false
  ctx.pendingNoWinner = true
end

function Scoring.pendingWinners(game, ctx)
  if not ctx.lastWinnerName and not ctx.lastTeamName then
    return {}
  end
  if ctx.lastTeamName then
    return {
      {
        teamName = ctx.lastTeamName,
        teamMembers = ctx.lastTeamMembers,
        elapsed = ctx.lastWinnerTime,
        points = game:_currentPoints(),
      },
    }
  end
  return {
    {
      name = ctx.lastWinnerName,
      elapsed = ctx.lastWinnerTime,
      points = game:_currentPoints(),
    },
  }
end

function Scoring.winnerCount(ctx)
  if ctx.pendingWinner and (ctx.lastWinnerName or ctx.lastTeamName) then
    return 1
  end
  return 0
end

function Scoring.resetProgress(ctx)
  ctx.pendingWinner = false
  ctx.pendingNoWinner = false
end

function Scoring.winnerLabel()
  return "Announce Winner"
end

TriviaClassic_Scoring_Fastest = Scoring
