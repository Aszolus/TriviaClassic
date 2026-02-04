-- Tests for Connections game mode

dofile("core/Constants.lua")
dofile("modes/Registry.lua")
dofile("modes/Connections.lua")
dofile("game/Game.lua")

local function makePuzzle()
  return {
    qid = "test-puzzle-1",
    Groups = {
      { Theme = "Classic Raid Bosses", Difficulty = 1, Words = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"} },
      { Theme = "Herbs in Felwood", Difficulty = 2, Words = {"Gromsblood", "Dreamfoil", "Plaguebloom", "Arthas"} },
      { Theme = "Warlock Demons", Difficulty = 3, Words = {"Imp", "Voidwalker", "Succubus", "Felhunter"} },
      { Theme = "Alliance Capital Cities", Difficulty = 4, Words = {"Stormwind", "Ironforge", "Darnassus", "Gnomeregan"} },
    }
  }
end

local function makeConnectionsRepo()
  local puzzle = makePuzzle()
  return {
    BuildPool = function(_, _, _)
      -- Return the puzzle as a "question" for the game flow
      return { puzzle }, { "Test Set" }
    end,
  }
end

local function createConnectionsTestGame()
  local repo = makeConnectionsRepo()
  local store = { leaderboard = {}, teams = { teams = {} } }
  local runtime = TriviaClassic_GetRuntime()
  local deps = {
    clock = runtime.clock,
    date = runtime.date,
    answer = runtime.answer,
  }
  local game = TriviaClassic_CreateGame(repo, store, deps)
  return game, store
end

TC_TEST("Connections mode: game starts", function()
  local game = createConnectionsTestGame()
  local started = game:Start({ "set" }, 1, nil, "CONNECTIONS")
  TC_ASSERT_TRUE(started ~= nil, "game started")
  TC_ASSERT_EQ(started.total, 1, "total puzzles")
  TC_ASSERT_EQ(started.mode, "CONNECTIONS", "mode set")
end)

TC_TEST("Connections mode: next question returns puzzle", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q, idx, total = game:NextQuestion()
  TC_ASSERT_TRUE(q ~= nil, "puzzle returned")
  TC_ASSERT_EQ(idx, 1, "puzzle index")
  TC_ASSERT_EQ(total, 1, "total puzzles")
  TC_ASSERT_TRUE(q.Groups ~= nil, "puzzle has groups")
end)

TC_TEST("Connections mode: set puzzle and beginQuestion", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TC_ASSERT_TRUE(q ~= nil, "puzzle returned")

  -- Set the puzzle on mode state
  TriviaClassic_Connections_SetPuzzle(game, q)

  -- Get puzzle data
  local data = TriviaClassic_Connections_GetPuzzleData(game)
  TC_ASSERT_TRUE(data ~= nil, "puzzle data available")
  TC_ASSERT_TRUE(data.puzzle ~= nil, "puzzle set")
  TC_ASSERT_EQ(#data.puzzle.Groups, 4, "4 groups")
end)

TC_TEST("Connections mode: solve one group", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  -- Reinitialize the question state with the puzzle set
  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  -- Try to solve group 1
  local result = game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")
  TC_ASSERT_TRUE(result ~= nil, "correct group detected")
  TC_ASSERT_EQ(result.groupIndex, 1, "group 1 solved")
  TC_ASSERT_EQ(result.solver, "Alice", "solver recorded")
  TC_ASSERT_EQ(result.points, 100, "difficulty 1 = 100 points")
end)

TC_TEST("Connections mode: wrong guess returns nil", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  -- Try an incorrect guess (mixing groups)
  local result = game:HandleChatAnswer("ragnaros gromsblood imp stormwind", "Alice")
  TC_ASSERT_EQ(result, nil, "wrong guess returns nil")
end)

TC_TEST("Connections mode: pending solves tracked", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")

  local data = TriviaClassic_Connections_GetPuzzleData(game)
  TC_ASSERT_TRUE(data.pendingSolves ~= nil, "pending solves exists")
  TC_ASSERT_EQ(#data.pendingSolves, 1, "1 pending solve")
  TC_ASSERT_EQ(data.pendingSolves[1].solver, "Alice", "Alice pending")
end)

TC_TEST("Connections mode: multiple solves before announce", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")
  game:HandleChatAnswer("gromsblood dreamfoil plaguebloom arthas", "Bob")

  local data = TriviaClassic_Connections_GetPuzzleData(game)
  TC_ASSERT_EQ(#data.pendingSolves, 2, "2 pending solves")
  TC_ASSERT_EQ(data.pendingSolves[1].solver, "Alice", "Alice first")
  TC_ASSERT_EQ(data.pendingSolves[2].solver, "Bob", "Bob second")
end)

TC_TEST("Connections mode: duplicate solve ignored", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")
  local second = game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Bob")

  TC_ASSERT_EQ(second, nil, "duplicate solve returns nil")

  local data = TriviaClassic_Connections_GetPuzzleData(game)
  TC_ASSERT_EQ(#data.pendingSolves, 1, "only first solve counted")
end)

TC_TEST("Connections mode: primary action shows announce when pending", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")

  local action = game:GetPrimaryAction()
  TC_ASSERT_EQ(action.command, "announce_winner", "should announce")
  TC_ASSERT_TRUE(action.label:find("Announce"), "label contains Announce")
end)

TC_TEST("Connections mode: primary action shows show_words when no pending", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  local action = game:GetPrimaryAction()
  TC_ASSERT_EQ(action.command, "show_words", "should show words")
  TC_ASSERT_EQ(action.label, "Show Words", "label is Show Words")
end)

TC_TEST("Connections mode: reset moves pending to announced", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")

  -- Simulate announcing (reset progress)
  ctx:ResetProgress()

  local data = TriviaClassic_Connections_GetPuzzleData(game)
  TC_ASSERT_EQ(#data.pendingSolves, 0, "pending cleared")
  TC_ASSERT_TRUE(data.announcedGroups[1], "group 1 announced")
end)

TC_TEST("Connections mode: remaining words updated after announce", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  local dataBefore = TriviaClassic_Connections_GetPuzzleData(game)
  TC_ASSERT_EQ(#dataBefore.remainingWords, 16, "16 words initially")

  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")
  ctx:ResetProgress()

  local dataAfter = TriviaClassic_Connections_GetPuzzleData(game)
  TC_ASSERT_EQ(#dataAfter.remainingWords, 12, "12 words after solving 1 group")
end)

TC_TEST("Connections mode: pendingWinners returns solve info", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")

  local winners = game:GetPendingWinners()
  TC_ASSERT_TRUE(winners ~= nil, "winners returned")
  TC_ASSERT_EQ(#winners, 1, "1 winner")
  TC_ASSERT_EQ(winners[1].name, "Alice", "Alice is winner")
  TC_ASSERT_EQ(winners[1].theme, "Classic Raid Bosses", "theme included")
end)

TC_TEST("Connections mode: difficulty points", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  -- Group 1 is difficulty 1 = 100 pts
  local r1 = game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")
  TC_ASSERT_EQ(r1.points, 100, "difficulty 1 = 100 pts")

  -- Group 3 is difficulty 3 = 300 pts
  local r3 = game:HandleChatAnswer("imp voidwalker succubus felhunter", "Bob")
  TC_ASSERT_EQ(r3.points, 300, "difficulty 3 = 300 pts")
end)

TC_TEST("Connections mode: case insensitive guesses", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  local result = game:HandleChatAnswer("RAGNAROS onyxia NEFARIAN hakkar", "Alice")
  TC_ASSERT_TRUE(result ~= nil, "case insensitive match works")
  TC_ASSERT_EQ(result.groupIndex, 1, "group 1 solved")
end)

TC_TEST("Connections mode: comma-separated guesses", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  local result = game:HandleChatAnswer("Ragnaros, Onyxia, Nefarian, Hakkar", "Alice")
  TC_ASSERT_TRUE(result ~= nil, "comma-separated match works")
  TC_ASSERT_EQ(result.groupIndex, 1, "group 1 solved")
end)

TC_TEST("Connections mode: puzzle complete check", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  TC_ASSERT_FALSE(TriviaClassic_Connections_IsPuzzleComplete(game), "not complete initially")

  -- Solve and announce all 4 groups
  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")
  ctx:ResetProgress()
  game:HandleChatAnswer("gromsblood dreamfoil plaguebloom arthas", "Bob")
  ctx:ResetProgress()
  game:HandleChatAnswer("imp voidwalker succubus felhunter", "Carol")
  ctx:ResetProgress()
  game:HandleChatAnswer("stormwind ironforge darnassus gnomeregan", "Dave")
  ctx:ResetProgress()

  TC_ASSERT_TRUE(TriviaClassic_Connections_IsPuzzleComplete(game), "complete after all 4")
end)

TC_TEST("Connections mode: words not in remaining rejected", function()
  local game = createConnectionsTestGame()
  game:Start({ "set" }, 1, nil, "CONNECTIONS")

  local q = game:NextQuestion()
  TriviaClassic_Connections_SetPuzzle(game, q)

  local ctx = game.state.modeState
  ctx.handler.beginQuestion(ctx, game)

  -- Solve group 1 and announce
  game:HandleChatAnswer("ragnaros onyxia nefarian hakkar", "Alice")
  ctx:ResetProgress()

  -- Try to guess with a word from the solved group
  local result = game:HandleChatAnswer("ragnaros gromsblood dreamfoil plaguebloom", "Bob")
  TC_ASSERT_EQ(result, nil, "should reject words not in remaining")
end)
