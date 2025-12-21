-- Mode composition (participation + flow + scoring).


function TriviaClassic_BuildAxisHandler(config, modeKey)
  if type(config) ~= "table" then
    return nil
  end
  -- Route axis config to the matching flow builder.
  if config.flow == "OPEN" then
    return TriviaClassic_BuildFlowOpenHandler(config, modeKey)
  end
  if config.flow == "TURN_BASED" then
    return TriviaClassic_BuildFlowTurnBasedHandler(config, modeKey, false)
  end
  if config.flow == "TURN_BASED_STEAL" then
    return TriviaClassic_BuildFlowTurnBasedStealHandler(config, modeKey)
  end
  return nil
end
