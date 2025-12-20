--- Game state machine for running a trivia session.
---@class Game
local Game = {}
Game.__index = Game

local DEFAULT_MIN = 10
local DEFAULT_MAX = 20
local MODE_FASTEST = "FASTEST"

local MODE_MAP = TriviaClassic_GetModeMap()
local DEFAULT_MODE = TriviaClassic_GetDefaultMode()

local function normalizeModeKey(modeKey)
  if MODE_MAP[modeKey] then
    return modeKey
  end
  return DEFAULT_MODE
end

local function shuffle(list)
  for i = #list, 2, -1 do
    local j = math.random(i)
    list[i], list[j] = list[j], list[i]
  end
end

local function clampCount(poolSize)
  local lower = math.min(DEFAULT_MIN, poolSize)
  local upper = math.min(DEFAULT_MAX, poolSize)
  if lower == 0 then
    return 0
  end
  if upper < lower then
    return lower
  end
  return math.random(lower, upper)
end

local function ensureLeaderboardEntry(store, playerName)
  if not playerName then
    return nil
  end
  store.leaderboard = store.leaderboard or {}
  store.leaderboard[playerName] = store.leaderboard[playerName] or {
    points = 0,
    correct = 0,
    lastCorrect = nil,
  }
  return store.leaderboard[playerName]
end

local function normalizeKey(name)
  if not name then return nil end
  return tostring(name):lower()
end

local function collectTeamMembers(store, teamKey, displayName)
  local list = {}
  if not store or not store.teams or not store.teams.teams then
    return list
  end
  local team = store.teams.teams[teamKey]
  if not team and displayName then
    for key, t in pairs(store.teams.teams) do
      if t.name == displayName then
        team = t
        break
      end
    end
  end
  if not team or not team.members then
    return list
  end
  for _, display in pairs(team.members) do
    table.insert(list, display)
  end
  table.sort(list, function(a, b) return tostring(a or ""):lower() < tostring(b or ""):lower() end)
  return list
end

function Game:new(repo, store, deps)
  local o = {
    repo = repo,
    store = store,
    deps = deps or {},
    mode = normalizeModeKey(MODE_FASTEST),
    state = {
      activeSets = {},
      gameActive = false,
      gameQuestions = {},
      reserveQuestions = {},
      totalQuestions = 0,
      askedCount = 0,
      currentQuestion = nil,
      questionOpen = false,
      questionStartTime = 0,
      gameScores = {},
      teamScores = {},
      fastest = nil,
      -- Per-session registry of asked question ids (not persisted). Prevents repeats when changing sets mid-session.
      askedRegistry = {},
      modeState = TriviaClassic_CreateModeState(normalizeModeKey(MODE_FASTEST)),
    },
    teamMap = {},
  }
  if o.state.modeState then
    o.state.modeState.gameRef = o
  end
  setmetatable(o, self)
  return o
end

function Game:SetMode(modeKey)
  local resolved = normalizeModeKey(modeKey)
  self.mode = resolved
  self.state.modeState = TriviaClassic_CreateModeState(resolved)
  if self.state.modeState then
    self.state.modeState.gameRef = self
  end
end

function Game:GetMode()
  return normalizeModeKey(self.mode)
end

--- Returns the full mode handler for the current mode (logic + optional view/format).
function Game:GetModeHandler()
  if TriviaClassic_GetModeHandler then
    return TriviaClassic_GetModeHandler(self:GetMode())
  end
  return nil
end

function Game:SetTeams(teamMap)
  self.teamMap = teamMap or {}
end

function Game:GetTeamList()
  local list = {}
  if self.store and self.store.teams and self.store.teams.teams then
    for _, team in pairs(self.store.teams.teams) do
      table.insert(list, team.name or "")
    end
  end
  table.sort(list, function(a, b)
    return tostring(a or ""):lower() < tostring(b or ""):lower()
  end)
  return list
end

function Game:GetTeamMembers(teamName)
  return collectTeamMembers(self.store, normalizeKey(teamName), teamName)
end

function Game:_resolveTeamInfo(sender)
  local key = normalizeKey(sender)
  if not key then
    return nil, nil
  end
  local teamKey = self.teamMap and self.teamMap[key]
  if not teamKey then
    return nil, nil
  end
  local teamName = nil
  if self.store and self.store.teams and self.store.teams.teams then
    local team = self.store.teams.teams[teamKey]
    teamName = team and (team.name or teamKey) or teamKey
  end
  local members = collectTeamMembers(self.store, teamKey)
  return teamName or teamKey, members
end

function Game:_modeState()
  local current = self:GetMode()
  if not self.state.modeState or self.state.modeState.key ~= current then
    self.state.modeState = TriviaClassic_CreateModeState(current)
    if self.state.modeState then
      self.state.modeState.gameRef = self
    end
  end
  if self.state.modeState and not self.state.modeState.gameRef then
    self.state.modeState.gameRef = self
  end
  return self.state.modeState
