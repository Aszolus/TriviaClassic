dofile("core/Constants.lua")
dofile("modes/Registry.lua")
dofile("modes/HeadToHead.lua")
dofile("game/Game.lua")

TC_TEST("Game Head-to-Head enforces eligibility", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
  })
  local store = TC_MAKE_STORE({})
  TC_ADD_TEAM(store, "alpha", "Alpha", { "Alice" })
  TC_ADD_TEAM(store, "beta", "Beta", { "Bob" })
  TC_ADD_TEAM(store, "charlie", "Charlie", { "Charlie" })

  local runtime = TriviaClassic_GetRuntime()
  local deps = {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
    getTimer = runtime.chatTransport.getTimer,
  }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha", Bob = "beta", Charlie = "charlie" }))

  local meta = game:Start({ "set" }, 1, nil, "HEAD_TO_HEAD")
  TC_ASSERT_TRUE(meta ~= nil, "game started")

  local step1 = game:PerformPrimaryAction("advance")
  TC_ASSERT_TRUE(step1 and step1.participants, "participants announced")
  TC_ASSERT_EQ(#step1.participants, 3, "two participants")

  local eligible = step1.participants[1].player
  local expectedTeam = (eligible == "Alice") and "Alpha" or "Beta"

  local step2 = game:PerformPrimaryAction("advance")
  TC_ASSERT_TRUE(step2 and step2.question, "question announced")

  local ineligible = game:HandleChatAnswer("ok", "Random")
  TC_ASSERT_EQ(ineligible, nil, "ineligible ignored")

  local win = game:HandleChatAnswer("ok", eligible)
  TC_ASSERT_TRUE(win ~= nil, "eligible wins")
  TC_ASSERT_EQ(win.teamName, expectedTeam, "team name")
end)

TC_TEST("Head-to-Head uses team map and enforces eligibility", function()
  TC_RESET_DB()
  dofile("Repo/QuestionRepository.lua")
  dofile("game/Chat.lua")
  dofile("core/Init.lua")

  TriviaClassic:AddTeam("Alpha")
  TriviaClassic:AddTeam("Beta")
  TriviaClassic:AddPlayerToTeam("Alice", "Alpha")
  TriviaClassic:AddPlayerToTeam("Aaron", "Alpha")
  TriviaClassic:AddPlayerToTeam("Bob", "Beta")
  TriviaClassic:AddPlayerToTeam("Bella", "Beta")

  TriviaClassic.repo.sets["Test Set"] = {
    id = "Test Set",
    title = "Test Set",
    categories = { "General" },
    questions = {
      {
        qid = "q1",
        question = "Q1",
        answers = { "ok" },
        category = "General",
        categoryKey = "general",
        points = 1,
      },
    },
  }

  local runtime = TriviaClassic_GetRuntime()
  local db = runtime.storage.get()
  TriviaClassic.game = TriviaClassic_CreateGame(TriviaClassic.repo, db, runtime)
  TriviaClassic:SetGameMode("HEAD_TO_HEAD")

  local meta = TriviaClassic:StartGame({ "Test Set" }, 1, nil)
  TC_ASSERT_TRUE(meta ~= nil, "game started")

  local step1 = TriviaClassic.game:PerformPrimaryAction("advance")
  TC_ASSERT_TRUE(step1 and step1.participants, "participants announced")
  TC_ASSERT_EQ(#step1.participants, 2, "one per team")

  local selectedByTeam = {}
  for _, p in ipairs(step1.participants or {}) do
    selectedByTeam[p.team] = p.player
  end

  local alphaPick = selectedByTeam["Alpha"]
  local betaPick = selectedByTeam["Beta"]
  TC_ASSERT_TRUE(alphaPick ~= nil and betaPick ~= nil, "selected players")

  local step2 = TriviaClassic.game:PerformPrimaryAction("advance")
  TC_ASSERT_TRUE(step2 and step2.question, "question announced")

  local alphaNon = (alphaPick == "Alice") and "Aaron" or "Alice"
  local betaNon = (betaPick == "Bob") and "Bella" or "Bob"
  TC_ASSERT_EQ(TriviaClassic.game:HandleChatAnswer("ok", alphaNon), nil, "non-selected alpha ignored")
  TC_ASSERT_EQ(TriviaClassic.game:HandleChatAnswer("ok", betaNon), nil, "non-selected beta ignored")

  local win = TriviaClassic.game:HandleChatAnswer("ok", alphaPick)
  TC_ASSERT_TRUE(win ~= nil, "selected player wins")
  TC_ASSERT_EQ(win.teamName, "Alpha", "winner team")
end)
