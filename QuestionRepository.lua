--- Repository of trivia sets and helpers to build question pools.
---@class Repo
---@field sets table<string, table>
local Repo = {}
Repo.__index = Repo

local function trim(text)
  return TriviaClassic_Trim(text)
end

local function normalizeCategory(name)
  return TriviaClassic_Trim(name):lower()
end

--- Creates a new repository instance.
---@return Repo
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

--- Registers a TriviaBot-format set into this repository.
---@param label string|nil Optional label to use if the set lacks a Title
---@param triviaTable table Raw TriviaBot_Questions-like table
function Repo:RegisterTriviaBotSet(label, triviaTable)
  if TriviaClassic_Repo_ImportTriviaBotSet then
    return TriviaClassic_Repo_ImportTriviaBotSet(self, label, triviaTable)
  end
end

--- Returns all sets sorted by display title.
---@return table[] sets
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

--- Builds a question pool for a selection of set ids.
---@param selectedIds string[]
---@param allowedCategories table|nil Global allow map or per-set map
---@return table[] questions, string[] setNames
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
