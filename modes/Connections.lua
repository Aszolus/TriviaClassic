-- Connections mode: players identify 4 groups of 4 words that share a common theme.
-- Mode state (ctx.data) fields:
-- - currentPuzzle: the full puzzle data
-- - shuffledWords: original 16 words in shuffled order
-- - remainingWords: words not yet in solved groups
-- - pendingSolves: array of { groupIndex, solver, elapsed, points } awaiting announcement
-- - announcedGroups: set of group indices already broadcast
-- - solvedBy: map of groupIndex -> { player, time, points }

local MODE_CONNECTIONS = "CONNECTIONS"
local BONUS_ALL_SOLVED = 500

local CA = nil -- Will be set to TriviaClassic_ConnectionsAnswer

local function getCA()
  if not CA then
    CA = TriviaClassic_ConnectionsAnswer
  end
  return CA
end

--- Shuffle an array in place.
local function shuffle(list)
  for i = #list, 2, -1 do
    local j = math.random(i)
    list[i], list[j] = list[j], list[i]
  end
end

--- Collect all 16 words from a puzzle's groups.
local function collectAllWords(puzzle)
  local words = {}
  if puzzle and puzzle.Groups then
    for _, group in ipairs(puzzle.Groups) do
      for _, word in ipairs(group.Words or {}) do
        table.insert(words, word)
      end
    end
  end
  return words
end

--- Remove solved group's words from remaining words.
local function removeGroupWords(remainingWords, groupWords)
  local toRemove = {}
  local ca = getCA()
  for _, gw in ipairs(groupWords or {}) do
    toRemove[ca.normalize(gw)] = true
  end

  local filtered = {}
  for _, word in ipairs(remainingWords) do
    if not toRemove[ca.normalize(word)] then
      table.insert(filtered, word)
    end
  end
  return filtered
end

--- Check if a group has already been solved or has a pending solve.
local function isGroupTaken(data, groupIndex)
  if data.solvedBy and data.solvedBy[groupIndex] then
    return true
  end
  for _, pending in ipairs(data.pendingSolves or {}) do
    if pending.groupIndex == groupIndex then
      return true
    end
  end
  return false
end

--- Count how many groups are fully solved and announced.
local function countAnnouncedGroups(data)
  local count = 0
  for _ in pairs(data.announcedGroups or {}) do
    count = count + 1
  end
  return count
end

--- Count pending solves.
local function countPendingSolves(data)
  return #(data.pendingSolves or {})
end

--- Check if all 4 groups are solved (announced or pending).
local function allGroupsResolved(data)
  local announced = countAnnouncedGroups(data)
  local pending = countPendingSolves(data)
  return (announced + pending) >= 4
end

