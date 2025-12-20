dofile("core/Constants.lua")
dofile("modes/Registry.lua")
dofile("modes/AllCorrect.lua")
dofile("game/Game.lua")

TC_TEST("Game All Correct credits multiple winners", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
  })
  local store = TC_MAKE_STORE({})

  local game = TriviaClassic_CreateGame(repo, store)
  local meta = game:Start({ "set" }, 1, nil, "ALL_CORRECT")
  TC_ASSERT_TRUE(meta ~= nil, "game started")
  game:NextQuestion()

  local a = game:HandleChatAnswer("ok", "Alice")
  TC_ASSERT_TRUE(a ~= nil, "first correct")
  __TC_ADVANCE_TIME(1)
  local b = game:HandleChatAnswer("ok", "Bob")
  TC_ASSERT_TRUE(b ~= nil, "second correct")

  TC_ASSERT_TRUE(game:IsQuestionOpen(), "question stays open")
  TC_ASSERT_EQ(game:GetCurrentWinnerCount(), 2, "winner count")

  game:MarkTimeout()
  TC_ASSERT_TRUE(game:IsPendingWinner(), "pending winner")

  local winners = game:GetPendingWinners()
  TC_ASSERT_EQ(#winners, 2, "winner list")
  TC_ASSERT_EQ(winners[1].name, "Alice", "winner order")

  local done = game:PerformPrimaryAction("announce_winner")
  TC_ASSERT_TRUE(done.finished, "finished")
end)