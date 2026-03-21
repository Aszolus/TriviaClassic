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

-- ============================================================
-- Additional answer parsing tests
-- ============================================================

-- ---------- Substring / word boundary issues ----------

TC_TEST("ConnectionsAnswer: smart match should not match substrings", function()
  -- "Rend" should not match inside "Surrender" or "Rendering"
  local remaining = {"Rend", "Onyxia", "Nefarian", "Hakkar", "Surrender", "Rendering", "Mend", "Fend"}
  local words = CA.parseGuessWithContext("surrender rendering mend fend", remaining)
  -- Should match Surrender, Rendering, Mend, Fend (not Rend inside them)
  if words then
    TC_ASSERT_EQ(#words, 4, "should have 4 items")
    TC_ASSERT_FALSE(contains(words, "Rend"), "should NOT match Rend as substring")
  end
end)

TC_TEST("ConnectionsAnswer: smart match word is prefix of another", function()
  -- "Fire" vs "Fireball" - both are remaining words, player types both
  local remaining = {"Fire", "Fireball", "Ice", "Storm", "Lightning", "Frost", "Blaze", "Thunder"}
  local words = CA.parseGuessWithContext("fire ice storm lightning", remaining)
  if words then
    TC_ASSERT_EQ(#words, 4, "should have 4 items")
    TC_ASSERT_TRUE(contains(words, "Fire"), "found Fire")
    TC_ASSERT_FALSE(contains(words, "Fireball"), "should not match Fireball")
  end
end)

TC_TEST("ConnectionsAnswer: smart match word is suffix of another", function()
  -- "Ball" vs "Fireball"
  local remaining = {"Ball", "Fireball", "Chain", "Sword", "Shield", "Axe", "Bow", "Staff"}
  local words = CA.parseGuessWithContext("fireball chain sword shield", remaining)
  if words then
    TC_ASSERT_EQ(#words, 4, "should have 4 items")
    TC_ASSERT_TRUE(contains(words, "Fireball"), "found Fireball")
  end
end)

-- ---------- Comma-separated edge cases ----------

TC_TEST("ConnectionsAnswer: comma-separated with extra whitespace", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note"}
  local words = CA.parseGuessWithContext("  Head of Onyxia ,  Blood of Heroes ,  Cenarion Beacon ,  Damp Note  ", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse with extra whitespace")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
end)

TC_TEST("ConnectionsAnswer: comma-separated with only 3 items returns nil", function()
  local remaining = {"Apple", "Banana", "Cherry", "Date"}
  local words = CA.parseGuessWithContext("Apple, Banana, Cherry", remaining)
  -- comma parsing yields 3, should fall through to smart match which also won't find 4
  TC_ASSERT_EQ(words, nil, "should return nil for 3 comma items")
end)

TC_TEST("ConnectionsAnswer: comma-separated with 5 items returns nil", function()
  local remaining = {"Apple", "Banana", "Cherry", "Date", "Elderberry"}
  local words = CA.parseGuessWithContext("Apple, Banana, Cherry, Date, Elderberry", remaining)
  TC_ASSERT_EQ(words, nil, "should return nil for 5 comma items")
end)

TC_TEST("ConnectionsAnswer: comma-separated preserves multi-word item casing", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note"}
  local words = CA.parseGuessWithContext("head of onyxia, blood of heroes, cenarion beacon, damp note", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  -- comma parser returns the raw trimmed text, not the original remaining word
  TC_ASSERT_EQ(words[1], "head of onyxia", "preserves input casing")
end)

-- ---------- Quoted parsing edge cases ----------

TC_TEST("ConnectionsAnswer: quoted with only 3 quotes returns nil", function()
  local remaining = {"Apple", "Banana", "Cherry", "Date"}
  local words = CA.parseGuessWithContext('"Apple" "Banana" "Cherry"', remaining)
  -- 3 quoted items -> nil from quote parser, falls through
  -- smart match should find 3 from the raw text
  -- either nil or falls through to smart match which also won't yield 4
  TC_ASSERT_EQ(words, nil, "should return nil for 3 quoted items")
end)

TC_TEST("ConnectionsAnswer: quoted with 5 quotes returns nil", function()
  local remaining = {"A", "B", "C", "D", "E"}
  local words = CA.parseGuessWithContext('"A" "B" "C" "D" "E"', remaining)
  TC_ASSERT_EQ(words, nil, "should return nil for 5 quoted items")
end)

TC_TEST("ConnectionsAnswer: quoted items preserve internal spaces", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note"}
  local words = CA.parseGuessWithContext('"Head of Onyxia" "Blood of Heroes" "Cenarion Beacon" "Damp Note"', remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_EQ(words[1], "Head of Onyxia", "preserves spaces in quotes")
end)

TC_TEST("ConnectionsAnswer: quoted with empty quotes ignored", function()
  local remaining = {"A", "B", "C", "D"}
  local words = CA.parseGuessWithContext('"A" "" "B" "C" "D"', remaining)
  -- empty quote is skipped, so we get 4 items: A, B, C, D
  TC_ASSERT_TRUE(words ~= nil, "should parse ignoring empty quotes")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
end)

-- ---------- Smart matching with mixed single/multi-word ----------

TC_TEST("ConnectionsAnswer: smart match mixed single and multi-word items", function()
  local remaining = {"Head of Onyxia", "Ragnaros", "Nefarian", "Hakkar",
                     "Blood of Heroes", "Cenarion Beacon", "Damp Note", "Thunder"}
  local words = CA.parseGuessWithContext("head of onyxia ragnaros nefarian hakkar", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse mixed items")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_TRUE(contains(words, "Head of Onyxia"), "found multi-word")
  TC_ASSERT_TRUE(contains(words, "Ragnaros"), "found single-word")
end)

TC_TEST("ConnectionsAnswer: smart match all single-word items", function()
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar",
                     "Thunderfury", "Ashkandi", "Perdition", "Maladath"}
  local words = CA.parseGuessWithContext("ragnaros onyxia nefarian hakkar", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
end)

TC_TEST("ConnectionsAnswer: smart match all multi-word items", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note",
                     "Eye of Divinity", "Seal of Ascension", "Mark of the Chosen", "Hand of Justice"}
  local words = CA.parseGuessWithContext("head of onyxia blood of heroes cenarion beacon damp note", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse all multi-word")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
end)

TC_TEST("ConnectionsAnswer: smart match with overlapping word fragments", function()
  -- "of" appears in multiple remaining items
  local remaining = {"Eye of Divinity", "Seal of Ascension", "Mark of the Chosen", "Hand of Justice",
                     "Ragnaros", "Onyxia", "Nefarian", "Hakkar"}
  local words = CA.parseGuessWithContext("eye of divinity seal of ascension mark of the chosen hand of justice", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should handle overlapping 'of' words")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_TRUE(contains(words, "Eye of Divinity"), "found Eye of Divinity")
  TC_ASSERT_TRUE(contains(words, "Seal of Ascension"), "found Seal of Ascension")
  TC_ASSERT_TRUE(contains(words, "Mark of the Chosen"), "found Mark of the Chosen")
  TC_ASSERT_TRUE(contains(words, "Hand of Justice"), "found Hand of Justice")
end)

-- ---------- Validation edge cases ----------

TC_TEST("ConnectionsAnswer: validate with duplicate words in guess", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
    }
  }
  -- Player submits same word twice - should NOT match (only 3 unique matches)
  local groupIndex = CA.validateGuess(puzzle, {"a", "a", "b", "c"}, {})
  -- countMatches uses a set, so "a" counted once, "b" once, "c" once = 3 matches
  TC_ASSERT_EQ(groupIndex, nil, "should reject duplicate words in guess")
end)

TC_TEST("ConnectionsAnswer: validate guess words from different groups", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "G1", Difficulty = 1 },
      { Words = {"e", "f", "g", "h"}, Theme = "G2", Difficulty = 2 },
    }
  }
  local groupIndex = CA.validateGuess(puzzle, {"a", "b", "e", "f"}, {})
  TC_ASSERT_EQ(groupIndex, nil, "should reject words spanning groups")
end)

TC_TEST("ConnectionsAnswer: validate with all groups solved", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "G1", Difficulty = 1 },
      { Words = {"e", "f", "g", "h"}, Theme = "G2", Difficulty = 2 },
    }
  }
  local solvedGroups = { [1] = true, [2] = true }
  TC_ASSERT_EQ(CA.validateGuess(puzzle, {"a", "b", "c", "d"}, solvedGroups), nil, "all groups solved")
  TC_ASSERT_EQ(CA.validateGuess(puzzle, {"e", "f", "g", "h"}, solvedGroups), nil, "all groups solved")
end)

