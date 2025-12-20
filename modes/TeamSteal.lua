local MODE_TEAM_STEAL = "TEAM_STEAL"

local function startsWithFinalPrefix(msg)
  local lowered = tostring(msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  return lowered:find("^final:%s*")
end

local function stripFinalPrefix(msg)
  local lowered = tostring(msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  return lowered:gsub("^final:%s*", "")
end

local handler = {
  createState = function()
    return {
      teams = {},
      activeIndex = 0,
      pendingSteal = false,
      pendingStealQueued = false,
      stealIndex = nil,
      attempted = {},
      nextStartIndex = 1,
      lastIncorrectTeam = nil,
      nextStealTeam = nil,
      activeTeamName = nil,
      lastMissReason = nil,
    }
  end,
  beginQuestion = function(ctx, game)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.pendingSteal = false
    ctx.pendingStealQueued = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
    ctx.lastTeamName = nil
    ctx.lastTeamMembers = nil
    ctx.stealIndex = nil
    ctx.data.attempted = {}
    ctx.data.lastIncorrectTeam = nil
    ctx.data.nextStealTeam = nil
    ctx.data.lastMissReason = nil
    ctx.data.activeTeamName = nil

    -- Build ordered team list each question to reflect changes
    ctx.data.teams = game:GetTeamList()
    local teamCount = ctx.data.teams and #ctx.data.teams or 0
    local startIdx = ctx.data.nextStartIndex or 1
    if teamCount > 0 then
      if startIdx < 1 or startIdx > teamCount then
        startIdx = 1
      end
      ctx.data.activeIndex = startIdx
      ctx.data.nextStartIndex = (startIdx % teamCount) + 1
    else
      ctx.data.activeIndex = 1
      ctx.data.nextStartIndex = 1
    end
    if ctx.data.activeIndex then
      ctx.data.attempted[ctx.data.activeIndex] = true
    end
    ctx.data.reuseWindow = false
  end,
  handleCorrect = function(game, ctx, sender, elapsed)
    local teamName, teamMembers = game:_resolveTeamInfo(sender)
    if not teamName then
      return nil
    end
    ctx.pendingWinner = true
    ctx.pendingNoWinner = false
    ctx.pendingSteal = false
    ctx.lastWinnerName = sender
    ctx.lastWinnerTime = elapsed
    ctx.lastTeamName = teamName
    ctx.lastTeamMembers = teamMembers
    game.state.questionOpen = false
    local points = game:_recordCorrectAnswer(sender, elapsed)
    return {
      winner = sender,
      elapsed = elapsed,
      points = points,
      mode = ctx.key,
      teamName = teamName,
      teamMembers = teamMembers,
      totalWinners = 1,
    }
  end,
  onTimeout = function(game, ctx)
    game:_debug("Timeout for active team; evaluating steal eligibility.")
    -- Only consider steal if another team exists
    local teamCount = ctx.data.teams and #ctx.data.teams or 0
    if teamCount <= 1 then
      ctx.pendingWinner = false
      ctx.pendingNoWinner = true
      return
    end
    local nextIdx = ((ctx.data.activeIndex or 0) % teamCount) + 1
    if ctx.data.attempted[nextIdx] then
      ctx.pendingSteal = false
      ctx.pendingStealQueued = false
      ctx.pendingWinner = false
      ctx.pendingNoWinner = true
      ctx.stealIndex = nil
      return
    end
    ctx.pendingStealQueued = true
    ctx.pendingSteal = false
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.stealIndex = nextIdx
    ctx.data.attempted[nextIdx] = true
    ctx.data.lastIncorrectTeam = ctx.data.teams and ctx.data.teams[ctx.data.activeIndex or 0]
    ctx.data.nextStealTeam = ctx.data.teams and ctx.data.teams[nextIdx]
    ctx.data.lastMissReason = "timeout"
  end,
  pendingWinners = function(game, ctx)
    if not ctx.lastTeamName then
      return {}
    end
    return {
      {
        teamName = ctx.lastTeamName,
        teamMembers = ctx.lastTeamMembers,
        elapsed = ctx.lastWinnerTime,
        points = game:_currentPoints(),
      },
    }
  end,
  winnerCount = function(ctx)
    if ctx.pendingWinner and ctx.lastTeamName then
      return 1
    end
    return 0
  end,
  resetProgress = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.pendingSteal = false
    ctx.pendingStealQueued = false
    ctx.stealIndex = nil
  end,
  primaryAction = function(game, ctx)
    if not game:IsGameActive() then
      return { command = "waiting", label = "Start", enabled = false }
    end
    if game:IsQuestionOpen() then
      return { command = "waiting", label = "Waiting...", enabled = false }
    end
    if ctx.pendingWinner then
      return { command = "announce_winner", label = "Announce Winner", enabled = true }
    end
    if ctx.pendingStealQueued then
      local nextTeam = ctx.data.teams[ctx.stealIndex or 0] or "Next team"
      return { command = "announce_incorrect", label = "Announce Incorrect", enabled = true, teamName = nextTeam }
    end
    if ctx.pendingSteal then
      local teamName = ctx.data.teams[ctx.stealIndex or 0] or "Steal"
      -- Use generic advance to open a reuse answer window; no mode-leaking command names
      return { command = "advance", label = "Offer Steal: " .. teamName, enabled = true }
    end
    if ctx.pendingNoWinner then
      return { command = "announce_no_winner", label = "Announce No Winner", enabled = true }
    end
    if game:HasMoreQuestions() then
      return { command = "announce_question", label = "Next", enabled = true }
    end
    return { command = "end_game", label = "End", enabled = true }
  end,
  getActiveTeam = function(game, ctx)
    if not ctx.data.teams or #ctx.data.teams == 0 then
      return nil, nil
    end
    local idx = ctx.data.activeIndex or 1
    local name = ctx.data.teams[idx]
    ctx.data.activeTeamName = name
    return name, game:GetTeamMembers(name)
  end,
  -- Mode-specific evaluation to enforce active team and "final:" prefix
  evaluateAnswer = function(game, ctx, sender, rawMsg)
    if not game:IsQuestionOpen() then
      return nil
    end
    local teamName, teamMembers = game:_resolveTeamInfo(sender)
    if not teamName then
      return nil
    end
    ctx.data.teams = ctx.data.teams or game:GetTeamList() or {}
    local teamCount = ctx.data.teams and #ctx.data.teams or 0
    local activeIdx = ctx.data.activeIndex or ctx.stealIndex or 1
    local activeTeamName = ctx.data.activeTeamName or (ctx.data.teams and ctx.data.teams[activeIdx])
    if teamCount > 0 and teamName ~= activeTeamName then
      return nil -- wrong team; ignore
    end
    if not startsWithFinalPrefix(rawMsg) then
      return nil -- must use final:
    end
    local A = _G.TriviaClassic_Answer
    local extracted = (A and A.extract and A.extract(rawMsg, { requiredPrefix = "final:", dropPrefix = true })) or stripFinalPrefix(rawMsg)
    local candidate = extracted
    local q = game:GetCurrentQuestion()
    if not q or not q.answers then
      return nil
    end
    if A and A.match and candidate and A.match(candidate, q) then
      local elapsed = math.max(0.01, game:Now() - (game.state.questionStartTime or game:Now()))
      if ctx.handler and ctx.handler.handleCorrect then
        return ctx.handler.handleCorrect(game, ctx, sender, elapsed)
      end
      return nil
    end
    -- incorrect: close and offer steal if available
    game.state.questionOpen = false
    if teamCount > 1 then
      local nextIdx = ((ctx.data.activeIndex or 0) % teamCount) + 1
      if ctx.data.attempted[nextIdx] then
        ctx.pendingSteal = false
        ctx.pendingStealQueued = false
        ctx.pendingWinner = false
        ctx.pendingNoWinner = true
        ctx.stealIndex = nil
        return nil
      end
      ctx.pendingStealQueued = true
        ctx.pendingSteal = false
        ctx.pendingWinner = false
        ctx.pendingNoWinner = false
        ctx.stealIndex = nextIdx
        ctx.data.attempted[nextIdx] = true
        local nextTeam = ctx.data.teams[nextIdx]
        ctx.data.lastIncorrectTeam = teamName
        ctx.data.nextStealTeam = nextTeam
        ctx.data.lastMissReason = "incorrect"
        return { pendingSteal = true, teamName = nextTeam, prevTeamName = teamName, incorrect = true }
    else
      ctx.pendingSteal = false
      ctx.pendingStealQueued = false
      ctx.pendingNoWinner = true
    end
    return nil
  end,
  startSteal = function(game, ctx)
    ctx.data.teams = ctx.data.teams or game:GetTeamList() or {}
    local teamCount = ctx.data.teams and #ctx.data.teams or 0
    if teamCount == 0 then
      return nil
    end
    local targetIndex = ctx.stealIndex or (((ctx.data.activeIndex or 0) % teamCount) + 1)
    ctx.data.activeIndex = targetIndex
    ctx.data.activeTeamName = ctx.data.teams[targetIndex]
    ctx.pendingSteal = false
    ctx.pendingNoWinner = false
    ctx.pendingWinner = false
    game.state.questionOpen = true
    game.state.questionStartTime = game:Now()
    game:_debug(string.format("Starting steal attempt for team index %d.", targetIndex))
    local teamName = ctx.data.teams[targetIndex]
    local members = game:GetTeamMembers(teamName)
    return teamName, members
  end,
  -- Generic advance: when a steal is pending, start it; otherwise move to next question
  onAdvance = function(game, ctx, command)
    if ctx.pendingStealQueued then
      local prev = ctx.data.lastIncorrectTeam
      local nxt = ctx.data.nextStealTeam or (ctx.stealIndex and ctx.data.teams and ctx.data.teams[ctx.stealIndex])
      -- If we're specifically announcing incorrect (no timer), don't flip state yet; caller handles chat
      if command == "announce_incorrect" then
        ctx.pendingStealQueued = false
        ctx.pendingSteal = true
        -- stash once; we do not resend this when starting the steal
        ctx.data._announceIncorrect = { prev = prev, next = nxt, reason = ctx.data.lastMissReason }
        return { announceIncorrect = ctx.data._announceIncorrect, pendingStealQueued = false, pendingSteal = true }
      end
      -- Otherwise, advance into steal setup
      ctx.pendingStealQueued = false
      ctx.pendingSteal = true
      ctx.data._announceIncorrect = { prev = prev, next = nxt, reason = ctx.data.lastMissReason }
    end
    if ctx.pendingSteal then
      local h = ctx.handler or handler
      local startSteal = h and h.startSteal
      local teamName, members = nil, nil
      if startSteal then
        teamName, members = startSteal(game, ctx)
      end
      ctx.data.reuseWindow = true
      ctx.data._announceIncorrect = nil -- already announced
      return {
        phase = "steal",
        teamName = teamName,
        teamMembers = members,
        question = game:GetCurrentQuestion(),
        index = game.state and game.state.askedCount,
        total = game.state and game.state.totalQuestions,
      }
    end
    local q, idx, total = game:NextQuestion()
    ctx.data.reuseWindow = false
    return { command = "announce_question", question = q, index = idx, total = total }
  end,
  onSkip = function(ctx, game)
    ctx.data.attempted = {}
    ctx.pendingSteal = false
    ctx.pendingStealQueued = false
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.stealIndex = nil
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
    ctx.lastTeamName = nil
    ctx.lastTeamMembers = nil
    ctx.data.lastIncorrectTeam = nil
    ctx.data.nextStealTeam = nil
    ctx.data.activeTeamName = nil
    ctx.data.lastMissReason = nil
  end,
}

-- View hooks for Team Steal to avoid leaking mode specifics outside
handler.view = {
  --- Returns the timer seconds for the current answer window (main vs reuse).
  getQuestionTimerSeconds = function(game, ctx)
    local isReuse = ctx and ctx.data and ctx.data.reuseWindow
    if isReuse and TriviaClassic and TriviaClassic.GetStealTimer then
      return TriviaClassic:GetStealTimer()
    end
    return (TriviaClassic and TriviaClassic.GetTimer and TriviaClassic:GetTimer()) or 20
  end,
  scoreboardRows = function(game)
    local list = {}
    for name, info in pairs((game.state and game.state.teamScores) or {}) do
      table.insert(list, {
        name = name,
        points = info.points or 0,
        correct = info.correct or 0,
        members = game:GetTeamMembers(name),
      })
    end
    table.sort(list, function(a, b)
      if a.points == b.points then
        return (a.correct or 0) > (b.correct or 0)
      end
      return (a.points or 0) > (b.points or 0)
    end)
    local fastestName, fastestTime = nil, nil
    if game.state and game.state.fastest then
      fastestName = game.state.fastest.name
      fastestTime = game.state.fastest.time
    end
    return list, fastestName, fastestTime
  end,
}

TriviaClassic_RegisterMode(MODE_TEAM_STEAL, handler)
