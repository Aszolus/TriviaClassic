local MODE_FASTEST = "FASTEST"
local MODE_ALL_CORRECT = "ALL_CORRECT"
local MODE_TEAM = "TEAM"

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
    pendingWinner = false,
    pendingNoWinner = false,
    lastWinnerName = nil,
    lastWinnerTime = nil,
  }
  setmetatable(o, self)
  return o
end

function ModeContext:BeginQuestion()
  self.pendingWinner = false
  self.pendingNoWinner = false
  self.lastWinnerName = nil
  self.lastWinnerTime = nil
  if self.handler.beginQuestion then
    self.handler.beginQuestion(self)
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

-- Encapsulated per-mode behaviors; add new entries here to wire new modes.
local handlers = {}

handlers[MODE_FASTEST] = {
  createState = function()
    return {}
  end,
  beginQuestion = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
  end,
  handleCorrect = function(game, ctx, sender, elapsed)
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
    ctx.pendingWinner = false
    ctx.pendingNoWinner = true
  end,
  pendingWinners = function(game, ctx)
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
    if ctx.pendingWinner and ctx.lastWinnerName then
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

handlers[MODE_ALL_CORRECT] = {
  createState = function()
    return { correctThisQuestion = {} }
  end,
  beginQuestion = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
    ctx.data.correctThisQuestion = {}
  end,
  handleCorrect = function(game, ctx, sender, elapsed)
    local bucket = ctx.data.correctThisQuestion or {}
    if bucket[sender] then
      return nil -- already credited for this question
    end
    bucket[sender] = elapsed
    ctx.lastWinnerName = sender
    ctx.lastWinnerTime = elapsed
    local points = game:_recordCorrectAnswer(sender, elapsed)
    return {
      winner = sender,
      elapsed = elapsed,
      points = points,
      mode = ctx.key,
      totalWinners = ctx:GetWinnerCount(),
    }
  end,
  onTimeout = function(_, ctx)
    local bucket = ctx.data.correctThisQuestion or {}
    if bucket and next(bucket) then
      ctx.pendingWinner = true
      ctx.pendingNoWinner = false
    else
      ctx.pendingWinner = false
      ctx.pendingNoWinner = true
    end
  end,
  pendingWinners = function(game, ctx)
    local winners = {}
    local bucket = ctx.data.correctThisQuestion or {}
    local pts = game:_currentPoints()
    for name, elapsed in pairs(bucket) do
      table.insert(winners, {
        name = name,
        elapsed = elapsed,
        points = pts,
      })
    end
    table.sort(winners, function(a, b)
      return (a.elapsed or math.huge) < (b.elapsed or math.huge)
    end)
    return winners
  end,
  winnerCount = function(ctx)
    local bucket = ctx.data.correctThisQuestion or {}
    local count = 0
    for _ in pairs(bucket) do
      count = count + 1
    end
    return count
  end,
  resetProgress = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.data.correctThisQuestion = {}
  end,
  primaryAction = function(game, ctx)
    if not game:IsGameActive() then
      return { command = "waiting", label = "Start", enabled = false }
    end
    if game:IsQuestionOpen() then
      return { command = "waiting", label = "Waiting...", enabled = false }
    end
    if ctx.pendingWinner then
      return { command = "announce_winner", label = "Announce Results", enabled = true }
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

handlers[MODE_TEAM] = {
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

local function resolveHandler(modeKey)
  return handlers[modeKey] or handlers[DEFAULT_MODE]
end

function TriviaClassic_CreateModeState(modeKey)
  local resolvedKey = normalizeModeKey(modeKey)
  local handler = resolveHandler(resolvedKey)
  return ModeContext:new(resolvedKey, handler)
end
