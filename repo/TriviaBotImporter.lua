-- Importer for TriviaBot-format question sets into Repo

local function normalizeCategory(name)
  return TriviaClassic_Trim(name):lower()
end

local function normalizeAnswers(answerList)
  local normalized = {}
  local A = TriviaClassic_GetRuntime and TriviaClassic_GetRuntime().answer or nil
  for _, answer in ipairs(answerList or {}) do
    if type(answer) == "string" then
      local cleaned = (A and A.normalize and A.normalize(answer)) or answer
      table.insert(normalized, cleaned)
    end
  end
  return normalized
end

--- Imports a TriviaBot_Questions-like table into the provided Repo instance.
---@param self Repo
---@param label string|nil
---@param triviaTable table
function TriviaClassic_Repo_ImportTriviaBotSet(self, label, triviaTable)
  if type(triviaTable) ~= "table" then
    return
  end

  local setIndices = {}
  for k in pairs(triviaTable) do
    if type(k) == "number" then
      table.insert(setIndices, k)
    elseif type(k) == "string" then
      local n = tonumber(k)
      if n then
        table.insert(setIndices, n)
      end
    end
  end
  table.sort(setIndices)

  for _, idx in ipairs(setIndices) do
    local block = triviaTable[idx]
    local questions = {}
    local categories = block["Categories"] or {}
    local meta = {
      title = block["Title"] or label or ("Set " .. idx),
      description = block["Description"],
      author = block["Author"],
    }

    local usedCategoryOrder, usedCategorySet = {}, {}

    local function addQuestion(i, qText, rawAnswers, categoryIndex, pointsValue, hintsValue)
      local categoryName
      if type(categoryIndex) == "number" then
        categoryName = categories and categories[categoryIndex]
      elseif type(categoryIndex) == "string" then
        local n = tonumber(categoryIndex)
        if n then
          categoryName = categories and categories[n]
        else
          categoryName = TriviaClassic_Trim(categoryIndex)
        end
      end
      if not categoryName or categoryName == "" then
        categoryName = "General"
      end

      local categoryKey = normalizeCategory(categoryName)

      if not usedCategorySet[categoryKey] then
        usedCategorySet[categoryKey] = true
        table.insert(usedCategoryOrder, categoryName)
      end

      table.insert(questions, {
        question = qText,
        answers = normalizeAnswers(rawAnswers),
        displayAnswers = rawAnswers,
        hint = hintsValue and hintsValue[1],
        category = categoryName,
        categoryKey = categoryKey,
        points = tonumber(pointsValue) or 1,
        sourceIndex = i,
      })
    end

    if type(block["Questions"]) == "table" then
      for i, q in ipairs(block["Questions"]) do
        addQuestion(
          i,
          q["Question"] or q.question,
          q["Answers"] or q.answers,
          q["Category"] or q.category,
          q["Points"] or q.points,
          q["Hints"] or q.hints
        )
      end
    else
      local keys = {}
      for k in pairs(block["Question"] or {}) do
        if type(k) == "number" then
          table.insert(keys, k)
        elseif type(k) == "string" then
          local n = tonumber(k)
          if n then
            table.insert(keys, n)
          end
        end
      end
      table.sort(keys)

      for _, i in ipairs(keys) do
        addQuestion(
          i,
          block["Question"][i],
          block["Answers"] and block["Answers"][i],
          block["Category"] and block["Category"][i],
          block["Points"] and block["Points"][i],
          block["Hints"] and block["Hints"][i]
        )
      end
    end

    local catList, presentKeys = {}, {}
    if type(categories) == "table" then
      local catKeys = {}
      for k in pairs(categories) do
        if type(k) == "number" then
          table.insert(catKeys, k)
        elseif type(k) == "string" then
          local n = tonumber(k)
          if n then table.insert(catKeys, n) end
        end
      end
      table.sort(catKeys)
      for _, k in ipairs(catKeys) do
        local name = TriviaClassic_Trim(categories[k])
        local key = normalizeCategory(name)
        if name ~= "" and not presentKeys[key] then
          table.insert(catList, name)
          presentKeys[key] = true
        end
      end
    end
    for _, name in ipairs(usedCategoryOrder or {}) do
      local key = normalizeCategory(name)
      if not presentKeys[key] then
        table.insert(catList, name)
        presentKeys[key] = true
      end
    end

    local baseId = (meta.title or label or ("Set " .. idx)) .. " #" .. idx
    local setId = baseId
    local suffix = 2
    while self.sets[setId] do
      if self.sets[setId].title == meta.title then
        break
      end
      setId = baseId .. " (" .. suffix .. ")"
      suffix = suffix + 1
    end
    for _, q in ipairs(questions) do
      if not q.qid then
        q.qid = tostring(setId) .. "::" .. tostring(q.sourceIndex or "?")
      end
    end

    self.sets[setId] = {
      id = setId,
      title = meta.title,
      description = meta.description,
      author = meta.author,
      categories = catList,
      questions = questions,
    }
  end
end
