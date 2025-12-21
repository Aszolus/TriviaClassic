-- Participation: individual eligibility.

function TriviaClassic_Participation_Individual_CreateState()
  return {}
end

function TriviaClassic_Participation_Individual_BeginQuestion(_, _)
  return
end

function TriviaClassic_Participation_Individual_NeedsPreAdvance(_)
  return false
end

function TriviaClassic_Participation_Individual_PreAdvance(_, _)
  return nil
end

function TriviaClassic_Participation_Individual_ActiveLabel(_, _, _)
  return nil, nil
end

function TriviaClassic_Participation_Individual_CanAnswer(_, _, sender, _)
  -- Individuals are always eligible to answer.
  return { eligible = true, key = sender }
end
