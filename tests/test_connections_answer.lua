-- Tests for ConnectionsAnswerService

dofile("game/ConnectionsAnswerService.lua")

local CA = TriviaClassic_ConnectionsAnswer

TC_TEST("ConnectionsAnswer: parse 4 comma-separated words", function()
  local words = CA.parseGuess("apple, banana, cherry, date")
  TC_ASSERT_TRUE(words ~= nil, "should parse words")
  TC_ASSERT_EQ(#words, 4, "should have 4 words")
  TC_ASSERT_EQ(words[1], "apple", "first word")
  TC_ASSERT_EQ(words[2], "banana", "second word")
  TC_ASSERT_EQ(words[3], "cherry", "third word")
  TC_ASSERT_EQ(words[4], "date", "fourth word")
end)

TC_TEST("ConnectionsAnswer: parse 4 space-separated words", function()
  local words = CA.parseGuess("apple banana cherry date")
  TC_ASSERT_TRUE(words ~= nil, "should parse words")
  TC_ASSERT_EQ(#words, 4, "should have 4 words")
  TC_ASSERT_EQ(words[1], "apple", "first word")
  TC_ASSERT_EQ(words[4], "date", "fourth word")
end)

TC_TEST("ConnectionsAnswer: ignore messages with wrong word count (too few)", function()
  local words = CA.parseGuess("one two three")
  TC_ASSERT_EQ(words, nil, "should return nil for 3 words")
end)

TC_TEST("ConnectionsAnswer: ignore messages with wrong word count (too many)", function()
  local words = CA.parseGuess("one two three four five")
  TC_ASSERT_EQ(words, nil, "should return nil for 5 words")
end)

TC_TEST("ConnectionsAnswer: ignore empty message", function()
  TC_ASSERT_EQ(CA.parseGuess(""), nil, "empty string")
  TC_ASSERT_EQ(CA.parseGuess(nil), nil, "nil")
end)

TC_TEST("ConnectionsAnswer: validate correct group", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
      { Words = {"e", "f", "g", "h"}, Theme = "Test2", Difficulty = 2 },
    }
  }
  local groupIndex = CA.validateGuess(puzzle, {"a", "b", "c", "d"}, {})
  TC_ASSERT_EQ(groupIndex, 1, "should return group 1")
end)

TC_TEST("ConnectionsAnswer: validate second group", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
      { Words = {"e", "f", "g", "h"}, Theme = "Test2", Difficulty = 2 },
    }
  }
  local groupIndex = CA.validateGuess(puzzle, {"e", "f", "g", "h"}, {})
  TC_ASSERT_EQ(groupIndex, 2, "should return group 2")
end)

TC_TEST("ConnectionsAnswer: reject partial match (3 of 4)", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
    }
  }
  local groupIndex = CA.validateGuess(puzzle, {"a", "b", "c", "x"}, {})
  TC_ASSERT_EQ(groupIndex, nil, "should reject partial match")
end)

TC_TEST("ConnectionsAnswer: reject already solved group", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
      { Words = {"e", "f", "g", "h"}, Theme = "Test2", Difficulty = 2 },
    }
  }
  local solvedGroups = { [1] = true }
  local groupIndex = CA.validateGuess(puzzle, {"a", "b", "c", "d"}, solvedGroups)
  TC_ASSERT_EQ(groupIndex, nil, "should reject solved group")
end)

TC_TEST("ConnectionsAnswer: case insensitive matching", function()
  local puzzle = {
    Groups = {
      { Words = {"Apple", "Banana", "Cherry", "Date"}, Theme = "Test", Difficulty = 1 },
    }
  }
  local groupIndex = CA.validateGuess(puzzle, {"apple", "BANANA", "Cherry", "DATE"}, {})
  TC_ASSERT_EQ(groupIndex, 1, "should match case-insensitively")
end)

TC_TEST("ConnectionsAnswer: detect one away (3 of 4 correct)", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
      { Words = {"e", "f", "g", "h"}, Theme = "Test2", Difficulty = 2 },
    }
  }
  local isOneAway = CA.isOneAway(puzzle, {"a", "b", "c", "x"}, {})
  TC_ASSERT_TRUE(isOneAway, "should detect one away")
end)

TC_TEST("ConnectionsAnswer: not one away for 2 of 4", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
    }
  }
  local isOneAway = CA.isOneAway(puzzle, {"a", "b", "x", "y"}, {})
  TC_ASSERT_FALSE(isOneAway, "should not be one away for 2/4")
end)

TC_TEST("ConnectionsAnswer: count matches", function()
  local group = { Words = {"a", "b", "c", "d"} }
  TC_ASSERT_EQ(CA.countMatches(group, {"a", "b", "c", "d"}), 4, "4 matches")
  TC_ASSERT_EQ(CA.countMatches(group, {"a", "b", "c", "x"}), 3, "3 matches")
  TC_ASSERT_EQ(CA.countMatches(group, {"a", "b", "x", "y"}), 2, "2 matches")
  TC_ASSERT_EQ(CA.countMatches(group, {"x", "y", "z", "w"}), 0, "0 matches")
end)

TC_TEST("ConnectionsAnswer: isWordRemaining", function()
  local remaining = {"Apple", "Banana", "Cherry"}
  TC_ASSERT_TRUE(CA.isWordRemaining("apple", remaining), "should find apple")
  TC_ASSERT_TRUE(CA.isWordRemaining("BANANA", remaining), "should find banana")
  TC_ASSERT_FALSE(CA.isWordRemaining("date", remaining), "should not find date")
end)

TC_TEST("ConnectionsAnswer: allWordsRemaining", function()
  local remaining = {"Apple", "Banana", "Cherry", "Date", "Elderberry"}
  TC_ASSERT_TRUE(CA.allWordsRemaining({"apple", "banana", "cherry", "date"}, remaining), "all present")
  TC_ASSERT_FALSE(CA.allWordsRemaining({"apple", "banana", "cherry", "fig"}, remaining), "fig not present")
end)

TC_TEST("ConnectionsAnswer: getDifficultyPoints", function()
  TC_ASSERT_EQ(CA.getDifficultyPoints(1), 100, "difficulty 1")
  TC_ASSERT_EQ(CA.getDifficultyPoints(2), 200, "difficulty 2")
  TC_ASSERT_EQ(CA.getDifficultyPoints(3), 300, "difficulty 3")
  TC_ASSERT_EQ(CA.getDifficultyPoints(4), 400, "difficulty 4")
  TC_ASSERT_EQ(CA.getDifficultyPoints(nil), 100, "nil defaults to 100")
end)

TC_TEST("ConnectionsAnswer: normalize word", function()
  TC_ASSERT_EQ(CA.normalize("  Apple  "), "apple", "trim and lowercase")
  TC_ASSERT_EQ(CA.normalize("Hello!"), "hello", "remove punctuation")
  TC_ASSERT_EQ(CA.normalize("It's"), "its", "remove apostrophe")
end)
