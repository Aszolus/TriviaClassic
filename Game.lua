local Game = {}
Game.__index = Game

local DEFAULT_MIN = 10
local DEFAULT_MAX = 20

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
    state = {
      activeSets = {},
      gameActive = false,
      gameQuestions = {},
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
    },
  }
  setmetatable(o, self)
  return o
end

function Game:Start(selectedIds, desiredCount, allowedCategories)
  local pool, names = self.repo:BuildPool(selectedIds, allowedCategories)
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
  s.activeSets = selectedIds
  s.gameQuestions = gameQuestions
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

  return {
    total = #gameQuestions,
    setNames = names,
    poolSize = #pool,
  }
end

function Game:NextQuestion()
  local s = self.state
  if not s.gameActive or s.askedCount >= s.totalQuestions then
    return nil
  end
  s.askedCount = s.askedCount + 1
  s.currentQuestion = s.gameQuestions[s.askedCount]
  s.questionOpen = true
  s.pendingWinner = false
  s.pendingNoWinner = false
  s.lastWinnerName = nil
  s.lastWinnerTime = nil
  s.questionStartTime = GetTime()
  return s.currentQuestion, s.askedCount, s.totalQuestions
end

function Game:MarkTimeout()
  local s = self.state
  if not s.questionOpen then
    return
  end
  s.questionOpen = false
  s.pendingNoWinner = true
end

function Game:SkipCurrent()
  local s = self.state
  if not s.questionOpen then
    return
  end
  local idx = s.askedCount
  if idx > 0 then
    local skipped = table.remove(s.gameQuestions, idx)
    if skipped then
      table.insert(s.gameQuestions, skipped) -- move skipped question to the end
    end
    s.totalQuestions = #s.gameQuestions
    s.askedCount = s.askedCount - 1 -- so the next NextQuestion reuses this slot number
  end
  s.questionOpen = false
  s.pendingWinner = false
  s.pendingNoWinner = false
  s.currentQuestion = nil
end

local function recordSessionWin(state, playerName, points, elapsed)
  state.gameScores[playerName] = state.gameScores[playerName] or { points = 0, correct = 0, times = {} }
  local row = state.gameScores[playerName]
  row.points = row.points + (points or 1)
  row.correct = row.correct + 1
  table.insert(row.times, elapsed)
end

local function normalizeMessage(msg)
  return msg:lower():gsub("^%s+", ""):gsub("%s+$", "")
end

function Game:HandleChatAnswer(msg, sender)
  local s = self.state
  if not s.questionOpen or not s.currentQuestion or s.pendingWinner then
    return nil
  end

  local norm = normalizeMessage(msg)
  for _, ans in ipairs(s.currentQuestion.answers or {}) do
    if norm == ans then
      s.questionOpen = false
      s.pendingWinner = true
      s.pendingNoWinner = false
      s.lastWinnerName = sender
      s.lastWinnerTime = math.max(0.01, GetTime() - (s.questionStartTime or GetTime()))
      recordSessionWin(s, sender, s.currentQuestion.points, s.lastWinnerTime)
      -- Track fastest across the session
      if not s.fastest or s.lastWinnerTime < s.fastest.time then
        s.fastest = { name = sender, time = s.lastWinnerTime }
      end
      local entry = ensureLeaderboardEntry(self.store, sender)
      entry.points = entry.points + (s.currentQuestion.points or 1)
      entry.correct = entry.correct + 1
      entry.lastCorrect = date("%Y-%m-%d %H:%M")
      return {
        winner = sender,
        elapsed = s.lastWinnerTime,
        points = s.currentQuestion.points,
      }
    end
  end
  return nil
end

function Game:CompleteWinnerBroadcast()
  local s = self.state
  s.pendingWinner = false
  s.pendingNoWinner = false
  return s.askedCount >= s.totalQuestions
end

function Game:CompleteNoWinnerBroadcast()
  local s = self.state
  s.pendingWinner = false
  s.pendingNoWinner = false
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
    return trimmed
  end
  return list
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
end

function Game:GetCurrentQuestion()
  return self.state.currentQuestion
end

function Game:GetLastWinner()
  return self.state.lastWinnerName, self.state.lastWinnerTime
end

function TriviaClassic_CreateGame(repo, store)
  return Game:new(repo, store)
end
