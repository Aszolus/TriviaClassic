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

--- Parse quoted strings from a message.
--- Returns array of quoted items if exactly 4 found, nil otherwise.
---@param msg string
---@return string[]|nil
local function parseQuoted(msg)
  local words = {}
  for quoted in msg:gmatch('"([^"]+)"') do
    local trimmed = quoted:gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed ~= "" then
      table.insert(words, trimmed)
    end
  end
  if #words == 4 then
    return words
  end
  return nil
end

--- Parse comma-separated items from a message.
--- Returns array of items if exactly 4 found, nil otherwise.
---@param msg string
---@return string[]|nil
local function parseCommaSeparated(msg)
  local words = {}
  for word in msg:gmatch("([^,]+)") do
    local trimmed = word:gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed ~= "" then
      table.insert(words, trimmed)
    end
  end
  if #words == 4 then
    return words
  end
  return nil
end

--- Sort remaining words by length (longest first) for greedy matching.
---@param remainingWords string[]
---@return string[]
local function sortByLengthDesc(remainingWords)
  local sorted = {}
  for _, word in ipairs(remainingWords) do
    table.insert(sorted, word)
  end
  table.sort(sorted, function(a, b)
    return #a > #b
  end)
  return sorted
end

--- Escape pattern special characters in a string.
---@param str string
---@return string
local function escapePattern(str)
  return str:gsub("([%-%.%+%[%]%(%)%$%^%%%?%*])", "%%%1")
end

--- Smart match words from input against known remaining words.
--- Uses greedy longest-first matching to handle multi-word items.
--- Normalizes both input and remaining words (removes punctuation, lowercases) for lenient matching.
---@param msg string The input message
---@param remainingWords string[] Known remaining words in the puzzle
---@return string[]|nil Array of 4 matched words or nil
local function smartMatchWords(msg, remainingWords)
  if not msg or not remainingWords or #remainingWords == 0 then
    return nil
  end

  -- Normalize input: lowercase, remove punctuation, collapse multiple spaces
  local normalized = msg:lower():gsub("%p+", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  local matched = {}
  local usedIndices = {}

  -- Sort remaining words by normalized length (longest first) for greedy matching
  -- We sort by normalized length since that's what we'll match against
  local sortedWords = {}
  for i, word in ipairs(remainingWords) do
    local normWord = word:lower():gsub("%p+", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    table.insert(sortedWords, { original = word, normalized = normWord, index = i })
  end
  table.sort(sortedWords, function(a, b)
    return #a.normalized > #b.normalized
  end)

  for _, wordData in ipairs(sortedWords) do
    local pattern = escapePattern(wordData.normalized)

    -- Check if this word appears in the remaining input
    local startPos, endPos = normalized:find(pattern)
    if startPos then
      -- Verify we haven't already matched this word
      if not usedIndices[wordData.index] then
        table.insert(matched, wordData.original)
        usedIndices[wordData.index] = true
        -- Remove matched portion from input to prevent double-matching
        normalized = normalized:sub(1, startPos - 1) .. string.rep(" ", endPos - startPos + 1) .. normalized:sub(endPos + 1)
      end
    end
  end

  if #matched == 4 then
    return matched
  end
  return nil
end

--- Parse a guess with context of remaining words.
--- Supports multiple input formats:
--- 1. Quote-delimited: "Head of Onyxia" "Blood of Heroes" "Cenarion Beacon" "Damp Note"
--- 2. Comma-separated: Head of Onyxia, Blood of Heroes, Cenarion Beacon, Damp Note
--- 3. Space-separated with smart matching against known remaining words
---@param msg string The chat message
---@param remainingWords string[] The remaining words in the puzzle
---@return string[]|nil Array of 4 words or nil
function ConnectionsAnswer.parseGuessWithContext(msg, remainingWords)
  if not msg or msg == "" then
    return nil
  end

  -- Priority 1: Check for quoted strings
  local quoted = parseQuoted(msg)
  if quoted then
    return quoted
  end

  -- Priority 2: Check for commas
  if msg:find(",") then
    local parsed = parseCommaSeparated(msg)
    if parsed then
      return parsed
    end
    -- Fall through to smart matching if comma parsing doesn't yield 4 items
  end

  -- Priority 3: Smart match against known remaining words
  if remainingWords and #remainingWords > 0 then
    return smartMatchWords(msg, remainingWords)
  end

  -- Fallback: simple space-separated (original behavior)
  return ConnectionsAnswer.parseGuess(msg)
end

TriviaClassic_ConnectionsAnswer = ConnectionsAnswer
