-- View: team scoreboard helper.

function TriviaClassic_View_TeamScoreboard(game)
  local list = {}
  for name, info in pairs((game.state and game.state.teamScores) or {}) do
    table.insert(list, {
      name = name,
      points = info.points or 0,
      correct = info.correct or 0,
      members = game:GetTeamMembers(name),
    })
  end
  -- Sort by points, then correct count.
  table.sort(list, function(a, b)
    if a.points == b.points then
      return (a.correct or 0) > (b.correct or 0)
    end
    return (a.points or 0) > (b.points or 0)
  end)
  local fastestName, fastestTime = nil, nil
  if game.state and game.state.fastest then
    fastestName = game.state.fastest.name
    fastestTime = game.state.fastest.time
  end
  return list, fastestName, fastestTime
end
