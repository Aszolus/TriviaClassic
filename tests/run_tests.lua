local failures = 0

local function record_failure(msg)
  failures = failures + 1
  io.write("not ok - " .. msg .. "\n")
end

function TC_ASSERT_EQ(actual, expected, msg)
  if actual ~= expected then
    record_failure(msg .. " (expected " .. tostring(expected) .. ", got " .. tostring(actual) .. ")")
  end
end

function TC_ASSERT_TRUE(value, msg)
  if not value then
    record_failure(msg .. " (expected true)")
  end
end

function TC_ASSERT_FALSE(value, msg)
  if value then
    record_failure(msg .. " (expected false)")
  end
end

function TC_TEST(name, fn)
  local ok, err = pcall(fn)
  if not ok then
    record_failure(name .. " (error: " .. tostring(err) .. ")")
  else
    io.write("ok - " .. name .. "\n")
  end
end

dofile("core/Runtime.lua")
dofile("tests/fake_runtime.lua")
dofile("core/Util.lua")
dofile("game/AnswerService.lua")
TriviaClassic_GetRuntime().answer = _G.TriviaClassic_Answer
dofile("Repo/TriviaBotImporter.lua")

dofile("tests/test_helpers.lua")
dofile("tests/test_util.lua")
dofile("tests/test_answer_service.lua")
dofile("tests/test_trivia_bot_importer.lua")
dofile("modes/participation/Individual.lua")
dofile("modes/participation/Team.lua")
dofile("modes/participation/HeadToHead.lua")
dofile("modes/scoring/Fastest.lua")
dofile("modes/scoring/AllCorrect.lua")
dofile("modes/view/TeamScoreboard.lua")
dofile("modes/flow/FinalPrefix.lua")
dofile("modes/flow/TurnBased.lua")
dofile("modes/flow/TurnBasedSteal.lua")
dofile("modes/flow/Open.lua")
dofile("modes/AxisComposer.lua")
dofile("tests/test_game_fastest.lua")
dofile("tests/test_game_team.lua")
dofile("tests/test_game_all_correct.lua")
dofile("tests/test_game_team_steal.lua")
dofile("tests/test_game_head_to_head.lua")
dofile("tests/test_game_axis_composed.lua")
dofile("tests/test_presenter_flows.lua")
dofile("tests/test_team_map.lua")

if failures > 0 then
  io.write("failures: " .. failures .. "\n")
  os.exit(1)
else
  io.write("all tests passed\n")
end