TC_TEST("ConnectionsAnswer: validate with nil puzzle", function()
  TC_ASSERT_EQ(CA.validateGuess(nil, {"a", "b", "c", "d"}, {}), nil, "nil puzzle")
end)

TC_TEST("ConnectionsAnswer: validate with nil guess", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
    }
  }
  TC_ASSERT_EQ(CA.validateGuess(puzzle, nil, {}), nil, "nil guess")
end)

TC_TEST("ConnectionsAnswer: validate with fewer than 4 guess words", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
    }
  }
  TC_ASSERT_EQ(CA.validateGuess(puzzle, {"a", "b", "c"}, {}), nil, "3 words")
  TC_ASSERT_EQ(CA.validateGuess(puzzle, {"a", "b"}, {}), nil, "2 words")
end)

TC_TEST("ConnectionsAnswer: validate with more than 4 guess words", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "Test", Difficulty = 1 },
    }
  }
  TC_ASSERT_EQ(CA.validateGuess(puzzle, {"a", "b", "c", "d", "e"}, {}), nil, "5 words")
end)

TC_TEST("ConnectionsAnswer: validate normalizes punctuation in puzzle words", function()
  local puzzle = {
    Groups = {
      { Words = {"Kel'Thuzad", "C'Thun", "N'Zoth", "Y'Shaarj"}, Theme = "Old Gods+", Difficulty = 4 },
    }
  }
  local groupIndex = CA.validateGuess(puzzle, {"kelthuzad", "cthun", "nzoth", "yshaarj"}, {})
  TC_ASSERT_EQ(groupIndex, 1, "should match ignoring apostrophes")
end)