local handler = {
  createState = function()
    return {
      currentPuzzle = nil,
      shuffledWords = {},
      remainingWords = {},
      pendingSolves = {},
      announcedGroups = {},
      solvedBy = {},
      puzzleStartTime = nil,
    }
  end,

  beginQuestion = function(ctx, game)
    -- Called when a new puzzle opens.
    -- The puzzle data is already set in ctx.data.currentPuzzle by the game flow.
    local puzzle = ctx.data.currentPuzzle
    if puzzle then
      local words = collectAllWords(puzzle)
      shuffle(words)
      ctx.data.shuffledWords = words
      ctx.data.remainingWords = {}
      for _, w in ipairs(words) do
        table.insert(ctx.data.remainingWords, w)
      end
    end
    ctx.data.pendingSolves = {}
    ctx.data.announcedGroups = {}
    ctx.data.solvedBy = {}
    ctx.data.puzzleStartTime = game and game:Now() or 0
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
  end,

  evaluateAnswer = function(game, ctx, sender, rawMsg)
    -- Parse 4 words from chat and check if they form a valid group.
    local ca = getCA()
    local words = ca.parseGuess(rawMsg)
    if not words then
      return nil -- Not a 4-word message
    end

    local puzzle = ctx.data.currentPuzzle
    if not puzzle then
      return nil
    end

    -- Check that all guessed words are from the remaining words
    if not ca.allWordsRemaining(words, ctx.data.remainingWords) then
      return nil
    end

    -- Build solved groups set (announced + pending)
    local solvedGroups = {}
    for idx in pairs(ctx.data.announcedGroups or {}) do
      solvedGroups[idx] = true
    end
    for _, pending in ipairs(ctx.data.pendingSolves or {}) do
      solvedGroups[pending.groupIndex] = true
    end

    local groupIndex = ca.validateGuess(puzzle, words, solvedGroups)
    if not groupIndex then
      return nil -- Wrong guess, silent
    end

    -- Valid group found - queue the solve
    local elapsed = game:Now() - (ctx.data.puzzleStartTime or game:Now())
    local group = puzzle.Groups[groupIndex]
    local points = ca.getDifficultyPoints(group.Difficulty or 1)

    table.insert(ctx.data.pendingSolves, {
      groupIndex = groupIndex,
      solver = sender,
      elapsed = elapsed,
      points = points,
      theme = group.Theme,
      words = group.Words,
    })

    -- Record in solvedBy to prevent duplicate solves
    ctx.data.solvedBy[groupIndex] = {
      player = sender,
      time = elapsed,
      points = points,
    }

    -- Mark pending winner so UI knows there's something to announce
    ctx.pendingWinner = true

    return {
      groupIndex = groupIndex,
      solver = sender,
      elapsed = elapsed,
      points = points,
      theme = group.Theme,
      words = group.Words,
      mode = ctx.key,
    }
  end,

  handleCorrect = function(game, ctx, sender, elapsed)
    -- This is called by the standard flow but Connections uses evaluateAnswer instead.
    -- Just return nil to indicate no standard handling.
    return nil
  end,

  onTimeout = function(game, ctx)
    -- Connections has no timer, but if called, just mark no winner pending.
    -- If there are pending solves, those should still be announced.
    if countPendingSolves(ctx.data) > 0 then
      ctx.pendingWinner = true
      ctx.pendingNoWinner = false
    else
      ctx.pendingWinner = false
      ctx.pendingNoWinner = false
    end
  end,

  pendingWinners = function(game, ctx)
    -- Return pending solves formatted for the presenter.
    local winners = {}
    for _, solve in ipairs(ctx.data.pendingSolves or {}) do
      table.insert(winners, {
        name = solve.solver,
        elapsed = solve.elapsed,
        points = solve.points,
        groupIndex = solve.groupIndex,
        theme = solve.theme,
        words = solve.words,
      })
    end
    return winners
  end,

  winnerCount = function(ctx)
    return countPendingSolves(ctx.data)
  end,

  resetProgress = function(ctx)
    -- Called after announcing - move pending solves to announced.
    for _, solve in ipairs(ctx.data.pendingSolves or {}) do
      ctx.data.announcedGroups[solve.groupIndex] = true
      -- Remove the solved group's words from remaining
      if solve.words then
        ctx.data.remainingWords = removeGroupWords(ctx.data.remainingWords, solve.words)
      end
    end
    ctx.data.pendingSolves = {}
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
  end,

  primaryAction = function(game, ctx)
    if not game:IsGameActive() then
      return { command = "waiting", label = "Start", enabled = false }
    end

    local data = ctx.data
    local announced = countAnnouncedGroups(data)
    local pending = countPendingSolves(data)

    -- If there are pending solves, offer to announce them
    if pending > 0 then
      return { command = "announce_winner", label = "Announce Results", enabled = true }
    end

    -- If all 4 groups are announced, offer next puzzle or end game
    if announced >= 4 then
      if game:HasMoreQuestions() then
        return { command = "announce_question", label = "Next Puzzle", enabled = true }
      end
      return { command = "end_game", label = "End Game", enabled = true }
    end

    -- Otherwise, show words button
    return { command = "show_words", label = "Show Words", enabled = true }
  end,

  -- Custom action handler for show_words command
  onAdvance = function(game, ctx, cmd)
    if cmd == "show_words" then
      -- Return info for the presenter to display remaining words
      local data = ctx.data
      local announced = countAnnouncedGroups(data)
      local pending = countPendingSolves(data)

      return {
        command = "show_words",
        remainingWords = data.remainingWords,
        groupsFound = announced,
        groupsRemaining = 4 - announced - pending,
        noNewAnswers = pending == 0,
      }
    end
    return nil
  end,

  -- View hooks for UI customization
  view = {
    primaryAction = function(game, ctx)
      if not ctx or not ctx.data then
        return nil
      end

      local announced = countAnnouncedGroups(ctx.data)
      local pending = countPendingSolves(ctx.data)

      if pending > 0 then
        local label = pending == 1 and "Announce Result" or ("Announce " .. pending .. " Results")
        return { label = label, enabled = true, command = "announce_winner" }
      end

      if announced >= 4 then
        if game:HasMoreQuestions() then
          return { label = "Next Puzzle", enabled = true, command = "announce_question" }
        end
        return { label = "End Game", enabled = true, command = "end_game" }
      end

      return { label = "Show Words", enabled = true, command = "show_words" }
    end,

    onWinnerFound = function(game, ctx, result)
      if not result then return "" end
      local pending = countPendingSolves(ctx.data)
      if pending == 1 then
        return string.format("%s found a group! Click 'Announce Result' to reveal.", result.solver or "Someone")
      end
      return string.format("%d groups found! Click 'Announce Results' to reveal.", pending)
    end,

    getQuestionTimerSeconds = function(game, ctx)
      -- Connections has no timer
      return nil
    end,
  },

  -- Format hooks for message customization
  format = {
    formatStart = function(meta)
      local total = meta.total or 1
      return string.format("[Trivia] Connections game starting! Puzzles: %d. Find 4 groups of 4 words that share a theme!", total)
    end,

    formatQuestion = function(index, total, question, activeTeamName)
      -- For Connections, this is called to display the puzzle
      -- The actual word grid is sent separately via formatConnectionsPuzzle
      return string.format("[Trivia] Connections Puzzle %d/%d: Find 4 groups of 4!", index, total)
    end,

    formatWinners = function(winners, question, mode)
      -- For Connections, format all pending solves
      if not winners or #winners == 0 then
        return nil
      end

      local messages = {}
      for _, w in ipairs(winners) do
        local wordsStr = table.concat(w.words or {}, ", ")
        local msg = string.format("[Trivia] %s found '%s': %s (+%d pts)",
          w.name or "Someone",
          w.theme or "Group",
          wordsStr,
          w.points or 100)
        table.insert(messages, msg)
      end

      return table.concat(messages, "\n")
    end,
  },
}

