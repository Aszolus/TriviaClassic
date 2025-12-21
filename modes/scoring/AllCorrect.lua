-- Scoring: All-correct behavior.

local Scoring = {}

function Scoring.createState()
  return { correctThisQuestion = {} }
end

function Scoring.beginQuestion(ctx)
  ctx.pendingWinner = false
  ctx.pendingNoWinner = false
  ctx.lastWinnerName = nil
  ctx.lastWinnerTime = nil
  ctx.lastTeamName = nil
  ctx.lastTeamMembers = nil
  ctx.data.correctThisQuestion = {}
end

function Scoring.handleCorrect(game, ctx, sender, elapsed, modeKey, entry)
  -- Track unique winners for this question.
  local bucket = ctx.data.correctThisQuestion or {}
  if bucket[entry.key] then
    return nil
  end
  bucket[entry.key] = {
    name = sender,
    teamName = entry.teamName,
    teamMembers = entry.teamMembers,
    elapsed = elapsed,
  }
  ctx.data.correctThisQuestion = bucket
  ctx.lastWinnerName = sender
  ctx.lastWinnerTime = elapsed
  ctx.lastTeamName = entry.teamName
  ctx.lastTeamMembers = entry.teamMembers
  local points = game:_recordCorrectAnswer(sender, elapsed)
  return {
    winner = sender,
    elapsed = elapsed,
    points = points,
    mode = modeKey,
    teamName = entry.teamName,
    teamMembers = entry.teamMembers,
    totalWinners = ctx:GetWinnerCount(),
  }
end

function Scoring.onTimeout(ctx)
  local bucket = ctx.data.correctThisQuestion or {}
  if bucket and next(bucket) then
    ctx.pendingWinner = true
    ctx.pendingNoWinner = false
    return
  end
  ctx.pendingWinner = false
  ctx.pendingNoWinner = true
end

function Scoring.pendingWinners(game, ctx)
  local winners = {}
  local bucket = ctx.data.correctThisQuestion or {}
  local pts = game:_currentPoints()
  for _, row in pairs(bucket) do
    table.insert(winners, {
      name = row.name,
      teamName = row.teamName,
      teamMembers = row.teamMembers,
      elapsed = row.elapsed,
      points = pts,
    })
  end
  table.sort(winners, function(a, b)
    return (a.elapsed or math.huge) < (b.elapsed or math.huge)
  end)
  return winners
end

function Scoring.winnerCount(ctx)
  local bucket = ctx.data.correctThisQuestion or {}
  local count = 0
  for _ in pairs(bucket) do
    count = count + 1
  end
  return count
end

function Scoring.resetProgress(ctx)
  ctx.pendingWinner = false
  ctx.pendingNoWinner = false
  ctx.data.correctThisQuestion = {}
end

function Scoring.winnerLabel()
  return "Announce Results"
end

function Scoring.onWinnerFound(_, ctx, result)
  local winnerName = result and result.winner or ctx.lastWinnerName or "Someone"
  local elapsed = result and result.elapsed or ctx.lastWinnerTime or 0
  local total = (ctx.GetWinnerCount and ctx:GetWinnerCount()) or (result and result.totalWinners) or 1
  local suffix = (total == 1) and "" or "s"
  return string.format("%s answered correctly in %.2fs. %d player%s credited so far; waiting until time expires.", winnerName, elapsed, total, suffix)
end

TriviaClassic_Scoring_AllCorrect = Scoring