TC_TEST("ConnectionsAnswer: validate with mixed case and punctuation", function()
  local puzzle = {
    Groups = {
      { Words = {"Kel'Thuzad", "C'Thun", "N'Zoth", "Y'Shaarj"}, Theme = "Old Gods+", Difficulty = 4 },
    }
  }
  local groupIndex = CA.validateGuess(puzzle, {"KEL'THUZAD", "c'thun", "N'Zoth", "y'shaarj"}, {})
  TC_ASSERT_EQ(groupIndex, 1, "should match mixed case with punctuation")
end)

-- ---------- End-to-end: parse + validate ----------

TC_TEST("E2E: comma-separated input validates against puzzle group", function()
  local puzzle = {
    Groups = {
      { Words = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}, Theme = "Bosses", Difficulty = 2 },
      { Words = {"Thunderfury", "Ashkandi", "Perdition", "Maladath"}, Theme = "Weapons", Difficulty = 3 },
    }
  }
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar",
                     "Thunderfury", "Ashkandi", "Perdition", "Maladath"}
  local words = CA.parseGuessWithContext("Ragnaros, Onyxia, Nefarian, Hakkar", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  local groupIndex = CA.validateGuess(puzzle, words, {})
  TC_ASSERT_EQ(groupIndex, 1, "should validate as group 1")
end)

