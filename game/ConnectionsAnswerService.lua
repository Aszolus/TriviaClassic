-- Answer parsing and validation for Connections puzzles.
-- Handles parsing 4-word guesses and checking against puzzle groups.

local ConnectionsAnswer = {}

--- Normalize a word for matching (lowercase, trim whitespace, remove punctuation).
---@param word string
---@return string
local function normalizeWord(word)
  if not word then return "" end
  local s = tostring(word):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "") -- trim
  s = s:gsub("%p+", "") -- remove punctuation
  return s
end

--- Parse a chat message into 4 words (comma or space separated).
--- Returns nil if the message doesn't contain exactly 4 words.
---@param msg string
---@return string[]|nil
function ConnectionsAnswer.parseGuess(msg)
  if not msg or msg == "" then
    return nil
  end

  local words = {}

  -- First try comma-separated parsing
  if msg:find(",") then
    for word in msg:gmatch("([^,]+)") do
      local trimmed = word:gsub("^%s+", ""):gsub("%s+$", "")
      if trimmed ~= "" then
        table.insert(words, trimmed)
      end
    end
  else
    -- Space-separated parsing
    for word in msg:gmatch("%S+") do
      table.insert(words, word)
    end
  end

  if #words ~= 4 then
    return nil
  end

  return words
end

--- Build a lookup set of normalized words for a group.
---@param groupWords string[]
---@return table<string, boolean>
local function buildWordSet(groupWords)
  local set = {}
  for _, word in ipairs(groupWords or {}) do
    set[normalizeWord(word)] = true
  end
  return set
end

--- Validate a guess against a puzzle's groups.
--- Returns the group index (1-4) if all 4 words belong to the same unsolved group.
--- Returns nil if the guess is invalid.
---@param puzzle table The puzzle with Groups array
---@param guessWords string[] Array of 4 words guessed
---@param solvedGroups table<number, boolean>|nil Map of already solved group indices
---@return number|nil groupIndex
function ConnectionsAnswer.validateGuess(puzzle, guessWords, solvedGroups)
  if not puzzle or not puzzle.Groups or not guessWords or #guessWords ~= 4 then
    return nil
  end

  solvedGroups = solvedGroups or {}

  -- Normalize guess words
  local normalizedGuess = {}
  for _, word in ipairs(guessWords) do
    table.insert(normalizedGuess, normalizeWord(word))
  end

  -- Check each unsolved group
  for groupIndex, group in ipairs(puzzle.Groups) do
    if not solvedGroups[groupIndex] then
      local groupSet = buildWordSet(group.Words)
      local matchCount = 0

      for _, normWord in ipairs(normalizedGuess) do
        if groupSet[normWord] then
          matchCount = matchCount + 1
        end
      end

      if matchCount == 4 then
        return groupIndex
      end
    end
  end

  return nil
end

--- Count how many words from a guess match a specific group.
--- Used for "one away" detection.
---@param group table The group to check against
---@param guessWords string[] Array of 4 words guessed
---@return number matchCount
function ConnectionsAnswer.countMatches(group, guessWords)
  if not group or not group.Words or not guessWords then
    return 0
  end

  local groupSet = buildWordSet(group.Words)
  local matchCount = 0

  for _, word in ipairs(guessWords) do
    if groupSet[normalizeWord(word)] then
      matchCount = matchCount + 1
    end
  end

  return matchCount
end

--- Check if a guess is "one away" from any unsolved group (3 of 4 correct).
---@param puzzle table The puzzle with Groups array
---@param guessWords string[] Array of 4 words guessed
---@param solvedGroups table<number, boolean>|nil Map of already solved group indices
---@return boolean isOneAway
function ConnectionsAnswer.isOneAway(puzzle, guessWords, solvedGroups)
  if not puzzle or not puzzle.Groups or not guessWords or #guessWords ~= 4 then
    return false
  end

  solvedGroups = solvedGroups or {}

  for groupIndex, group in ipairs(puzzle.Groups) do
    if not solvedGroups[groupIndex] then
      local matchCount = ConnectionsAnswer.countMatches(group, guessWords)
      if matchCount == 3 then
        return true
      end
    end
  end

  return false
end

--- Check if a word is in the remaining (unsolved) words of a puzzle.
---@param word string
---@param remainingWords string[]
---@return boolean
function ConnectionsAnswer.isWordRemaining(word, remainingWords)
  if not word or not remainingWords then
    return false
  end

  local normWord = normalizeWord(word)
  for _, remaining in ipairs(remainingWords) do
    if normalizeWord(remaining) == normWord then
      return true
    end
  end

  return false
end

--- Validate that all guess words are from the remaining words.
---@param guessWords string[]
---@param remainingWords string[]
---@return boolean allValid
function ConnectionsAnswer.allWordsRemaining(guessWords, remainingWords)
  if not guessWords or not remainingWords then
    return false
  end

  for _, word in ipairs(guessWords) do
    if not ConnectionsAnswer.isWordRemaining(word, remainingWords) then
      return false
    end
  end

  return true
end

--- Get the difficulty points for a group.
---@param difficulty number 1-4
---@return number points
function ConnectionsAnswer.getDifficultyPoints(difficulty)
  local pointsMap = {
    [1] = 100,
    [2] = 200,
    [3] = 300,
    [4] = 400,
  }
  return pointsMap[difficulty] or 100
end

--- Normalize a word (exposed for external use).
---@param word string
---@return string
function ConnectionsAnswer.normalize(word)
  return normalizeWord(word)
end

TriviaClassic_ConnectionsAnswer = ConnectionsAnswer
