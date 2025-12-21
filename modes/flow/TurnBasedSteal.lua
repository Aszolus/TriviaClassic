-- Flow: Turn-based with steal.

local function buildTurnBasedStealHandler(config, modeKey)
  -- Thin wrapper enabling steal behavior.
  return TriviaClassic_BuildFlowTurnBasedHandler(config, modeKey, true)
end

TriviaClassic_BuildFlowTurnBasedStealHandler = buildTurnBasedStealHandler
