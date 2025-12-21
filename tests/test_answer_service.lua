TC_TEST("Answer.normalize handles punctuation", function()
  TC_ASSERT_EQ(TriviaClassic_Answer.normalize("  Hello!! "), "hello", "normalize punctuation")
end)

TC_TEST("Answer.extract applies requiredPrefix", function()
  local extracted = TriviaClassic_Answer.extract("final: answer", { requiredPrefix = "final:" })
  TC_ASSERT_EQ(extracted, "answer", "extract drops prefix")

  local keep = TriviaClassic_Answer.extract("final: answer", { requiredPrefix = "final:", dropPrefix = false })
  TC_ASSERT_EQ(keep, "final: answer", "extract keeps prefix")

  local missing = TriviaClassic_Answer.extract("answer", { requiredPrefix = "final:" })
  TC_ASSERT_EQ(missing, nil, "extract requires prefix")
end)

TC_TEST("Answer.match supports normalized matches", function()
  local q = { answers = { "Stormwind City", "Ironforge" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("stormwind city", q), "exact match")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("Ironforge!", q), "punctuation match")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("stormwindcity", q), "compact match")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("City of Stormwind", q), "token mismatch")
end)

TC_TEST("Answer.match allows answers inside longer phrases", function()
  local q = { answers = { "Nightsaber" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("It's Nightsabers!", q), "substring match")
end)

TC_TEST("Answer.match handles edge cases and punctuation", function()
  local q = { answers = { "Ner'zhul", "A-B", "C.D", "E, F", "G (H)" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("ner'zhul", q), "apostrophe preserved")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("nerzhul", q), "apostrophe required")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("a b", q), "hyphen stripped")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("cd", q), "period stripped")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("e f", q), "comma stripped")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("g h", q), "paren stripped")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("", q), "empty candidate")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("   ", q), "whitespace candidate")
end)

TC_TEST("Answer.match handles numbers and symbols", function()
  local q = { answers = { "Patch 1.12", "8-bit", "100%" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("patch 112", q), "dot removed")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("8 bit", q), "hyphen removed")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("100", q), "percent removed")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("100%", q), "exact with percent")
end)

TC_TEST("Answer.match is case-insensitive", function()
  local q = { answers = { "Darnassus" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("darnassus", q), "lowercase")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("DARNASSUS", q), "uppercase")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("DaRnAsSuS", q), "mixed case")
end)

TC_TEST("Answer.match rejects non-answers", function()
  local q = { answers = { "Thunder Bluff", "Orgrimmar" } }
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("thunder", q), "partial not accepted")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("ogrim", q), "substring not accepted")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match(nil, q), "nil candidate")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("Orgrim-mar", { answers = {} }), "empty answer list")
end)

TC_TEST("Answer.match supports multiple acceptable answers", function()
  local q = { answers = { "The Dark Portal", "Dark Portal" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("dark portal", q), "secondary answer")
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("the dark portal", q), "primary answer")
end)

TC_TEST("Answer.match ignores leading 'the' in answers", function()
  local q = { answers = { "The Dark Portal" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("dark portal", q), "leading article ignored")
end)

TC_TEST("Answer.match avoids numeric substring matches", function()
  local q = { answers = { "2" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("2", q), "exact numeric match")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("22", q), "numeric substring should not match")
end)

TC_TEST("Answer.match does not allow short answer substrings", function()
  local q = { answers = { "at", "an" } }
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("cat", q), "short substring should not match")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("anduin", q), "short substring should not match")
end)

TC_TEST("Answer.match handles leading/trailing punctuation", function()
  local q = { answers = { "Stranglethorn Vale" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("...Stranglethorn Vale!!!", q), "leading/trailing punctuation")
end)

TC_TEST("Answer.match respects apostrophes inside words", function()
  local q = { answers = { "Kil'jaeden" } }
  TC_ASSERT_TRUE(TriviaClassic_Answer.match("Kil'jaeden", q), "exact with apostrophe")
  TC_ASSERT_FALSE(TriviaClassic_Answer.match("Kiljaeden", q), "apostrophe required")
end)
