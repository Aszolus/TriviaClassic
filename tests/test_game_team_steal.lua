dofile("core/Constants.lua")
dofile("modes/Registry.lua")
dofile("modes/TeamSteal.lua")
dofile("game/Game.lua")

TC_TEST("Game Team Steal flow", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
  })
  local store = TC_MAKE_STORE({})
  TC_ADD_TEAM(store, "alpha", "Alpha", { "Alice" })
  TC_ADD_TEAM(store, "beta", "Beta", { "Bob" })

  local runtime = TriviaClassic_GetRuntime()
  local deps = {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
    getTimer = runtime.chatTransport.getTimer,
    getStealTimer = runtime.chatTransport.getStealTimer,
  }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha", Bob = "beta" }))

  local meta = game:Start({ "set" }, 1, nil, "TEAM_STEAL")
  TC_ASSERT_TRUE(meta ~= nil, "game started")
  game:NextQuestion()

  local active = select(1, game:GetActiveTeam())
  TC_ASSERT_EQ(active, "Alpha", "active team")

  local noPrefix = game:HandleChatAnswer("ok", "Alice")
  TC_ASSERT_EQ(noPrefix, nil, "requires final prefix")
  TC_ASSERT_TRUE(game:IsQuestionOpen(), "question still open")

  local incorrect = game:HandleChatAnswer("final: nope", "Alice")
  TC_ASSERT_TRUE(incorrect ~= nil, "incorrect handled")
  TC_ASSERT_FALSE(game:IsQuestionOpen(), "question closed")

  local action = game:GetPrimaryAction()
  TC_ASSERT_EQ(action.command, "announce_incorrect", "announce incorrect")

  local res1 = game:PerformPrimaryAction("announce_incorrect")
  TC_ASSERT_TRUE(res1.pendingSteal, "pending steal")

  local action2 = game:GetPrimaryAction()
  TC_ASSERT_EQ(action2.command, "advance", "offer steal")

  local res2 = game:PerformPrimaryAction("advance")
  TC_ASSERT_EQ(res2.phase, "steal", "steal phase")
  TC_ASSERT_TRUE(game:IsQuestionOpen(), "question reopened")

  local win = game:HandleChatAnswer("final: ok", "Bob")
  TC_ASSERT_TRUE(win ~= nil, "steal correct")
  TC_ASSERT_EQ(win.teamName, "Beta", "steal team")
end)