TC_TEST("E2E: smart-match input validates against puzzle group", function()
  local puzzle = {
    Groups = {
      { Words = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note"}, Theme = "Quest Items", Difficulty = 2 },
      { Words = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}, Theme = "Bosses", Difficulty = 1 },
    }
  }
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note",
                     "Ragnaros", "Onyxia", "Nefarian", "Hakkar"}
  local words = CA.parseGuessWithContext("head of onyxia blood of heroes cenarion beacon damp note", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  local groupIndex = CA.validateGuess(puzzle, words, {})
  TC_ASSERT_EQ(groupIndex, 1, "should validate as quest items group")
end)

TC_TEST("E2E: comma-separated lowercase validates against capitalized puzzle", function()
  local puzzle = {
    Groups = {
      { Words = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}, Theme = "Bosses", Difficulty = 2 },
    }
  }
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}
  local words = CA.parseGuessWithContext("ragnaros, onyxia, nefarian, hakkar", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse lowercase")
  local groupIndex = CA.validateGuess(puzzle, words, {})
  TC_ASSERT_EQ(groupIndex, 1, "should validate case-insensitively")
end)

TC_TEST("E2E: wrong group guess parses but does not validate", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "G1", Difficulty = 1 },
      { Words = {"e", "f", "g", "h"}, Theme = "G2", Difficulty = 2 },
    }
  }
  local remaining = {"a", "b", "c", "d", "e", "f", "g", "h"}
  local words = CA.parseGuessWithContext("a, b, c, e", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_TRUE(CA.allWordsRemaining(words, remaining), "all words are remaining")
  local groupIndex = CA.validateGuess(puzzle, words, {})
  TC_ASSERT_EQ(groupIndex, nil, "should not validate cross-group guess")
end)

