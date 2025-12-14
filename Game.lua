local Game = {}
Game.__index = Game

local DEFAULT_MIN = 10
local DEFAULT_MAX = 20
local MODE_FASTEST = "FASTEST"
local MODE_ALL_CORRECT = "ALL_CORRECT"
local VALID_MODES = {
  [MODE_FASTEST] = true,
  [MODE_ALL_CORRECT] = true,
}

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

function Game:new(repo, store)
  local o = {
    repo = repo,
    store = store,
    mode = MODE_FASTEST,
    state = {
      activeSets = {},
      gameActive = false,
      gameQuestions = {},
      reserveQuestions = {},
      totalQuestions = 0,
      askedCount = 0,
      currentQuestion = nil,
      questionOpen = false,
      pendingWinner = false,
      pendingNoWinner = false,
      lastWinnerName = nil,
      lastWinnerTime = nil,
      questionStartTime = 0,
      gameScores = {},
      correctThisQuestion = {},
      -- Per-session registry of asked question ids (not persisted). Prevents repeats when changing sets mid-session.
      askedRegistry = {},
    },
  }
  setmetatable(o, self)
  return o
end

function Game:SetMode(modeKey)
  if VALID_MODES[modeKey] then
    self.mode = modeKey
  else
    self.mode = MODE_FASTEST
  end
end

function Game:GetMode()
  if VALID_MODES[self.mode] then
    return self.mode
  end
  return MODE_FASTEST
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
  s.pendingWinner = false
  s.pendingNoWinner = false
  s.lastWinnerName = nil
  s.lastWinnerTime = nil
  s.gameActive = true
  s.gameScores = {}
  s.correctThisQuestion = {}
  s.fastest = nil

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
  s.pendingWinner = false
  s.pendingNoWinner = false
  s.lastWinnerName = nil
  s.lastWinnerTime = nil
  s.questionStartTime = GetTime()
  s.correctThisQuestion = {}
  return s.currentQuestion, s.askedCount, s.totalQuestions
end

function Game:MarkTimeout()
  local s = self.state
  if not s.questionOpen then
    return
  end
  s.questionOpen = false
  if self:GetMode() == MODE_ALL_CORRECT and s.correctThisQuestion and next(s.correctThisQuestion) then
    s.pendingWinner = true
    s.pendingNoWinner = false
  else
    s.pendingWinner = false
    s.pendingNoWinner = true
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
  s.pendingWinner = false
  s.pendingNoWinner = false
  s.currentQuestion = nil
  s.correctThisQuestion = {}
end

local function recordSessionWin(state, playerName, points, elapsed)
  state.gameScores[playerName] = state.gameScores[playerName] or { points = 0, correct = 0, times = {} }
  local row = state.gameScores[playerName]
  row.points = row.points + (points or 1)
  row.correct = row.correct + 1
  table.insert(row.times, elapsed)
end

local function normalizeMessage(msg)
  local s = tostring(msg or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("%s+", " ")

  -- strip punctuation/symbols only at the start/end
  s = s:gsub("^%p+", ""):gsub("%p+$", "")

  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
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

local function recordPersistent(store, sender, points)
  if not store or not sender then
    return
  end
  local entry = ensureLeaderboardEntry(store, sender)
  if not entry then
    return
  end
  entry.points = entry.points + (points or 1)
  entry.correct = entry.correct + 1
  entry.lastCorrect = date("%Y-%m-%d %H:%M")
end

function Game:GetCurrentWinnerCount()
  local bucket = self.state.correctThisQuestion or {}
  local count = 0
  for _ in pairs(bucket) do
    count = count + 1
  end
  return count
end

function Game:_recordCorrectAnswer(sender, elapsed)
  local s = self.state
  local points = s.currentQuestion and s.currentQuestion.points or 1
  recordSessionWin(s, sender, points, elapsed)
  updateFastest(s, self.store, sender, elapsed)
  recordPersistent(self.store, sender, points)
  return points
end

function Game:HandleChatAnswer(msg, sender)
  local s = self.state
  if not s.questionOpen or not s.currentQuestion or s.pendingWinner then
    return nil
  end
  if not sender or sender == "" then
    return nil
  end

  local norm = normalizeMessage(msg)
  for _, ans in ipairs(s.currentQuestion.answers or {}) do
    if norm == ans then
      local elapsed = math.max(0.01, GetTime() - (s.questionStartTime or GetTime()))
      if self:GetMode() == MODE_ALL_CORRECT then
        s.correctThisQuestion = s.correctThisQuestion or {}
        if s.correctThisQuestion[sender] then
          return nil -- already credited for this question
        end
        s.correctThisQuestion[sender] = elapsed
        s.lastWinnerName = sender
        s.lastWinnerTime = elapsed
        local points = self:_recordCorrectAnswer(sender, elapsed)
        return {
          winner = sender,
          elapsed = elapsed,
          points = points,
          mode = MODE_ALL_CORRECT,
          totalWinners = self:GetCurrentWinnerCount(),
        }
      end

      s.questionOpen = false
      s.pendingWinner = true
      s.pendingNoWinner = false
      s.lastWinnerName = sender
      s.lastWinnerTime = elapsed
      local points = self:_recordCorrectAnswer(sender, elapsed)
      return {
        winner = sender,
        elapsed = elapsed,
        points = points,
        mode = MODE_FASTEST,
      }
    end
  end
  return nil
end

function Game:CompleteWinnerBroadcast()
  local s = self.state
  s.pendingWinner = false
  s.pendingNoWinner = false
  s.correctThisQuestion = {}
  return s.askedCount >= s.totalQuestions
end

function Game:CompleteNoWinnerBroadcast()
  local s = self.state
  s.pendingWinner = false
  s.pendingNoWinner = false
  s.correctThisQuestion = {}
  return s.askedCount >= s.totalQuestions
end

function Game:GetSessionScoreboard()
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
  return self.state.pendingWinner
end

function Game:IsPendingNoWinner()
  return self.state.pendingNoWinner
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
  self.state.pendingWinner = false
  self.state.pendingNoWinner = false
  self.state.correctThisQuestion = {}
end

function Game:GetCurrentQuestion()
  return self.state.currentQuestion
end

function Game:GetLastWinner()
  return self.state.lastWinnerName, self.state.lastWinnerTime
end

function Game:GetPendingWinners()
  local winners = {}
  local bucket = self.state.correctThisQuestion or {}
  for name, elapsed in pairs(bucket) do
    table.insert(winners, {
      name = name,
      elapsed = elapsed,
      points = self.state.currentQuestion and self.state.currentQuestion.points or 1,
    })
  end
  table.sort(winners, function(a, b)
    return (a.elapsed or math.huge) < (b.elapsed or math.huge)
  end)
  return winners
end

function TriviaClassic_CreateGame(repo, store)
  return Game:new(repo, store)
end
