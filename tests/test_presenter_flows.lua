-- Presenter flow tests (mode-agnostic). Avoid mode-specific logic here.
dofile("core/Constants.lua")
dofile("game/MessageFormatter.lua")
dofile("game/ScoreboardService.lua")
dofile("modes/Registry.lua")
dofile("modes/Fastest.lua")
dofile("game/Game.lua")
dofile("UI/Presenter.lua")
dofile("Repo/QuestionRepository.lua")

local function make_repo(questions)
  local repo = TriviaClassic_CreateRepo()
  repo.sets["Test Set"] = {
    id = "Test Set",
    title = "Test Set",
    categories = { "General" },
    questions = questions,
  }
  return repo
end

local function make_chat()
  return {
    messages = {},
    Send = function(self, msg)
      table.insert(self.messages, msg)
    end,
  }
end

local function make_trivia(mode, questions, store)
  local runtime = TriviaClassic_GetRuntime()
  local repo = make_repo(questions)
  local game = TriviaClassic_CreateGame(repo, store or {}, {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
    getTimer = runtime.chatTransport.getTimer,
    getStealTimer = runtime.chatTransport.getStealTimer,
  })
  game:SetMode(mode)
  local chat = make_chat()
  local trivia = {
    repo = repo,
    game = game,
    chat = chat,
    GetAllSets = function(self)
      return self.repo:GetAllSets()
    end,
    StartGame = function(self, selectedIds, desiredCount, allowedCategories)
      return self.game:Start(selectedIds, desiredCount, allowedCategories, self:GetGameMode())
    end,
    GetPrimaryAction = function(self)
      return self.game:GetPrimaryAction()
    end,
    PerformPrimaryAction = function(self, command)
      return self.game:PerformPrimaryAction(command)
    end,
    GetActiveTeam = function(self)
      return self.game:GetActiveTeam()
    end,
    GetPendingWinners = function(self)
      return self.game:GetPendingWinners()
    end,
    GetCurrentQuestion = function(self)
      return self.game:GetCurrentQuestion()
    end,
    GetLeaderboard = function(self, limit)
      return self.game:GetLeaderboard(limit)
    end,
    GetGameMode = function(self)
      return self.game:GetMode()
    end,
    GetCurrentQuestionIndex = function(self)
      return self.game:GetCurrentQuestionIndex()
    end,
    IsQuestionOpen = function(self)
      return self.game:IsQuestionOpen()
    end,
    SkipCurrentQuestion = function(self)
      return self.game:SkipCurrent()
    end,
    GetTeams = function(self)
      return self.game.GetTeams and self.game:GetTeams() or {}
    end,
    GetTimer = function(self)
      return runtime.chatTransport.getTimer()
    end,
  }
  return trivia, chat, game
end

TC_TEST("Presenter start/question/winner flow", function()
  local trivia, chat, game = make_trivia("FASTEST", {
    { qid = "q1", question = "Q1", answers = { "ok" }, category = "General", categoryKey = "general", points = 1 },
  })
  local presenter = TriviaClassic_UI_CreatePresenter(trivia)

  local meta = presenter:StartGame(1, nil)
  TC_ASSERT_TRUE(meta ~= nil, "start meta")
  TC_ASSERT_TRUE(#chat.messages == 1, "start message sent")

  local result = presenter:AnnounceQuestion()
  TC_ASSERT_TRUE(result and result.question, "question announced")
  TC_ASSERT_TRUE(#chat.messages == 2, "question message sent")

  game:HandleChatAnswer("ok", "Player")
  local announce = presenter:AnnounceWinner()
  TC_ASSERT_TRUE(announce ~= nil, "winner announced")
  TC_ASSERT_TRUE(#chat.messages == 3, "winner message sent")
end)

TC_TEST("Presenter announce no-winner sends answer list", function()
  local trivia, chat, game = make_trivia("FASTEST", {
    { qid = "q1", question = "Q1", answers = { "ok", "yes" }, category = "General", categoryKey = "general", points = 1 },
  })
  local presenter = TriviaClassic_UI_CreatePresenter(trivia)

  presenter:StartGame(1, nil)
  presenter:AnnounceQuestion()
  game:MarkTimeout()

  presenter:AnnounceNoWinner()
  local msg = chat.messages[#chat.messages]
  TC_ASSERT_TRUE(msg and msg:find("Acceptable answers") ~= nil, "no-winner message")
end)

TC_TEST("Presenter all-time scores sends persisted leaderboard lines", function()
  local store = {
    leaderboard = {
      Alice = { points = 5, correct = 3 },
      Bob = { points = 2, correct = 2 },
    },
    fastest = { name = "Alice", time = 1.23 },
  }
  local trivia, chat = make_trivia("FASTEST", {
    { qid = "q1", question = "Q1", answers = { "ok" }, category = "General", categoryKey = "general", points = 1 },
  }, store)
  local presenter = TriviaClassic_UI_CreatePresenter(trivia)

  presenter:ShowAllTimeScores()

  TC_ASSERT_TRUE(#chat.messages >= 3, "header and leaderboard lines sent")
  TC_ASSERT_TRUE(chat.messages[1]:find("All%-time scores:", 1) ~= nil, "all-time header sent")
  TC_ASSERT_TRUE(chat.messages[2]:find("Alice %- 5 pts %(3 correct%)") ~= nil, "leaderboard row sent")
  TC_ASSERT_TRUE(chat.messages[#chat.messages]:find("All%-time fastest: Alice %(1%.23s%)") ~= nil, "fastest line sent")
end)
