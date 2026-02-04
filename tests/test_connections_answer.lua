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

-- Multi-word support tests

local function contains(tbl, value)
  for _, v in ipairs(tbl) do
    if v:lower() == value:lower() then
      return true
    end
  end
  return false
end

TC_TEST("ConnectionsAnswer: parse multi-word entries with commas", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note", "Ragnaros"}
  local words = CA.parseGuessWithContext("Head of Onyxia, Blood of Heroes, Cenarion Beacon, Damp Note", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse 4 items")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_EQ(words[1], "Head of Onyxia", "first item")
  TC_ASSERT_EQ(words[2], "Blood of Heroes", "second item")
  TC_ASSERT_EQ(words[3], "Cenarion Beacon", "third item")
  TC_ASSERT_EQ(words[4], "Damp Note", "fourth item")
end)

TC_TEST("ConnectionsAnswer: parse multi-word entries with quotes", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note", "Ragnaros"}
  local words = CA.parseGuessWithContext('"Head of Onyxia" "Blood of Heroes" "Cenarion Beacon" "Damp Note"', remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse 4 quoted items")
  TC_ASSERT_EQ(#words, 4, "should have 4 quoted items")
  TC_ASSERT_EQ(words[1], "Head of Onyxia", "first quoted item")
  TC_ASSERT_EQ(words[2], "Blood of Heroes", "second quoted item")
end)

TC_TEST("ConnectionsAnswer: parse multi-word entries with spaces (smart match)", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note", "Ragnaros"}
  local words = CA.parseGuessWithContext("head of onyxia damp note blood of heroes cenarion beacon", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should smart-match 4 items")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_TRUE(contains(words, "Head of Onyxia"), "found Head of Onyxia")
  TC_ASSERT_TRUE(contains(words, "Blood of Heroes"), "found Blood of Heroes")
  TC_ASSERT_TRUE(contains(words, "Cenarion Beacon"), "found Cenarion Beacon")
  TC_ASSERT_TRUE(contains(words, "Damp Note"), "found Damp Note")
end)

TC_TEST("ConnectionsAnswer: smart match prefers longer words first", function()
  -- Ensure "Blood of Heroes" is matched as one item, not "Blood" separately
  local remaining = {"Blood of Heroes", "Blood", "Heroes", "Test", "Ragnaros", "Onyxia", "Nefarian", "Hakkar"}
  local words = CA.parseGuessWithContext("blood of heroes ragnaros onyxia nefarian", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_TRUE(contains(words, "Blood of Heroes"), "found Blood of Heroes as single item")
end)

TC_TEST("ConnectionsAnswer: smart match returns nil if less than 4 matched", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Ragnaros"}
  local words = CA.parseGuessWithContext("head of onyxia blood of heroes unknown item", remaining)
  TC_ASSERT_EQ(words, nil, "should return nil when not 4 matches")
end)

TC_TEST("ConnectionsAnswer: parseGuessWithContext falls back to simple parsing", function()
  -- When no remaining words provided, should fall back to simple space-separated
  local words = CA.parseGuessWithContext("apple banana cherry date", {})
  TC_ASSERT_TRUE(words ~= nil, "should parse with fallback")
  TC_ASSERT_EQ(#words, 4, "should have 4 words")
end)

TC_TEST("ConnectionsAnswer: validate multi-word group", function()
  local puzzle = {
    Groups = {
      { Words = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note"}, Theme = "Quest Items", Difficulty = 2 },
      { Words = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}, Theme = "Bosses", Difficulty = 1 },
    }
  }
  local groupIndex = CA.validateGuess(puzzle, {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note"}, {})
  TC_ASSERT_EQ(groupIndex, 1, "should match quest items group")
end)

TC_TEST("ConnectionsAnswer: quotes take priority over commas", function()
  -- If message has both quotes and commas, quotes should be parsed
  local remaining = {"A, B", "C, D", "E, F", "G, H"}
  local words = CA.parseGuessWithContext('"A, B" "C, D" "E, F" "G, H"', remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse quoted items with commas inside")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_EQ(words[1], "A, B", "first item preserved comma")
end)

TC_TEST("ConnectionsAnswer: empty/nil input returns nil", function()
  TC_ASSERT_EQ(CA.parseGuessWithContext("", {}), nil, "empty string")
  TC_ASSERT_EQ(CA.parseGuessWithContext(nil, {}), nil, "nil message")
end)

TC_TEST("ConnectionsAnswer: smart match ignores punctuation differences", function()
  -- Puzzle has apostrophes, player omits them
  local remaining = {"Kel'Thuzad", "C'Thun", "N'Zoth", "Y'Shaarj"}
  local words = CA.parseGuessWithContext("kelthuzad cthun nzoth yshaarj", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should match without apostrophes")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_TRUE(contains(words, "Kel'Thuzad"), "found Kel'Thuzad")
  TC_ASSERT_TRUE(contains(words, "C'Thun"), "found C'Thun")
end)

TC_TEST("ConnectionsAnswer: smart match handles extra spaces", function()
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}
  local words = CA.parseGuessWithContext("ragnaros   onyxia  nefarian    hakkar", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should handle extra spaces")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
end)

TC_TEST("ConnectionsAnswer: smart match handles punctuation in input", function()
  -- Player adds punctuation that puzzle doesn't have
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}
  local words = CA.parseGuessWithContext("ragnaros! onyxia, nefarian... hakkar?", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should ignore input punctuation")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
end)
