dofile("core/Constants.lua")
dofile("modes/Registry.lua")
dofile("modes/Team.lua")
dofile("game/Game.lua")

TC_TEST("Game Team mode awards team points", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 2 },
  })
  local store = TC_MAKE_STORE({})
  TC_ADD_TEAM(store, "alpha", "Alpha", { "Alice" })
  TC_ADD_TEAM(store, "beta", "Beta", { "Bob" })

  local runtime = TriviaClassic_GetRuntime()
  local deps = {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
  }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha", Bob = "beta" }))

  local meta = game:Start({ "set" }, 1, nil, "TEAM")
  TC_ASSERT_TRUE(meta ~= nil, "game started")
  game:NextQuestion()

  local noTeam = game:HandleChatAnswer("ok", "Charlie")
  TC_ASSERT_EQ(noTeam, nil, "no team ignored")

  local res = game:HandleChatAnswer("ok", "Alice")
  TC_ASSERT_TRUE(res ~= nil, "team win")
  TC_ASSERT_EQ(res.teamName, "Alpha", "team name")
  TC_ASSERT_TRUE(game:IsPendingWinner(), "pending winner")

  local row = game.state.teamScores["Alpha"]
  TC_ASSERT_EQ(row.points, 2, "team points")
end)
