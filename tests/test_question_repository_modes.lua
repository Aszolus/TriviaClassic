dofile("Repo/QuestionRepository.lua")

TC_TEST("QuestionRepository filters mode-scoped trivia sets", function()
  local repo = TriviaClassic_CreateRepo()
  repo.sets["Standard"] = {
    id = "Standard",
    title = "Standard",
    questions = {},
  }
  repo.sets["Quote Check"] = {
    id = "Quote Check",
    title = "Quote Check",
    modeKeys = {
      TRUMP_QUOTE = true,
    },
    questions = {},
  }

  local standardSets = repo:GetSetsForMode("FASTEST")
  TC_ASSERT_EQ(#standardSets, 1, "standard mode count")
  TC_ASSERT_EQ(standardSets[1].id, "Standard", "standard mode set")

  local quoteSets = repo:GetSetsForMode("TRUMP_QUOTE")
  TC_ASSERT_EQ(#quoteSets, 1, "quote mode count")
  TC_ASSERT_EQ(quoteSets[1].id, "Quote Check", "quote mode set")
end)

TC_TEST("QuestionRepository excludes connections sets from standard trivia modes", function()
  local repo = TriviaClassic_CreateRepo()
  repo.sets["Standard"] = {
    id = "Standard",
    title = "Standard",
    questions = {},
  }
  repo.sets["Connections"] = {
    id = "Connections",
    title = "Connections",
    isConnectionsSet = true,
    puzzles = {},
    questions = {},
  }

  local fastestSets = repo:GetSetsForMode("FASTEST")
  TC_ASSERT_EQ(#fastestSets, 1, "connections excluded from fastest")
  TC_ASSERT_EQ(fastestSets[1].id, "Standard", "standard remains visible")

  local connectionSets = repo:GetSetsForMode("CONNECTIONS")
  TC_ASSERT_EQ(#connectionSets, 1, "connections mode count")
  TC_ASSERT_EQ(connectionSets[1].id, "Connections", "connections set visible")
end)
