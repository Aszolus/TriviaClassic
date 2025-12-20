dofile("core/Constants.lua")
dofile("modes/Registry.lua")
dofile("modes/Fastest.lua")
dofile("game/Game.lua")

local function make_repo()
  local pool = {
    { qid = "q1", question = "Q1", answers = { "ok" }, points = 1 },
    { qid = "q2", question = "Q2", answers = { "ok" }, points = 1 },
  }
  return {
    BuildPool = function(_, _, _)
      return pool, { "Set A" }
    end,
  }
end

TC_TEST("Game Fastest mode flow", function()
  local repo = make_repo()
  local store = { leaderboard = {}, teams = { teams = {} } }
  local game = TriviaClassic_CreateGame(repo, store)

  local started = game:Start({ "set" }, 2, nil, "FASTEST")
  TC_ASSERT_TRUE(started ~= nil, "game started")
  TC_ASSERT_EQ(started.total, 2, "total questions")
  TC_ASSERT_EQ(started.mode, "FASTEST", "mode set")

  local q1 = game:NextQuestion()
  TC_ASSERT_TRUE(q1 ~= nil, "next question")
  TC_ASSERT_TRUE(game:IsQuestionOpen(), "question open")

  local wrong = game:HandleChatAnswer("nope", "Player")
  TC_ASSERT_EQ(wrong, nil, "wrong answer ignored")
  TC_ASSERT_TRUE(game:IsQuestionOpen(), "question stays open")

  local result = game:HandleChatAnswer("ok", "Player")
  TC_ASSERT_TRUE(result ~= nil, "correct answer handled")
  TC_ASSERT_EQ(result.winner, "Player", "winner name")
  TC_ASSERT_TRUE(game:IsPendingWinner(), "pending winner")

  local action = game:GetPrimaryAction()
  TC_ASSERT_EQ(action.command, "announce_winner", "primary action")

  local announced = game:PerformPrimaryAction("announce_winner")
  TC_ASSERT_EQ(announced.command, "announce_winner", "announce winner")
  TC_ASSERT_FALSE(announced.finished, "not finished")

  local entry = store.leaderboard["Player"]
  TC_ASSERT_TRUE(entry ~= nil, "leaderboard entry")
  TC_ASSERT_EQ(entry.points, 1, "leaderboard points")
  TC_ASSERT_EQ(entry.correct, 1, "leaderboard correct")
end)