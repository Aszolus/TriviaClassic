dofile("core/Constants.lua")
dofile("game/MessageFormatter.lua")
dofile("modes/Registry.lua")
dofile("modes/TrumpQuote.lua")
dofile("game/Game.lua")
dofile("UI/Presenter.lua")
dofile("Repo/QuestionRepository.lua")

local function make_repo(questions)
  local repo = TriviaClassic_CreateRepo()
  repo.sets["Quote Check"] = {
    id = "Quote Check",
    title = "Quote Check",
    modeKeys = {
      TRUMP_QUOTE = true,
    },
    categories = { "Trump Quote Check" },
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

local function make_trivia(questions)
  local runtime = TriviaClassic_GetRuntime()
  local repo = make_repo(questions)
  local game = TriviaClassic_CreateGame(repo, {}, {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
    getTimer = runtime.chatTransport.getTimer,
    getStealTimer = runtime.chatTransport.getStealTimer,
  })
  game:SetMode("TRUMP_QUOTE")
  local chat = make_chat()
  local trivia = {
    repo = repo,
    game = game,
    chat = chat,
    StartGame = function(self, selectedIds, desiredCount, allowedCategories)
      return self.game:Start(selectedIds, desiredCount, allowedCategories, self:GetGameMode())
    end,
    PerformPrimaryAction = function(self, command)
      return self.game:PerformPrimaryAction(command)
    end,
    GetPrimaryAction = function(self)
      return self.game:GetPrimaryAction()
    end,
    GetPendingWinners = function(self)
      return self.game:GetPendingWinners()
    end,
    GetCurrentQuestion = function(self)
      return self.game:GetCurrentQuestion()
    end,
    GetGameMode = function(self)
      return self.game:GetMode()
    end,
    GetActiveTeam = function()
      return nil, nil
    end,
    GetCurrentQuestionIndex = function(self)
      return self.game:GetCurrentQuestionIndex()
    end,
    GetTimer = function()
      return runtime.chatTransport.getTimer()
    end,
  }
  return trivia, chat, game
end

TC_TEST("Presenter no-winner message includes verdict and reveal in Trump Quote mode", function()
  local trivia, chat, game = make_trivia({
    {
      qid = "q1",
      question = "Clouds are basically the ceiling of America.",
      answers = { "fake" },
      displayAnswers = { "FAKE" },
      reveal = "Fake. Written for TriviaClassic.",
      category = "Trump Quote Check",
      categoryKey = "trump quote check",
      points = 1,
    },
  })
  local presenter = TriviaClassic_UI_CreatePresenter(trivia)

  presenter:StartGame(1, nil, { "Quote Check" }, "TRUMP_QUOTE")
  presenter:AnnounceQuestion()
  game:HandleChatAnswer("real", "Alice")
  game:MarkTimeout()

  presenter:AnnounceNoWinner()
  local msg = chat.messages[#chat.messages]
  TC_ASSERT_TRUE(msg and msg:find("FAKE", 1, true) ~= nil, "verdict included")
  TC_ASSERT_TRUE(msg and msg:find("Written for TriviaClassic", 1, true) ~= nil, "reveal included")
end)
