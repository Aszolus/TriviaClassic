dofile("core/Constants.lua")
dofile("Repo/QuestionRepository.lua")
dofile("game/Chat.lua")
dofile("modes/Registry.lua")
dofile("modes/Fastest.lua")
dofile("modes/HeadToHead.lua")
dofile("game/Game.lua")

local function reset_db()
  _G.TriviaClassicCharacterDB = {}
end

local function find_team(list, name)
  for _, team in ipairs(list or {}) do
    if team.name == name then
      return team
    end
  end
  return nil
end

TC_TEST("Team map created from assignments", function()
  reset_db()
  dofile("core/Init.lua")

  TC_ASSERT_TRUE(TriviaClassic:AddTeam("Alpha Team"), "add team")
  TC_ASSERT_TRUE(TriviaClassic:AddTeam("Beta"), "add team beta")
  TC_ASSERT_TRUE(TriviaClassic:AddPlayerToTeam(" Alice ", "Alpha Team"), "add player")
  TC_ASSERT_TRUE(TriviaClassic:AddPlayerToTeam("BOB", "beta"), "add player beta")

  local map = TriviaClassic:GetTeamMap()
  TC_ASSERT_EQ(map["alice"], "alpha team", "map alpha")
  TC_ASSERT_EQ(map["bob"], "beta", "map beta")

  local teams = TriviaClassic:GetTeams()
  local alpha = find_team(teams, "Alpha Team")
  TC_ASSERT_TRUE(alpha ~= nil, "team entry")
  TC_ASSERT_EQ(alpha.members[1], "Alice", "member display name")
end)

TC_TEST("Team map updates on removal", function()
  reset_db()
  dofile("core/Init.lua")

  TriviaClassic:AddTeam("Alpha")
  TriviaClassic:AddPlayerToTeam("Alice", "Alpha")
  TriviaClassic:AddPlayerToTeam("Bob", "Alpha")

  TriviaClassic:RemovePlayerFromTeam("Alice")
  local map = TriviaClassic:GetTeamMap()
  TC_ASSERT_EQ(map["alice"], nil, "removed from map")
  TC_ASSERT_EQ(map["bob"], "alpha", "remaining map entry")

  TriviaClassic:RemoveTeam("Alpha")
  local map2 = TriviaClassic:GetTeamMap()
  TC_ASSERT_EQ(map2["bob"], nil, "team removed")
  local teams = TriviaClassic:GetTeams()
  TC_ASSERT_EQ(#teams, 0, "no teams")
end)