end

function Game:_debug(msg)
  if TriviaClassic and TriviaClassic.IsDebugLogging and TriviaClassic:IsDebugLogging() then
    local logger = TriviaClassic_GetLogger and TriviaClassic_GetLogger()
    if logger and logger.log then
      logger.log("|cffffff00[Trivia Debug]|r " .. tostring(msg))
    end
  end
end

function Game:Now()
  local clock = (self.deps and self.deps.clock) or TriviaClassic_GetRuntime().clock
  return clock.now()
end

function Game:NowDate(fmt)
  local dateFn = (self.deps and self.deps.date) or (TriviaClassic_GetRuntime().date)
  return dateFn(fmt)
end

function Game:_currentPoints()
  if self.state and self.state.currentQuestion and self.state.currentQuestion.points then
    return self.state.currentQuestion.points
  end
  return 1
end

function Game:_initQuestionState()
  local modeState = self:_modeState()
  if modeState and modeState.BeginQuestion then
    modeState:BeginQuestion(self)
  end
end

function Game:Start(selectedIds, desiredCount, allowedCategories, modeKey)
  self:SetMode(modeKey)
  local pool, names = self.repo:BuildPool(selectedIds, allowedCategories)
  if #pool == 0 then
    return nil
  end

  -- Filter out questions that have already been asked this session
  local asked = self.state.askedRegistry or {}
  local filtered = {}
  for _, q in ipairs(pool) do
    local id = q.qid or q.id
    if not id or not asked[id] then
      table.insert(filtered, q)
    end
  end
  pool = filtered
  if #pool == 0 then
    return nil
  end

  shuffle(pool)
  local count = tonumber(desiredCount)
  if not count or count < 1 then
    count = clampCount(#pool)
  end
  if count > #pool then
    count = #pool
  end
  if count == 0 then
    return nil
  end

  local gameQuestions = {}
  for i = 1, count do
    gameQuestions[i] = pool[i]
  end

  local s = self.state
  s.mode = self:GetMode()
  s.activeSets = selectedIds
  s.gameQuestions = gameQuestions
  -- Build a reserve from the remainder of the shuffled pool. This can be large,
  -- which is fine because we only draw from it when replacing skipped questions.
  s.reserveQuestions = {}
  for i = count + 1, #pool do
    table.insert(s.reserveQuestions, pool[i])
  end
  s.totalQuestions = #gameQuestions
  s.askedCount = 0
  s.currentQuestion = nil
  s.questionOpen = false
  s.gameActive = true
  s.gameScores = {}
  s.teamScores = {}
  s.fastest = nil

  local modeState = self:_modeState()
  modeState:ResetProgress()
  modeState.lastWinnerName = nil
  modeState.lastWinnerTime = nil

  return {
    total = #gameQuestions,
    setNames = names,
    poolSize = #pool,
    mode = self:GetMode(),
    modeLabel = TriviaClassic_GetModeLabel(self:GetMode()),
  }
end

function Game:NextQuestion()
  local s = self.state
  if not s.gameActive or s.askedCount >= s.totalQuestions then
    return nil
  end
  s.askedCount = s.askedCount + 1
  s.currentQuestion = s.gameQuestions[s.askedCount]
  -- Mark this question as asked for the current session to avoid repeats across games
  if s.currentQuestion and s.currentQuestion.qid then
    s.askedRegistry[s.currentQuestion.qid] = true
  end
  s.questionOpen = true
  s.questionStartTime = self:Now()
  self:_initQuestionState()
  return s.currentQuestion, s.askedCount, s.totalQuestions
end

function Game:MarkTimeout()
  local s = self.state
  if not s.questionOpen then
    return
  end
  s.questionOpen = false
  local modeState = self:_modeState()
  if modeState and modeState.OnTimeout then
    modeState:OnTimeout(self)
  end
end

function Game:SkipCurrent()
  local s = self.state
  if not s.questionOpen then
    return
  end
  local idx = s.askedCount
  if idx > 0 then
    local skipped = table.remove(s.gameQuestions, idx)
    -- Prefer a fresh replacement from reserve to avoid repeats while keeping
    -- the total number of questions constant for this game.
    local replacement = nil
    if s.reserveQuestions and #s.reserveQuestions > 0 then
      replacement = table.remove(s.reserveQuestions, 1)
    end

    if replacement then
      table.insert(s.gameQuestions, replacement)
    elseif skipped then
      -- Fallback when reserve is exhausted: keep total constant by moving the
      -- skipped question to the end so we can still reach the planned total.
      table.insert(s.gameQuestions, skipped)
    end
    -- totalQuestions remains the same length; step back so NextQuestion reuses this slot
    s.askedCount = s.askedCount - 1 -- so the next NextQuestion reuses this slot number
  end
  s.questionOpen = false
  s.currentQuestion = nil
  local modeState = self:_modeState()
  if modeState and modeState.handler and modeState.handler.onSkip then
    modeState.handler.onSkip(modeState, self)
  end
  modeState:ResetProgress()
end

local function recordSessionWin(state, playerName, points, elapsed)
  state.gameScores[playerName] = state.gameScores[playerName] or { points = 0, correct = 0, times = {} }
  local row = state.gameScores[playerName]
  row.points = row.points + (points or 1)
  row.correct = row.correct + 1
  table.insert(row.times, elapsed)
end

local function recordTeamSessionWin(state, teamName, points)
  if not teamName then
    return
  end
  state.teamScores = state.teamScores or {}
  local row = state.teamScores[teamName] or { points = 0, correct = 0 }
  row.points = row.points + (points or 1)
  row.correct = row.correct + 1
  state.teamScores[teamName] = row
end

local function updateFastest(state, store, sender, elapsed)
  if not sender or not elapsed then
    return
  end
  if not state.fastest or elapsed < (state.fastest.time or math.huge) then
    state.fastest = { name = sender, time = elapsed }
  end
  if store then
    local best = store.fastest
    if not best or (elapsed and elapsed < (best.time or math.huge)) then
      store.fastest = { name = sender, time = elapsed }
    end
  end
end

local function recordPersistent(game, store, sender, points)
  if not store or not sender then
    return
  end
  local entry = ensureLeaderboardEntry(store, sender)
  if not entry then
    return
  end
  entry.points = entry.points + (points or 1)
  entry.correct = entry.correct + 1
  entry.lastCorrect = game:NowDate("%Y-%m-%d %H:%M")
end

function Game:GetCurrentWinnerCount()
  local modeState = self:_modeState()
  if not modeState or not modeState.GetWinnerCount then
    return 0
  end
  return modeState:GetWinnerCount()
end

function Game:_recordCorrectAnswer(sender, elapsed)
  local s = self.state
  local points = s.currentQuestion and s.currentQuestion.points or 1
  recordSessionWin(s, sender, points, elapsed)
  local teamName = select(1, self:_resolveTeamInfo(sender))
  if teamName then
    recordTeamSessionWin(s, teamName, points)
  end
  updateFastest(s, self.store, sender, elapsed)
  recordPersistent(self, self.store, sender, points)
  return points
end

function Game:HandleChatAnswer(msg, sender)
  local s = self.state
  local modeState = self:_modeState()
  if not s.questionOpen or not s.currentQuestion or (modeState and modeState.pendingWinner) then
    return nil
  end
  if not sender or sender == "" then
    return nil
  end

  if modeState and modeState.handler and modeState.handler.evaluateAnswer then
    return modeState:EvaluateAnswer(self, sender, msg)
  end

  local A = _G.TriviaClassic_Answer
  if A and A.match and A.match(msg, s.currentQuestion) then
    local elapsed = math.max(0.01, self:Now() - (s.questionStartTime or self:Now()))
    if modeState and modeState.HandleCorrect then
      return modeState:HandleCorrect(self, sender, elapsed)
    end
    return nil
  end
  return nil
end

function Game:CompleteWinnerBroadcast()
  local s = self.state
  local modeState = self:_modeState()
  modeState:ResetProgress()
  return s.askedCount >= s.totalQuestions
end

function Game:CompleteNoWinnerBroadcast()
  local s = self.state
  local modeState = self:_modeState()
  modeState:ResetProgress()
  return s.askedCount >= s.totalQuestions
end

function Game:GetSessionScoreboard()
  local handler = self.GetModeHandler and self:GetModeHandler() or nil
  if handler and handler.view and type(handler.view.scoreboardRows) == "function" then
    local rows, fastestName, fastestTime = handler.view.scoreboardRows(self)
    if rows then return rows, fastestName, fastestTime end
  end
  local list = {}
  for name, info in pairs(self.state.gameScores or {}) do
    table.insert(list, {
      name = name,
      points = info.points or 0,
      correct = info.correct or 0,
      bestTime = info.times and #info.times > 0 and math.min(unpack(info.times)) or nil,
    })
  end
  table.sort(list, function(a, b)
    if a.points == b.points then
      return (a.correct or 0) > (b.correct or 0)
    end
    return (a.points or 0) > (b.points or 0)
  end)
  local fastestName, fastestTime = nil, nil
  if self.state.fastest then
    fastestName = self.state.fastest.name
    fastestTime = self.state.fastest.time
  end
  return list, fastestName, fastestTime
end

function Game:GetLeaderboard(limit)
  local list = {}
  for name, info in pairs(self.store.leaderboard or {}) do
    table.insert(list, { name = name, points = info.points, correct = info.correct, lastCorrect = info.lastCorrect })
  end
  table.sort(list, function(a, b)
    if a.points == b.points then
      return (a.correct or 0) > (b.correct or 0)
    end
    return (a.points or 0) > (b.points or 0)
  end)
  if limit and #list > limit then
    local trimmed = {}
    for i = 1, limit do
      trimmed[i] = list[i]
    end
    local fastestName, fastestTime = nil, nil
    if self.store and self.store.fastest then
      fastestName = self.store.fastest.name
      fastestTime = self.store.fastest.time
    end
    return trimmed, fastestName, fastestTime
  end
  local fastestName, fastestTime = nil, nil
  if self.store and self.store.fastest then
    fastestName = self.store.fastest.name
    fastestTime = self.store.fastest.time
  end
  return list, fastestName, fastestTime
end

function Game:IsPendingWinner()
  local modeState = self:_modeState()
  return modeState and modeState.pendingWinner or false
end

function Game:IsPendingNoWinner()
  local modeState = self:_modeState()
  return modeState and modeState.pendingNoWinner or false
end

function Game:IsQuestionOpen()
  return self.state.questionOpen
end

function Game:HasMoreQuestions()
  return self.state.askedCount < self.state.totalQuestions
end

function Game:GetCurrentQuestionIndex()
  return self.state.askedCount, self.state.totalQuestions
end

function Game:IsGameActive()
  return self.state.gameActive
end

function Game:EndGame()
  self.state.gameActive = false
  self.state.questionOpen = false
  local modeState = self:_modeState()
  modeState:ResetProgress()
end

function Game:GetCurrentQuestion()
  return self.state.currentQuestion
end

function Game:GetLastWinner()
  local modeState = self:_modeState()
  if not modeState then
    return nil, nil, nil, nil
  end
  return modeState.lastWinnerName, modeState.lastWinnerTime, modeState.lastTeamName, modeState.lastTeamMembers
end

function Game:GetActiveTeam()
  local modeState = self:_modeState()
  if not modeState or not modeState.GetActiveTeam then
    return nil, nil
  end
  return modeState:GetActiveTeam(self)
end

function Game:GetPendingWinners()
  local modeState = self:_modeState()
  if modeState and modeState.PendingWinners then
    return modeState:PendingWinners(self)
  end
  return {}
end

function Game:_defaultPrimaryAction()
  local s = self.state
  if not s or not s.gameActive then
    return { command = "waiting", label = "Start", enabled = false }
  end
  if s.questionOpen then
    return { command = "waiting", label = "Waiting...", enabled = false }
  end
  if self:IsPendingWinner() then
    return { command = "announce_winner", label = "Announce Winner", enabled = true }
  end
  if self:IsPendingNoWinner() then
    return { command = "announce_no_winner", label = "Announce No Winner", enabled = true }
  end
  if self:HasMoreQuestions() then
    return { command = "announce_question", label = "Next", enabled = true }
  end
  return { command = "end_game", label = "End", enabled = true }
end

function Game:GetPrimaryAction()
  local modeState = self:_modeState()
  if modeState and modeState.GetPrimaryAction then
    local action = modeState:GetPrimaryAction(self)
    if action then
      return action
    end
  end
  return self:_defaultPrimaryAction()
end

function Game:PerformPrimaryAction(command)
  local action = command and { command = command } or self:GetPrimaryAction()
  if not action or action.enabled == false or action.command == "waiting" or action.command == "wait" then
    return nil
  end
  local cmd = command or action.command
  if action.command == "advance" or command == "advance" or cmd == "announce_incorrect" then
    local modeState = self:_modeState()
    if modeState and modeState.handler and type(modeState.handler.onAdvance) == "function" then
      return modeState.handler.onAdvance(self, modeState, cmd)
    end
    -- Default advance: behave like announce_question
    local q, idx, total = self:NextQuestion()
    return { command = "announce_question", question = q, index = idx, total = total }
  end
  if action.command == "announce_question" then
    local q, idx, total = self:NextQuestion()
    return { command = action.command, question = q, index = idx, total = total }
  elseif action.command == "announce_winner" then
    local finished = self:CompleteWinnerBroadcast()
    return { command = action.command, finished = finished }
  elseif action.command == "announce_no_winner" then
    local finished = self:CompleteNoWinnerBroadcast()
    return { command = action.command, finished = finished }
  elseif action.command == "end_game" then
    self:EndGame()
    return { command = action.command, finished = true }
  elseif action.command == "start_steal" then
    -- Map legacy start_steal into generic advance
    return self:PerformPrimaryAction("advance")
  end
  return nil
end

function TriviaClassic_CreateGame(repo, store, deps)
  return Game:new(repo, store, deps)
end
