dofile("core/Constants.lua")
dofile("modes/AxisComposer.lua")
dofile("modes/Registry.lua")
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
  game:SetModeConfig({ participation = "HEAD_TO_HEAD", flow = "OPEN", scoring = "FASTEST" })
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
  TriviaClassic:SetGameAxisConfig({ participation = "HEAD_TO_HEAD", flow = "OPEN", scoring = "FASTEST" })

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

TC_TEST("Head-to-Head rotates and reshuffles per team", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
    { qid = "q2", question = "Q2", answers = { "ok" }, points = 1 },
    { qid = "q3", question = "Q3", answers = { "ok" }, points = 1 },
    { qid = "q4", question = "Q4", answers = { "ok" }, points = 1 },
    { qid = "q5", question = "Q5", answers = { "ok" }, points = 1 },
    { qid = "q6", question = "Q6", answers = { "ok" }, points = 1 },
  })
  local store = TC_MAKE_STORE({})
  TC_ADD_TEAM(store, "alpha", "Alpha", { "Alice", "Bob", "Cara" })
  TC_ADD_TEAM(store, "beta", "Beta", { "Xena", "Yuri" })

  local runtime = TriviaClassic_GetRuntime()
  local deps = { clock = runtime.clock, date = runtime.date, answer = runtime.answer, getTimer = runtime.chatTransport.getTimer }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  game:SetModeConfig({ participation = "HEAD_TO_HEAD", flow = "OPEN", scoring = "FASTEST" })
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha", Bob = "alpha", Cara = "alpha", Xena = "beta", Yuri = "beta" }))

  local queue = { 1, 1, 1, 1, 1, 3, 2, 2, 1, 1, 1 }
  local originalRandom = math.random
  math.random = function(max)
    local v = table.remove(queue, 1) or 1
    if max and v > max then
      v = ((v - 1) % max) + 1
    end
    return v
  end

  local meta = game:Start({ "set" }, 6, nil, "HEAD_TO_HEAD")
  TC_ASSERT_TRUE(meta ~= nil, "game started")

  local function announce_participants()
    local res = game:PerformPrimaryAction("advance")
    return res and res.participants or {}
  end

  local function next_round()
    game:PerformPrimaryAction("advance")
    game:MarkTimeout()
    game:PerformPrimaryAction("announce_no_winner")
  end

  local order1 = {}
  local order2 = {}
  for round = 1, 6 do
    local participants = announce_participants()
    local selected = {}
    for _, p in ipairs(participants) do
      selected[p.team] = p.player
    end
    if round <= 3 then
      table.insert(order1, selected["Alpha"])
    else
      table.insert(order2, selected["Alpha"])
    end
    next_round()
  end

  local cycle1 = order1[1] .. "|" .. order1[2] .. "|" .. order1[3]
  local cycle2 = order2[1] .. "|" .. order2[2] .. "|" .. order2[3]
  local seen = {}
  for _, name in ipairs(order1) do
    seen[name] = (seen[name] or 0) + 1
  end
  TC_ASSERT_EQ(seen["Alice"], 1, "cycle includes Alice")
  TC_ASSERT_EQ(seen["Bob"], 1, "cycle includes Bob")
  TC_ASSERT_EQ(seen["Cara"], 1, "cycle includes Cara")
  TC_ASSERT_TRUE(cycle2 ~= cycle1, "reshuffle changes order")
  math.random = originalRandom
end)

TC_TEST("Head-to-Head skips removed members", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
    { qid = "q2", question = "Q2", answers = { "ok" }, points = 1 },
  })
  local store = TC_MAKE_STORE({})
  TC_ADD_TEAM(store, "alpha", "Alpha", { "Alice", "Bob", "Cara" })
  TC_ADD_TEAM(store, "beta", "Beta", { "Xena" })

  local runtime = TriviaClassic_GetRuntime()
  local deps = { clock = runtime.clock, date = runtime.date, answer = runtime.answer, getTimer = runtime.chatTransport.getTimer }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  game:SetModeConfig({ participation = "HEAD_TO_HEAD", flow = "OPEN", scoring = "FASTEST" })
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha", Bob = "alpha", Cara = "alpha", Xena = "beta" }))

  local queue = { 1, 1, 1, 1, 3, 2 }
  local originalRandom = math.random
  math.random = function(max)
    local v = table.remove(queue, 1) or 1
    if max and v > max then
      v = ((v - 1) % max) + 1
    end
    return v
  end

  game:Start({ "set" }, 2, nil, "HEAD_TO_HEAD")
  local res1 = game:PerformPrimaryAction("advance")
  local picked1 = {}
  for _, p in ipairs(res1.participants or {}) do
    picked1[p.team] = p.player
  end
  TC_ASSERT_EQ(picked1["Alpha"], "Bob", "initial pick")

  -- Remove Bob mid-game and ensure he is not selected on the next cycle.
  store.teams.teams["alpha"].members["bob"] = nil
  game:PerformPrimaryAction("advance")
  game:MarkTimeout()
  game:PerformPrimaryAction("announce_no_winner")

  local res2 = game:PerformPrimaryAction("advance")
  local picked2 = {}
  for _, p in ipairs(res2.participants or {}) do
    picked2[p.team] = p.player
  end
  TC_ASSERT_TRUE(picked2["Alpha"] ~= "Bob", "removed member not selected")

  math.random = originalRandom
end)

TC_TEST("Head-to-Head rerolls a single team participant", function()
  local repo = TC_MAKE_REPO({
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
  })
  local store = TC_MAKE_STORE({})
  TC_ADD_TEAM(store, "alpha", "Alpha", { "Alice", "Bob" })
  TC_ADD_TEAM(store, "beta", "Beta", { "Xena" })

  local runtime = TriviaClassic_GetRuntime()
  local deps = { clock = runtime.clock, date = runtime.date, answer = runtime.answer, getTimer = runtime.chatTransport.getTimer }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  game:SetModeConfig({ participation = "HEAD_TO_HEAD", flow = "OPEN", scoring = "FASTEST" })
  game:SetTeams(TC_MAKE_TEAM_MAP({ Alice = "alpha", Bob = "alpha", Xena = "beta" }))

  local queue = { 1, 1, 1 }
  local originalRandom = math.random
  math.random = function(max)
    local v = table.remove(queue, 1) or 1
    if max and v > max then
      v = ((v - 1) % max) + 1
    end
    return v
  end

  game:Start({ "set" }, 1, nil, "HEAD_TO_HEAD")
  local res = game:PerformPrimaryAction("advance")
  local selected = {}
  for _, p in ipairs(res.participants or {}) do
    selected[p.team] = p.player
  end
  TC_ASSERT_EQ(selected["Alpha"], "Bob", "initial selection")

  local reroll = game:RerollTeam("Alpha")
  TC_ASSERT_TRUE(reroll ~= nil, "reroll result")
  TC_ASSERT_EQ(reroll.player, "Alice", "reroll advances")

  math.random = originalRandom
end)
