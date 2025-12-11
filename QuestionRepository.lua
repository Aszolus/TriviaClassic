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

    -- Track actually used category names to ensure the set's category list reflects questions accurately
    local usedCategoryOrder, usedCategorySet = {}, {}

    for _, i in ipairs(keys) do
      local qText = block["Question"][i]
      local categoryIndex = block["Category"] and block["Category"][i]
      -- Derive the category name robustly:
      -- - If it's a number, use Categories[number]
      -- - If it's a numeric-like string, tonumber and use Categories[n]
      -- - If it's a non-numeric string, treat it directly as a category name
      -- - Otherwise, fallback to "General"
      local categoryName
      if type(categoryIndex) == "number" then
        categoryName = categories and categories[categoryIndex]
      elseif type(categoryIndex) == "string" then
        local n = tonumber(categoryIndex)
        if n then
          categoryName = categories and categories[n]
        else
          -- Direct category label supplied per-question
          categoryName = trim(categoryIndex)
        end
      end
      if not categoryName or categoryName == "" then
        categoryName = "General"
      end

      local categoryKey = normalizeCategory(categoryName)
      local rawAnswers = block["Answers"] and block["Answers"][i]

      if not usedCategorySet[categoryKey] then
        usedCategorySet[categoryKey] = true
        table.insert(usedCategoryOrder, categoryName)
      end

      table.insert(questions, {
        question = qText,
        answers = normalizeAnswers(rawAnswers),
        displayAnswers = rawAnswers,
        hint = block["Hints"] and block["Hints"][i] and block["Hints"][i][1],
        category = categoryName,
        categoryKey = categoryKey,
        points = tonumber(block["Points"] and block["Points"][i]) or 1,
        -- Keep original numeric key to build a stable per-question id later
        sourceIndex = i,
      })
    end

    -- Build the visible category list for this set.
    -- Start with the Categories array in numeric order, then append any per-question
    -- category labels that weren't present there.
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
        local name = trim(categories[k])
        local key = normalizeCategory(name)
        if name ~= "" and not presentKeys[key] then
          table.insert(catList, name)
          presentKeys[key] = true
        end
      end
    end
    -- Append any used categories not already included
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
      -- If same title, reuse this id and overwrite (e.g., re-registering with more data).
      if self.sets[setId].title == meta.title then
        break
      end
      setId = baseId .. " (" .. suffix .. ")"
      suffix = suffix + 1
    end
    -- Attach a stable question id to each question for cross-game/session tracking.
    -- Id format: <setId>::<originalIndex>
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
  -- Determine if allowedCategories is a global set of category keys or
  -- a per-set map: { [setId] = { [catKey]=true } }
  local perSet = nil
  if type(allowedCategories) == "table" then
    -- Heuristic: if any value is a table, treat as per-set map
    for _, v in pairs(allowedCategories) do
      if type(v) == "table" then
        perSet = allowedCategories
        break
      end
    end
  end
  for _, id in ipairs(selectedIds) do
    local set = self.sets[id]
    if set then
      table.insert(names, set.title or id)
      for _, q in ipairs(set.questions or {}) do
        local catKey = q.categoryKey or (q.category and q.category:lower())
        local allow
        if perSet then
          local allowedForSet = perSet[id]
          -- Default-deny per set: only include if this set has an explicit map and the category is selected
          allow = (allowedForSet and catKey and allowedForSet[catKey]) or false
        else
          allow = (not allowedCategories) or (catKey and allowedCategories[catKey])
        end
        if allow then
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
