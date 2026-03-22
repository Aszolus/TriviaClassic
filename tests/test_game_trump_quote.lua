dofile("core/Constants.lua")
dofile("modes/Registry.lua")
dofile("modes/TrumpQuote.lua")
dofile("game/Game.lua")

TC_TEST("Trump Quote mode scores final votes on timeout", function()
  local repo = TC_MAKE_REPO({
    {
      qid = "q1",
      question = "Nobody knew that health care could be so complicated.",
      answers = { "real" },
      displayAnswers = { "REAL" },
      reveal = "Real. Trump on health care, February 2017.",
      category = "Trump Quote Check",
      categoryKey = "trump quote check",
      points = 1,
    },
  })
  local store = TC_MAKE_STORE({})
  local runtime = TriviaClassic_GetRuntime()
  local game = TriviaClassic_CreateGame(repo, store, {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
  })

  local meta = game:Start({ "set" }, 1, nil, "TRUMP_QUOTE")
  TC_ASSERT_TRUE(meta ~= nil, "game started")
  game:NextQuestion()

  TC_ASSERT_TRUE(game:HandleChatAnswer("yes", "Alice") == nil, "invalid vote ignored")
  TC_ASSERT_TRUE(game:HandleChatAnswer("real", "Alice") ~= nil, "first valid vote accepted")
  __TC_ADVANCE_TIME(1)
  TC_ASSERT_TRUE(game:HandleChatAnswer("fake", "Bob") ~= nil, "second player vote accepted")
  __TC_ADVANCE_TIME(1)
  TC_ASSERT_TRUE(game:HandleChatAnswer("fake", "Alice") ~= nil, "changed vote accepted")
  TC_ASSERT_EQ(game:GetCurrentWinnerCount(), 0, "no correct final votes after switch")
  __TC_ADVANCE_TIME(1)
  TC_ASSERT_TRUE(game:HandleChatAnswer("real!", "Alice") ~= nil, "punctuation-insensitive vote accepted")
  TC_ASSERT_EQ(game:GetCurrentWinnerCount(), 1, "current correct vote count")

  local rowsBefore = game:GetSessionScoreboard()
  TC_ASSERT_EQ(#rowsBefore, 0, "no score before timeout")

  game:MarkTimeout()
  TC_ASSERT_TRUE(game:IsPendingWinner(), "pending results after timeout")

  local winners = game:GetPendingWinners()
  TC_ASSERT_EQ(#winners, 1, "one credited winner")
  TC_ASSERT_EQ(winners[1].name, "Alice", "last correct vote wins for player")

  local rowsAfter = game:GetSessionScoreboard()
  TC_ASSERT_EQ(#rowsAfter, 1, "score recorded after timeout")
  TC_ASSERT_EQ(rowsAfter[1].name, "Alice", "winner added to scoreboard")
end)

TC_TEST("Trump Quote mode reveals no-winner when all final votes are wrong", function()
  local repo = TC_MAKE_REPO({
    {
      qid = "q2",
      question = "Clouds are basically the ceiling of America.",
      answers = { "fake" },
      displayAnswers = { "FAKE" },
      reveal = "Fake. Written for TriviaClassic.",
      category = "Trump Quote Check",
      categoryKey = "trump quote check",
      points = 1,
    },
  })
  local store = TC_MAKE_STORE({})
  local runtime = TriviaClassic_GetRuntime()
  local game = TriviaClassic_CreateGame(repo, store, {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
  })

  game:Start({ "set" }, 1, nil, "TRUMP_QUOTE")
  game:NextQuestion()
  game:HandleChatAnswer("real", "Alice")
  game:HandleChatAnswer("real", "Bob")

  game:MarkTimeout()
  TC_ASSERT_TRUE(game:IsPendingNoWinner(), "pending no-winner")
  TC_ASSERT_FALSE(game:IsPendingWinner(), "no pending winner")
  TC_ASSERT_EQ(#game:GetPendingWinners(), 0, "no winners returned")
end)