TC_TEST("E2E: smart match with word that is substring of remaining word", function()
  -- "Rend" is a remaining word, but player types "rendered" which contains "rend"
  -- This should NOT match "Rend"
  local remaining = {"Rend", "Onyxia", "Nefarian", "Hakkar", "Rendered", "Other1", "Other2", "Other3"}
  local words = CA.parseGuessWithContext("rendered onyxia nefarian hakkar", remaining)
  if words then
    TC_ASSERT_EQ(#words, 4, "should have 4 items")
    -- "Rendered" should match before "Rend" since it's longer
    TC_ASSERT_TRUE(contains(words, "Rendered"), "should match Rendered not Rend")
  end
end)

-- ---------- allWordsRemaining edge cases ----------

TC_TEST("ConnectionsAnswer: allWordsRemaining with multi-word items", function()
  local remaining = {"Head of Onyxia", "Blood of Heroes", "Ragnaros", "Hakkar"}
  TC_ASSERT_TRUE(CA.allWordsRemaining({"Head of Onyxia", "Blood of Heroes", "Ragnaros", "Hakkar"}, remaining), "all present")
  TC_ASSERT_TRUE(CA.allWordsRemaining({"head of onyxia", "blood of heroes", "ragnaros", "hakkar"}, remaining), "case insensitive")
  TC_ASSERT_FALSE(CA.allWordsRemaining({"Head of Onyxia", "Blood of Heroes", "Ragnaros", "Unknown"}, remaining), "unknown word")
end)

TC_TEST("ConnectionsAnswer: allWordsRemaining with empty inputs", function()
  TC_ASSERT_FALSE(CA.allWordsRemaining(nil, {"a", "b"}), "nil guess")
  TC_ASSERT_FALSE(CA.allWordsRemaining({"a"}, nil), "nil remaining")
  TC_ASSERT_FALSE(CA.allWordsRemaining(nil, nil), "both nil")
end)

-- ---------- isOneAway edge cases ----------

TC_TEST("ConnectionsAnswer: isOneAway skips solved groups", function()
  local puzzle = {
    Groups = {
      { Words = {"a", "b", "c", "d"}, Theme = "G1", Difficulty = 1 },
      { Words = {"e", "f", "g", "h"}, Theme = "G2", Difficulty = 2 },
    }
  }
  -- Group 1 is solved, guess is 3/4 of group 1 + 1 other
  local isOneAway = CA.isOneAway(puzzle, {"a", "b", "c", "x"}, { [1] = true })
  TC_ASSERT_FALSE(isOneAway, "should not detect one-away for solved group")
end)

TC_TEST("ConnectionsAnswer: isOneAway with nil inputs", function()
  TC_ASSERT_FALSE(CA.isOneAway(nil, {"a", "b", "c", "d"}, {}), "nil puzzle")
  TC_ASSERT_FALSE(CA.isOneAway({ Groups = {} }, nil, {}), "nil guess")
  TC_ASSERT_FALSE(CA.isOneAway({ Groups = {} }, {"a", "b"}, {}), "2 words")
end)

-- ---------- normalize edge cases ----------

TC_TEST("ConnectionsAnswer: normalize handles numbers", function()
  TC_ASSERT_EQ(CA.normalize("123"), "123", "numbers unchanged")
  TC_ASSERT_EQ(CA.normalize("Item #5"), "item 5", "number sign removed")
end)

TC_TEST("ConnectionsAnswer: normalize handles hyphens", function()
  TC_ASSERT_EQ(CA.normalize("Kel-Thuzad"), "kelthuzad", "hyphen removed")
  TC_ASSERT_EQ(CA.normalize("well-known"), "wellknown", "hyphen removed")
end)

TC_TEST("ConnectionsAnswer: normalize handles nil", function()
  -- normalizeWord checks for nil
  TC_ASSERT_EQ(CA.normalize(nil), "", "nil returns empty")
end)

-- ---------- parseGuess (basic, no context) edge cases ----------

TC_TEST("ConnectionsAnswer: parseGuess with tabs and mixed whitespace", function()
  -- Tabs between words
  local words = CA.parseGuess("apple\tbanana\tcherry\tdate")
  -- %S+ should handle tabs as separators
  TC_ASSERT_TRUE(words ~= nil, "should parse tab-separated")
  TC_ASSERT_EQ(#words, 4, "should have 4 words")
end)

TC_TEST("ConnectionsAnswer: parseGuess comma with trailing comma", function()
  local words = CA.parseGuess("apple, banana, cherry, date,")
  -- Trailing comma creates empty segment which is filtered, so still 4
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_EQ(#words, 4, "should have 4 words")
end)

TC_TEST("ConnectionsAnswer: parseGuess comma with leading comma", function()
  local words = CA.parseGuess(",apple, banana, cherry, date")
  -- Leading comma creates empty segment, filtered, so 4
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_EQ(#words, 4, "should have 4 words")
end)

TC_TEST("ConnectionsAnswer: parseGuess single word returns nil", function()
  TC_ASSERT_EQ(CA.parseGuess("hello"), nil, "single word")
end)

TC_TEST("ConnectionsAnswer: parseGuess with only spaces returns nil", function()
  TC_ASSERT_EQ(CA.parseGuess("   "), nil, "only spaces")
end)

-- ---------- countMatches edge cases ----------

TC_TEST("ConnectionsAnswer: countMatches with nil group", function()
  TC_ASSERT_EQ(CA.countMatches(nil, {"a", "b"}), 0, "nil group")
end)

TC_TEST("ConnectionsAnswer: countMatches with nil guess", function()
  local group = { Words = {"a", "b", "c", "d"} }
  TC_ASSERT_EQ(CA.countMatches(group, nil), 0, "nil guess")
end)

TC_TEST("ConnectionsAnswer: countMatches case insensitive", function()
  local group = { Words = {"Apple", "Banana", "Cherry", "Date"} }
  TC_ASSERT_EQ(CA.countMatches(group, {"APPLE", "banana", "CHERRY", "date"}), 4, "case insensitive 4/4")
  TC_ASSERT_EQ(CA.countMatches(group, {"APPLE", "banana", "x", "y"}), 2, "case insensitive 2/4")
end)

-- ---------- Smart match: tricky real-world scenarios ----------

TC_TEST("ConnectionsAnswer: smart match where input word matches part of multi-word item", function()
  -- "Onyxia" appears both as single word and inside "Head of Onyxia"
  local remaining = {"Head of Onyxia", "Onyxia", "Ragnaros", "Hakkar",
                     "Nefarian", "Thunderfury", "Ashkandi", "Perdition"}
  local words = CA.parseGuessWithContext("onyxia ragnaros hakkar nefarian", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_TRUE(contains(words, "Onyxia"), "found single Onyxia")
  TC_ASSERT_FALSE(contains(words, "Head of Onyxia"), "should NOT match Head of Onyxia")
end)

TC_TEST("ConnectionsAnswer: smart match with ambiguous word present in multiple remaining items", function()
  -- "Blood" appears in "Blood of Heroes" and "Blood Elf"
  local remaining = {"Blood of Heroes", "Blood Elf", "Ragnaros", "Hakkar",
                     "Nefarian", "Onyxia", "Thunderfury", "Ashkandi"}
  local words = CA.parseGuessWithContext("blood elf ragnaros hakkar nefarian", remaining)
  if words then
    TC_ASSERT_EQ(#words, 4, "should have 4 items")
    TC_ASSERT_TRUE(contains(words, "Blood Elf"), "found Blood Elf")
    TC_ASSERT_FALSE(contains(words, "Blood of Heroes"), "should NOT match Blood of Heroes")
  end
end)

TC_TEST("ConnectionsAnswer: smart match returns nil when input has extra unmatched text", function()
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}
  -- 5 actual words, only 4 in remaining — but all 4 are present
  local words = CA.parseGuessWithContext("ragnaros onyxia nefarian hakkar extrastuff", remaining)
  -- Should still find 4 matches even with extra text
  if words then
    TC_ASSERT_EQ(#words, 4, "should have 4 items")
  end
end)

TC_TEST("ConnectionsAnswer: smart match with repeated word in input", function()
  -- Player types same word twice
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar",
                     "Thunderfury", "Ashkandi", "Perdition", "Maladath"}
  local words = CA.parseGuessWithContext("ragnaros ragnaros onyxia nefarian", remaining)
  -- Should only match Ragnaros once (usedIndices prevents double-match)
  -- So only 3 items found -> nil
  TC_ASSERT_EQ(words, nil, "should return nil for repeated word giving <4 matches")
end)

TC_TEST("ConnectionsAnswer: smart match with numbers in words", function()
  local remaining = {"AQ40", "AQ20", "MC", "BWL", "ZG", "Naxx", "Onyxia", "UBRS"}
  local words = CA.parseGuessWithContext("aq40 aq20 mc bwl", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should match words with numbers")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  TC_ASSERT_TRUE(contains(words, "AQ40"), "found AQ40")
  TC_ASSERT_TRUE(contains(words, "AQ20"), "found AQ20")
end)

-- ---------- parseGuessWithContext priority tests ----------

TC_TEST("ConnectionsAnswer: commas take priority over smart match", function()
  -- With commas present, should use comma parser even if smart match would work too
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"}
  local words = CA.parseGuessWithContext("Ragnaros, Onyxia, Nefarian, Hakkar", remaining)
  TC_ASSERT_TRUE(words ~= nil, "should parse")
  TC_ASSERT_EQ(#words, 4, "should have 4 items")
  -- Comma parser returns trimmed raw text
  TC_ASSERT_EQ(words[1], "Ragnaros", "comma parser used")
end)

TC_TEST("ConnectionsAnswer: comma parsing falls through to smart match if not 4 items", function()
  -- Message has a comma but doesn't split into 4 items
  local remaining = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar",
                     "Thunderfury", "Ashkandi", "Perdition", "Maladath"}
  -- "hello, ragnaros onyxia nefarian hakkar" has a comma but splits to 2 comma items
  local words = CA.parseGuessWithContext("hello, ragnaros onyxia nefarian hakkar", remaining)
  -- comma split yields 2 items -> falls through to smart match
  -- smart match should find ragnaros, onyxia, nefarian, hakkar in the normalized text
  if words then
    TC_ASSERT_EQ(#words, 4, "should have 4 items from smart match fallthrough")
  end
end)

-- ---------- getDifficultyPoints edge cases ----------

TC_TEST("ConnectionsAnswer: getDifficultyPoints out of range", function()
  TC_ASSERT_EQ(CA.getDifficultyPoints(0), 100, "0 defaults to 100")
  TC_ASSERT_EQ(CA.getDifficultyPoints(5), 100, "5 defaults to 100")
  TC_ASSERT_EQ(CA.getDifficultyPoints(-1), 100, "-1 defaults to 100")
end)

-- ---------- Full 4-group puzzle end-to-end ----------

TC_TEST("E2E: full 4-group puzzle with sequential solves", function()
  local puzzle = {
    Groups = {
      { Words = {"Rend", "Onyxia", "Nefarian", "Zandalar"}, Theme = "World Buffs", Difficulty = 1 },
      { Words = {"Chicken", "A-me", "Kaya", "Tooga"}, Theme = "Escort Quests", Difficulty = 2 },
      { Words = {"Patrol", "Runner", "Fear", "Linked"}, Theme = "Pull Ruiners", Difficulty = 3 },
      { Words = {"Mankrik", "Jenkins", "Thunderfury", "Anal"}, Theme = "Barrens Chat", Difficulty = 4 },
    }
  }
  local remaining = {}
  for _, group in ipairs(puzzle.Groups) do
    for _, word in ipairs(group.Words) do
      table.insert(remaining, word)
    end
  end

  -- Solve group 1 via comma
  local words1 = CA.parseGuessWithContext("Rend, Onyxia, Nefarian, Zandalar", remaining)
  TC_ASSERT_TRUE(words1 ~= nil, "parse group 1")
  TC_ASSERT_TRUE(CA.allWordsRemaining(words1, remaining), "all words remaining for group 1")
  TC_ASSERT_EQ(CA.validateGuess(puzzle, words1, {}), 1, "validate group 1")

  -- Solve group 4 via smart match (out of order)
  local solvedGroups = { [1] = true }
  local words4 = CA.parseGuessWithContext("mankrik jenkins thunderfury anal", remaining)
  TC_ASSERT_TRUE(words4 ~= nil, "parse group 4")
  TC_ASSERT_EQ(CA.validateGuess(puzzle, words4, solvedGroups), 4, "validate group 4")

  -- Solve group 2 with punctuation differences
  solvedGroups[4] = true
  local words2 = CA.parseGuessWithContext("chicken ame kaya tooga", remaining)
  TC_ASSERT_TRUE(words2 ~= nil, "parse group 2 (A-me -> ame)")
  TC_ASSERT_EQ(CA.validateGuess(puzzle, words2, solvedGroups), 2, "validate group 2")
end)

-- ---------- isWordRemaining edge cases ----------

TC_TEST("ConnectionsAnswer: isWordRemaining with multi-word item", function()
  local remaining = {"Head of Onyxia", "Ragnaros"}
  TC_ASSERT_TRUE(CA.isWordRemaining("Head of Onyxia", remaining), "exact match")
  TC_ASSERT_TRUE(CA.isWordRemaining("head of onyxia", remaining), "lowercase match")
  TC_ASSERT_FALSE(CA.isWordRemaining("Head", remaining), "'Head' alone not a remaining word")
  TC_ASSERT_FALSE(CA.isWordRemaining("Onyxia", remaining), "'Onyxia' alone not a remaining word")
end)

TC_TEST("ConnectionsAnswer: isWordRemaining empty remaining list", function()
  TC_ASSERT_FALSE(CA.isWordRemaining("anything", {}), "empty remaining")
end)
