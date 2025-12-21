local MODE_MAP = TriviaClassic_GetModeMap()
local DEFAULT_MODE = TriviaClassic_GetDefaultMode()

local function normalizeModeKey(modeKey)
  if MODE_MAP[modeKey] then
    return modeKey
  end
  return DEFAULT_MODE
end

local ModeContext = {}
ModeContext.__index = ModeContext

function ModeContext:new(modeKey, handler)
  local o = {
    key = modeKey,
    handler = handler or {},
    data = handler and handler.createState and handler.createState() or {},
    gameRef = nil,
    pendingWinner = false,
    pendingNoWinner = false,
    pendingSteal = false,
    lastWinnerName = nil,
    lastWinnerTime = nil,
    lastTeamName = nil,
    lastTeamMembers = nil,
  }
  setmetatable(o, self)
  return o
end

function ModeContext:BeginQuestion(game)
  if game then
    self.gameRef = game
  end
  self.pendingWinner = false
  self.pendingNoWinner = false
  self.pendingSteal = false
  self.lastWinnerName = nil
  self.lastWinnerTime = nil
  self.lastTeamName = nil
  self.lastTeamMembers = nil
  if self.handler.beginQuestion then
    self.handler.beginQuestion(self, self.gameRef)
  elseif self.data and self.data.correctThisQuestion then
    self.data.correctThisQuestion = {}
  end
end

function ModeContext:HandleCorrect(game, sender, elapsed)
  if self.handler.handleCorrect then
    return self.handler.handleCorrect(game, self, sender, elapsed)
  end
  return nil
end

function ModeContext:EvaluateAnswer(game, sender, rawMsg)
  if self.handler.evaluateAnswer then
    return self.handler.evaluateAnswer(game, self, sender, rawMsg)
  end
  return nil
end

function ModeContext:OnTimeout(game)
  if self.handler.onTimeout then
    return self.handler.onTimeout(game, self)
  end
  self.pendingWinner = false
  self.pendingNoWinner = true
end

function ModeContext:PendingWinners(game)
  if self.handler.pendingWinners then
    return self.handler.pendingWinners(game, self)
  end
  return {}
end

function ModeContext:GetWinnerCount()
  if self.handler.winnerCount then
    return self.handler.winnerCount(self)
  end
  local bucket = self.data and self.data.correctThisQuestion or {}
  local count = 0
  for _ in pairs(bucket) do
    count = count + 1
  end
  return count
end

function ModeContext:ResetProgress()
  self.pendingWinner = false
  self.pendingNoWinner = false
  self.pendingSteal = false
  if self.handler.resetProgress then
    self.handler.resetProgress(self)
  elseif self.data and self.data.correctThisQuestion then
    self.data.correctThisQuestion = {}
  end
end

function ModeContext:GetPrimaryAction(game)
  if self.handler.primaryAction then
    return self.handler.primaryAction(game, self)
  end
  return nil
end

function ModeContext:GetActiveTeam(game)
  if self.handler.getActiveTeam then
    return self.handler.getActiveTeam(game, self)
  end
  return nil, nil
end

local registry = {}

function TriviaClassic_RegisterMode(key, handler)
  if not key or not handler then
    return
  end
  registry[key] = handler
end

local function resolveHandler(modeKey, modeConfig)
  local resolvedKey = normalizeModeKey(modeKey)
  local axisConfig = modeConfig
  if not axisConfig and TriviaClassic_GetModeAxisConfig then
    axisConfig = TriviaClassic_GetModeAxisConfig(resolvedKey)
  end
  -- Prefer composed axis handlers, fall back to legacy registry if needed.
  if axisConfig and TriviaClassic_BuildAxisHandler then
    local composed = TriviaClassic_BuildAxisHandler(axisConfig, resolvedKey)
    if composed then
      return composed
    end
  end
  return registry[resolvedKey] or registry[DEFAULT_MODE]
end

function TriviaClassic_CreateModeState(modeKey, modeConfig)
  local resolvedKey = normalizeModeKey(modeKey)
  local handler = resolveHandler(resolvedKey, modeConfig)
  return ModeContext:new(resolvedKey, handler)
end

-- Expose a resolver so other systems (Presenter/Chat) can access optional
-- handler.view and handler.format without reimplementing registry logic.
function TriviaClassic_GetModeHandler(modeKey, modeConfig)
  return resolveHandler(modeKey, modeConfig)
end
