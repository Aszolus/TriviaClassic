local function list_to_string(list)
  local out = {}
  for _, v in ipairs(list or {}) do
    out[#out + 1] = v
  end
  return table.concat(out, "|")
end

TC_TEST("TriviaBot importer builds sets", function()
  local repo = { sets = {} }
  local trivia = {
    [1] = {
      Title = "Test Set",
      Description = "desc",
      Author = "me",
      Categories = { [1] = "History", [2] = "General" },
      Question = { [1] = "Q1", [2] = "Q2", [3] = "Q3", [4] = "Q4" },
      Category = { [1] = 1, [2] = "2", [3] = "Custom" },
      Answers = { [1] = { "Answer One" }, [2] = { "Two" }, [3] = { "Three" }, [4] = { "Four" } },
      Points = { [1] = "2" },
      Hints = { [1] = { "Hint1" } },
    },
  }

  TriviaClassic_Repo_ImportTriviaBotSet(repo, "Label", trivia)
  local set = repo.sets["Test Set #1"]
  TC_ASSERT_TRUE(set ~= nil, "set created")
  TC_ASSERT_EQ(set.title, "Test Set", "set title")
  TC_ASSERT_EQ(#set.questions, 4, "question count")
  TC_ASSERT_EQ(list_to_string(set.categories), "History|General|Custom", "category order")

  local q1 = set.questions[1]
  TC_ASSERT_EQ(q1.qid, "Test Set #1::1", "qid assigned")
  TC_ASSERT_EQ(q1.answers[1], "answerone", "answers normalized")
  TC_ASSERT_EQ(q1.points, 2, "points parsed")
  TC_ASSERT_EQ(q1.hint, "Hint1", "hint stored")

  local q4 = set.questions[4]
  TC_ASSERT_EQ(q4.category, "General", "default category")
  TC_ASSERT_EQ(q4.categoryKey, "general", "category key")
end)