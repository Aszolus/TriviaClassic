-- Importer for Connections puzzle sets into Repo

local function trim(text)
  return TriviaClassic_Trim(text)
end

local function normalizeWord(word)
  if not word then return "" end
  local s = tostring(word):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "") -- trim
  s = s:gsub("%p+", "") -- remove punctuation
  return s
end

--- Imports a Connections puzzle set into the provided Repo instance.
--- Expected format:
--- {
---   [1] = {
---     Title = "Puzzle Set Name",
---     Description = "Optional description",
---     Author = "Author name",
---     Puzzles = {
---       [1] = {
---         Groups = {
---           { Theme = "Theme Name", Difficulty = 1, Words = {"word1", "word2", "word3", "word4"} },
---           { Theme = "Theme Name", Difficulty = 2, Words = {...} },
---           { Theme = "Theme Name", Difficulty = 3, Words = {...} },
---           { Theme = "Theme Name", Difficulty = 4, Words = {...} },
---         }
---       },
---       [2] = { ... },
---     }
---   }
--- }
---@param self Repo
---@param label string|nil
---@param connectionsTable table
function TriviaClassic_Repo_ImportConnectionsSet(self, label, connectionsTable)
  if type(connectionsTable) ~= "table" then
    return
  end

  local setIndices = {}
  for k in pairs(connectionsTable) do
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
    local block = connectionsTable[idx]
    local puzzles = {}
    local meta = {
      title = block["Title"] or label or ("Connections Set " .. idx),
      description = block["Description"],
      author = block["Author"],
    }

    -- Process puzzles
    local puzzleData = block["Puzzles"] or {}
    local puzzleKeys = {}
    for k in pairs(puzzleData) do
      if type(k) == "number" then
        table.insert(puzzleKeys, k)
      elseif type(k) == "string" then
        local n = tonumber(k)
        if n then table.insert(puzzleKeys, n) end
      end
    end
    table.sort(puzzleKeys)

    for _, puzzleIdx in ipairs(puzzleKeys) do
      local rawPuzzle = puzzleData[puzzleIdx]
      local groups = {}

      if rawPuzzle["Groups"] then
        for groupIdx, rawGroup in ipairs(rawPuzzle["Groups"]) do
          local words = {}
          local normalizedWords = {}

          for _, word in ipairs(rawGroup["Words"] or {}) do
            local trimmed = trim(tostring(word))
            table.insert(words, trimmed)
            table.insert(normalizedWords, normalizeWord(trimmed))
          end

          table.insert(groups, {
            Theme = rawGroup["Theme"] or ("Group " .. groupIdx),
            Difficulty = tonumber(rawGroup["Difficulty"]) or groupIdx,
            Words = words,
            NormalizedWords = normalizedWords,
          })
        end
      end

      if #groups == 4 then
        table.insert(puzzles, {
          puzzleIndex = puzzleIdx,
          Groups = groups,
        })
      end
    end

    if #puzzles > 0 then
      local baseId = (meta.title or label or ("Connections Set " .. idx)) .. " #" .. idx
      local setId = baseId
      local suffix = 2
      while self.sets[setId] do
        if self.sets[setId].title == meta.title then
          break
        end
        setId = baseId .. " (" .. suffix .. ")"
        suffix = suffix + 1
      end

      -- Assign unique puzzle IDs
      for i, puzzle in ipairs(puzzles) do
        puzzle.qid = setId .. "::puzzle" .. i
      end

      self.sets[setId] = {
        id = setId,
        title = meta.title,
        description = meta.description,
        author = meta.author,
        isConnectionsSet = true,
        puzzles = puzzles,
        -- For compatibility with existing UI that expects questions
        questions = {},
      }
    end
  end
end

--- Registers a Connections-format set into this repository.
---@param label string|nil Optional label to use if the set lacks a Title
---@param connectionsTable table Raw Connections puzzle table
function TriviaClassic_Repo_RegisterConnectionsSet(self, label, connectionsTable)
  if TriviaClassic_Repo_ImportConnectionsSet then
    return TriviaClassic_Repo_ImportConnectionsSet(self, label, connectionsTable)
  end
end

--- Build a pool of Connections puzzles from selected set IDs.
---@param self Repo
---@param selectedIds string[]
---@return table[] puzzles, string[] setNames
function TriviaClassic_Repo_BuildConnectionsPool(self, selectedIds)
  local puzzles = {}
  local names = {}

  for _, id in ipairs(selectedIds or {}) do
    local set = self.sets[id]
    if set and set.isConnectionsSet and set.puzzles then
      table.insert(names, set.title or id)
      for _, puzzle in ipairs(set.puzzles) do
        table.insert(puzzles, puzzle)
      end
    end
  end

  return puzzles, names
end

--- Get all Connections sets from the repository.
---@param self Repo
---@return table[] sets
function TriviaClassic_Repo_GetConnectionsSets(self)
  local list = {}
  for _, set in pairs(self.sets or {}) do
    if set.isConnectionsSet then
      table.insert(list, set)
    end
  end
  table.sort(list, function(a, b)
    return (a.title or "") < (b.title or "")
  end)
  return list
end