-- Helper function to set the current puzzle on mode state.
-- Called by Game or Presenter when loading a new puzzle.
function TriviaClassic_Connections_SetPuzzle(game, puzzle)
  if not game or not game.state or not game.state.modeState then
    return
  end
  local ctx = game.state.modeState
  ctx.data.currentPuzzle = puzzle
end

-- Helper to get puzzle display data.
function TriviaClassic_Connections_GetPuzzleData(game)
  if not game or not game.state or not game.state.modeState then
    return nil
  end
  local ctx = game.state.modeState
  return {
    puzzle = ctx.data.currentPuzzle,
    shuffledWords = ctx.data.shuffledWords,
    remainingWords = ctx.data.remainingWords,
    announcedGroups = ctx.data.announcedGroups,
    pendingSolves = ctx.data.pendingSolves,
    solvedBy = ctx.data.solvedBy,
  }
end

-- Helper to check if puzzle is complete.
function TriviaClassic_Connections_IsPuzzleComplete(game)
  if not game or not game.state or not game.state.modeState then
    return false
  end
  local ctx = game.state.modeState
  return countAnnouncedGroups(ctx.data) >= 4
end

-- Helper to calculate bonus for solving all 4 groups.
function TriviaClassic_Connections_GetCompletionBonus()
  return BONUS_ALL_SOLVED
end

TriviaClassic_RegisterMode(MODE_CONNECTIONS, handler)
