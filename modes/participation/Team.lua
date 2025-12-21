-- Participation: team eligibility.

function TriviaClassic_Participation_Team_CreateState()
  return {}
end

function TriviaClassic_Participation_Team_BeginQuestion(_, _)
  return
end

function TriviaClassic_Participation_Team_NeedsPreAdvance(_)
  return false
end

function TriviaClassic_Participation_Team_PreAdvance(_, _)
  return nil
end

function TriviaClassic_Participation_Team_ActiveLabel(game, _, activeTeamName)
  if not activeTeamName or activeTeamName == "" then
    return nil, nil
  end
  local members = game and game.GetTeamMembers and game:GetTeamMembers(activeTeamName) or nil
  return activeTeamName, members
end

function TriviaClassic_Participation_Team_CanAnswer(game, _, sender, activeTeamName)
  local teamName, teamMembers = game:_resolveTeamInfo(sender)
  if not teamName then
    return { eligible = false }
  end
  -- Enforce active team when a turn-based flow is in effect.
  if activeTeamName and activeTeamName ~= "" and teamName ~= activeTeamName then
    return { eligible = false }
  end
  return { eligible = true, key = teamName, teamName = teamName, teamMembers = teamMembers }
end
