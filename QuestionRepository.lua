local Repo = {}
Repo.__index = Repo

local function trim(text)
  local s = text or ""
  s = s:gsub("^%s+", "")
  s = s:gsub("%s+$", "")
  return s
end

local function normalizeCategory(name)
  return trim(name):lower()
end

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
      local qText = block["Question"][i]
      local categoryIndex = block["Category"] and block["Category"][i]
      local categoryName = categories and categories[categoryIndex] or "General"
      local categoryKey = normalizeCategory(categoryName)
      local rawAnswers = block["Answers"] and block["Answers"][i]
      table.insert(questions, {
        question = qText,
        answers = normalizeAnswers(rawAnswers),
        displayAnswers = rawAnswers,
        hint = block["Hints"] and block["Hints"][i] and block["Hints"][i][1],
        category = categoryName,
        categoryKey = categoryKey,
        points = tonumber(block["Points"] and block["Points"][i]) or 1,
      })
    end

    local catList = {}
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
        table.insert(catList, trim(categories[k]))
      end
    end

    local baseId = (meta.title or label or ("Set " .. idx)) .. " #" .. idx
    local setId = baseId
    local suffix = 2
    while self.sets[setId] do
      -- If same title, reuse this id and overwrite (e.g., re-registering with more data).
      if self.sets[setId].title == meta.title then
        break
      end
      setId = baseId .. " (" .. suffix .. ")"
      suffix = suffix + 1
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

function Repo:BuildPool(selectedIds, allowedCategories)
  local questions = {}
  local names = {}
  for _, id in ipairs(selectedIds) do
    local set = self.sets[id]
    if set then
      table.insert(names, set.title or id)
      for _, q in ipairs(set.questions or {}) do
        local catKey = q.categoryKey or (q.category and q.category:lower())
        if not allowedCategories or (catKey and allowedCategories[catKey]) then
          table.insert(questions, q)
        end
      end
    end
  end
  return questions, names
end

function TriviaClassic_CreateRepo()
  return Repo:new()
end
