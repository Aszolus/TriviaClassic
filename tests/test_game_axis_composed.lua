dofile("core/Constants.lua")
dofile("modes/AxisComposer.lua")
dofile("modes/Registry.lua")
dofile("game/Game.lua")

TC_TEST("Axis config composes team rules over fastest mode", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
  })
  local store = TC_MAKE_STORE({})
  TC_ADD_TEAM(store, "alpha", "Alpha", { Alice = "Alice" })

  local runtime = TriviaClassic_GetRuntime()
  local deps = {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
  }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  game:SetModeConfig({ participation = "TEAM", flow = "OPEN", scoring = "FASTEST" })
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha" }))

  local started = game:Start({ "set" }, 1, nil, "FASTEST")
  TC_ASSERT_TRUE(started ~= nil, "game started")

  game:NextQuestion()
  local blocked = game:HandleChatAnswer("ok", "Bob")
  TC_ASSERT_EQ(blocked, nil, "non-team member ignored")

  local result = game:HandleChatAnswer("ok", "Alice")
  TC_ASSERT_TRUE(result ~= nil, "team member accepted")
  TC_ASSERT_EQ(result.teamName, "Alpha", "team name recorded")
end)

TC_TEST("Axis config composes head-to-head with all-correct scoring", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
  })
  local store = TC_MAKE_STORE({})
  TC_ADD_TEAM(store, "alpha", "Alpha", { "Alice" })
  TC_ADD_TEAM(store, "beta", "Beta", { "Bob" })

  local runtime = TriviaClassic_GetRuntime()
  local deps = { clock = runtime.clock, date = runtime.date, answer = runtime.answer }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  game:SetModeConfig({ participation = "HEAD_TO_HEAD", flow = "OPEN", scoring = "ALL_CORRECT" })
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha", Bob = "beta" }))

  local started = game:Start({ "set" }, 1, nil, "HEAD_TO_HEAD")
  TC_ASSERT_TRUE(started ~= nil, "game started")

  local step1 = game:PerformPrimaryAction("advance")
  TC_ASSERT_TRUE(step1 and step1.participants, "participants announced")

  local step2 = game:PerformPrimaryAction("advance")
  TC_ASSERT_TRUE(step2 and step2.question, "question announced")

  local a = game:HandleChatAnswer("ok", "Alice")
  TC_ASSERT_TRUE(a ~= nil, "first correct accepted")
  TC_ASSERT_TRUE(game:IsQuestionOpen(), "question stays open")

  local b = game:HandleChatAnswer("ok", "Bob")
  TC_ASSERT_TRUE(b ~= nil, "second correct accepted")
  TC_ASSERT_TRUE(game:IsQuestionOpen(), "question still open")

  game:MarkTimeout()
  TC_ASSERT_TRUE(game:IsPendingWinner(), "pending winners")
  local winners = game:GetPendingWinners()
  TC_ASSERT_EQ(#winners, 2, "two winners")
end)

TC_TEST("Axis config composes team turn-based steal", function()
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
  game:SetModeConfig({ participation = "TEAM", flow = "TURN_BASED_STEAL", scoring = "FASTEST", attempt = "SINGLE_ATTEMPT" })
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha", Bob = "beta" }))

  local started = game:Start({ "set" }, 1, nil, "TEAM")
  TC_ASSERT_TRUE(started ~= nil, "game started")

  game:NextQuestion()
  local ignored = game:HandleChatAnswer("final: ok", "Bob")
  TC_ASSERT_EQ(ignored, nil, "inactive team ignored")

  local wrong = game:HandleChatAnswer("final: nope", "Alice")
  TC_ASSERT_TRUE(wrong ~= nil, "wrong handled")
  TC_ASSERT_FALSE(game:IsQuestionOpen(), "question closed")

  local action = game:GetPrimaryAction()
  TC_ASSERT_EQ(action.command, "announce_incorrect", "announce incorrect")
end)
