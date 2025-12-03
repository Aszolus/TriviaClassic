local Repo = {}
Repo.__index = Repo

function Repo:new()
  local o = {
    sets = {},
  }
  setmetatable(o, self)
  return o
end

local function normalizeAnswers(answerList)
  local normalized = {}
  for _, answer in ipairs(answerList or {}) do
    if type(answer) == "string" then
      local cleaned = answer:lower():gsub("^%s+", "")
      cleaned = cleaned:gsub("%s+$", "")
      table.insert(normalized, cleaned)
    end
  end
  return normalized
end

function Repo:RegisterTriviaBotSet(label, triviaTable)
  if type(triviaTable) ~= "table" then
    return
  end
  triviaTable.__tcRegistered = true

  for idx, block in ipairs(triviaTable) do
    local questions = {}
    local categories = block["Categories"] or {}
    local meta = {
      title = block["Title"] or label or ("Set " .. idx),
      description = block["Description"],
      author = block["Author"],
    }

    for i, qText in ipairs(block["Question"] or {}) do
      local categoryIndex = block["Category"] and block["Category"][i]
      local categoryName = categories and categories[categoryIndex] or "General"
      local rawAnswers = block["Answers"] and block["Answers"][i]
      table.insert(questions, {
        question = qText,
        answers = normalizeAnswers(rawAnswers),
        displayAnswers = rawAnswers,
        hint = block["Hints"] and block["Hints"][i] and block["Hints"][i][1],
        category = categoryName,
        points = tonumber(block["Points"] and block["Points"][i]) or 1,
      })
    end

    local setId = meta.title .. " #" .. idx
    self.sets[setId] = {
      id = setId,
      title = meta.title,
      description = meta.description,
      author = meta.author,
      questions = questions,
    }
  end
end

function Repo:GetAllSets()
  local list = {}
  for _, set in pairs(self.sets) do
    table.insert(list, set)
  end
  table.sort(list, function(a, b)
    return a.title < b.title
  end)
  return list
end

function Repo:BuildPool(selectedIds)
  local questions = {}
  local names = {}
  for _, id in ipairs(selectedIds) do
    local set = self.sets[id]
    if set then
      table.insert(names, set.title or id)
      for _, q in ipairs(set.questions or {}) do
        table.insert(questions, q)
      end
    end
  end
  return questions, names
end

function TriviaClassic_CreateRepo()
  return Repo:new()
end
