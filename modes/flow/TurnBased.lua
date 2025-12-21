-- Flow: shared turn-based helpers (optional steal).


function TriviaClassic_FlowTurnBased_BeginQuestion(ctx, game)
  -- Initialize turn order and steal state for the new question.
  ctx.pendingSteal = false
  ctx.pendingStealQueued = false
  ctx.stealIndex = nil
  ctx.data.attempted = {}
  ctx.data.lastIncorrectTeam = nil
  ctx.data.nextStealTeam = nil
  ctx.data.lastMissReason = nil
  ctx.data.activeTeamName = nil
  ctx.data.reuseWindow = false

  ctx.data.teams = game:GetTeamList()
  local teamCount = ctx.data.teams and #ctx.data.teams or 0
  local startIdx = ctx.data.announceActiveIndex or ctx.data.nextStartIndex or 1
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
  ctx.data.announceActiveIndex = nil
  if ctx.data.activeIndex then
    ctx.data.attempted[ctx.data.activeIndex] = true
  end
end

function TriviaClassic_FlowTurnBased_PeekActiveTeam(ctx, game)
  if not ctx.data.teams or #ctx.data.teams == 0 then
    ctx.data.teams = game:GetTeamList() or {}
  end
  local teamCount = ctx.data.teams and #ctx.data.teams or 0
  if teamCount == 0 then
    return nil
  end
  local startIdx = ctx.data.nextStartIndex or 1
  if startIdx < 1 or startIdx > teamCount then
    startIdx = 1
  end
  ctx.data.announceActiveIndex = startIdx
  ctx.data.activeTeamName = ctx.data.teams[startIdx]
  return ctx.data.activeTeamName
end

function TriviaClassic_FlowTurnBased_OnTimeout(ctx, allowSteal)
  if not allowSteal then
    ctx.pendingWinner = false
    ctx.pendingNoWinner = true
    return
  end
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
end

function TriviaClassic_FlowTurnBased_HandleIncorrect(ctx, allowSteal, teamName)
  local teamCount = ctx.data.teams and #ctx.data.teams or 0
  if allowSteal and teamCount > 1 then
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
  end
  ctx.pendingSteal = false
  ctx.pendingStealQueued = false
  ctx.pendingNoWinner = true
  return nil
end

function TriviaClassic_FlowTurnBased_GetActiveTeamName(ctx)
  if not ctx.data.teams or #ctx.data.teams == 0 then
    return nil
  end
  local idx = ctx.data.activeIndex or 1
  local name = ctx.data.teams[idx]
  ctx.data.activeTeamName = name
  return name
end

function TriviaClassic_FlowTurnBased_StartSteal(ctx, game)
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
  local teamName = ctx.data.teams[targetIndex]
  local members = game:GetTeamMembers(teamName)
  return teamName, members
end

function TriviaClassic_FlowTurnBased_OnAdvance(ctx, game, command)
  if ctx.pendingStealQueued then
    local prev = ctx.data.lastIncorrectTeam
    local nxt = ctx.data.nextStealTeam or (ctx.stealIndex and ctx.data.teams and ctx.data.teams[ctx.stealIndex])
    if command == "announce_incorrect" then
      ctx.pendingStealQueued = false
      ctx.pendingSteal = true
      ctx.data._announceIncorrect = { prev = prev, next = nxt, reason = ctx.data.lastMissReason }
      return { announceIncorrect = ctx.data._announceIncorrect, pendingStealQueued = false, pendingSteal = true }
    end
    -- Queue the steal offer after the incorrect announcement.
    ctx.pendingStealQueued = false
    ctx.pendingSteal = true
    ctx.data._announceIncorrect = { prev = prev, next = nxt, reason = ctx.data.lastMissReason }
  end
  if ctx.pendingSteal then
    local teamName, members = TriviaClassic_FlowTurnBased_StartSteal(ctx, game)
    ctx.data.reuseWindow = true
    ctx.data._announceIncorrect = nil
    return {
      phase = "steal",
      teamName = teamName,
      teamMembers = members,
      question = game:GetCurrentQuestion(),
      index = game.state and game.state.askedCount,
      total = game.state and game.state.totalQuestions,
    }
  end
  return nil
end

function TriviaClassic_FlowTurnBased_PrimaryAction(ctx)
  if ctx.pendingStealQueued then
    local nextTeam = ctx.data.teams[ctx.stealIndex or 0] or "Next team"
    return { command = "announce_incorrect", label = "Announce Incorrect", enabled = true, teamName = nextTeam }
  end
  if ctx.pendingSteal then
    local teamName = ctx.data.teams[ctx.stealIndex or 0] or "Steal"
    return { command = "advance", label = "Offer Steal: " .. teamName, enabled = true }
  end
  return nil
end

local function getParticipation(key)
  if key == "TEAM" then
    return {
      createState = TriviaClassic_Participation_Team_CreateState,
      beginQuestion = TriviaClassic_Participation_Team_BeginQuestion,
      needsPreAdvance = TriviaClassic_Participation_Team_NeedsPreAdvance,
      preAdvance = TriviaClassic_Participation_Team_PreAdvance,
      activeLabel = TriviaClassic_Participation_Team_ActiveLabel,
      canAnswer = TriviaClassic_Participation_Team_CanAnswer,
    }
  elseif key == "HEAD_TO_HEAD" then
    return {
      createState = TriviaClassic_Participation_HeadToHead_CreateState,
      beginQuestion = TriviaClassic_Participation_HeadToHead_BeginQuestion,
      needsPreAdvance = TriviaClassic_Participation_HeadToHead_NeedsPreAdvance,
      preAdvance = TriviaClassic_Participation_HeadToHead_PreAdvance,
      activeLabel = TriviaClassic_Participation_HeadToHead_ActiveLabel,
      canAnswer = TriviaClassic_Participation_HeadToHead_CanAnswer,
      rerollTeam = TriviaClassic_Participation_HeadToHead_RerollTeam,
    }
  end
  return nil
end

local function buildTurnBasedHandler(config, modeKey, allowSteal)
  -- Turn-based flow uses "final:" answers and optional steal windows.
  if config.scoring ~= "FASTEST" then
    return nil
  end
  local attemptKey = config.attempt or "MULTI"
  local participation = getParticipation(config.participation)
  if not participation then
    return nil
  end
  local scoring = TriviaClassic_Scoring_Fastest
  local singleAttempt = attemptKey == "SINGLE_ATTEMPT"

  local handler = {
    createState = function()
      local state = (participation.createState and participation.createState()) or {}
      state.teams = state.teams or {}
      state.activeIndex = state.activeIndex or 0
      state.attempted = state.attempted or {}
      state.nextStartIndex = state.nextStartIndex or 1
      state.lastIncorrectTeam = state.lastIncorrectTeam or nil
      state.nextStealTeam = state.nextStealTeam or nil
      state.activeTeamName = state.activeTeamName or nil
      state.lastMissReason = state.lastMissReason or nil
      state.reuseWindow = state.reuseWindow or false
      local scoringState = scoring.createState()
      for k, v in pairs(scoringState) do
        state[k] = v
      end
      return state
    end,
    beginQuestion = function(ctx, game)
      scoring.beginQuestion(ctx)
      if participation.beginQuestion then
        participation.beginQuestion(ctx, game)
      end
      TriviaClassic_FlowTurnBased_BeginQuestion(ctx, game)
    end,
    rerollTeam = function(game, ctx, teamName)
      if participation.rerollTeam then
        return participation.rerollTeam(game, ctx, teamName)
      end
      return nil
    end,
    onAdvance = function(game, ctx, command)
      local res = TriviaClassic_FlowTurnBased_OnAdvance(ctx, game, command)
      if res then
        return res
      end
      if participation.needsPreAdvance and participation.needsPreAdvance(ctx, game) then
        return participation.preAdvance and participation.preAdvance(game, ctx) or nil
      end
      if not ctx.data.activeTeamAnnounced then
        local activeName = TriviaClassic_FlowTurnBased_PeekActiveTeam(ctx, game)
        ctx.data.activeTeamAnnounced = true
        return { announceActiveTeam = activeName }
      end
      local q, idx, total = game:NextQuestion()
      ctx.data.reuseWindow = false
      return { command = "announce_question", question = q, index = idx, total = total }
    end,
    evaluateAnswer = function(game, ctx, sender, rawMsg)
      if not game:IsQuestionOpen() then
        return nil
      end
      local q = game:GetCurrentQuestion()
      if not q or not q.answers then
        return nil
      end
      ctx.data.teams = ctx.data.teams or game:GetTeamList() or {}
      local teamCount = ctx.data.teams and #ctx.data.teams or 0
      local activeIdx = ctx.data.activeIndex or ctx.stealIndex or 1
      local activeTeamName = ctx.data.activeTeamName or (ctx.data.teams and ctx.data.teams[activeIdx])
      local info = participation.canAnswer and participation.canAnswer(game, ctx, sender, activeTeamName) or { eligible = true, key = sender }
      if not info.eligible then
        return nil
      end
      if teamCount > 0 and activeTeamName and info.teamName and info.teamName ~= activeTeamName then
        return nil
      end
      local candidate = rawMsg
      if singleAttempt then
        if not TriviaClassic_FinalPrefix_Matches(rawMsg) then
          return nil
        end
        candidate = TriviaClassic_FinalPrefix_Extract(game, rawMsg)
      elseif TriviaClassic_FinalPrefix_Matches(rawMsg) then
        candidate = TriviaClassic_FinalPrefix_Extract(game, rawMsg)
      end
      local A = game.deps.answer
      if A and A.match and candidate and A.match(candidate, q) then
        local elapsed = math.max(0.01, game:Now() - (game.state.questionStartTime or game:Now()))
        if ctx.handler and ctx.handler.handleCorrect then
          return ctx.handler.handleCorrect(game, ctx, sender, elapsed, info)
        end
        return nil
      end
      if singleAttempt then
        game.state.questionOpen = false
        return TriviaClassic_FlowTurnBased_HandleIncorrect(ctx, allowSteal, info.teamName)
      end
      return nil
    end,
    handleCorrect = function(game, ctx, sender, elapsed, info)
      ctx.pendingSteal = false
      ctx.pendingStealQueued = false
      ctx.stealIndex = nil
      local entry = {
        key = info.key or sender,
        teamName = info.teamName,
        teamMembers = info.teamMembers,
      }
      return scoring.handleCorrect(game, ctx, sender, elapsed, modeKey, entry)
    end,
    onTimeout = function(_, ctx)
      TriviaClassic_FlowTurnBased_OnTimeout(ctx, allowSteal)
    end,
    pendingWinners = function(game, ctx)
      return scoring.pendingWinners(game, ctx)
    end,
    winnerCount = function(ctx)
      return scoring.winnerCount(ctx)
    end,
    resetProgress = function(ctx)
      scoring.resetProgress(ctx)
      ctx.pendingSteal = false
      ctx.pendingStealQueued = false
      ctx.stealIndex = nil
      ctx.data.activeTeamAnnounced = false
      if ctx.data then
        ctx.data.pairAnnounced = false
      end
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
      local stealAction = TriviaClassic_FlowTurnBased_PrimaryAction(ctx)
      if stealAction then
        return stealAction
      end
      if ctx.pendingNoWinner then
        return { command = "announce_no_winner", label = "Announce No Winner", enabled = true }
      end
      if participation.needsPreAdvance and participation.needsPreAdvance(ctx, game) then
        return { command = "advance", label = "Announce Participants", enabled = true }
      end
      if not ctx.data.activeTeamAnnounced then
        return { command = "advance", label = "Announce Active Team", enabled = true }
      end
      if game:HasMoreQuestions() then
        return { command = "announce_question", label = "Next", enabled = true }
      end
      return { command = "end_game", label = "End", enabled = true }
    end,
    getActiveTeam = function(game, ctx)
      local name = TriviaClassic_FlowTurnBased_GetActiveTeamName(ctx)
      if not name then
        return nil, nil
      end
      if participation.activeLabel then
        return participation.activeLabel(game, ctx, name)
      end
      return name, game:GetTeamMembers(name)
    end,
    onSkip = function(ctx)
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
      ctx.data.reuseWindow = false
      ctx.data.activeTeamAnnounced = false
      if ctx.data.pairAnnounced ~= nil then
        ctx.data.pairAnnounced = false
      end
    end,
  }

  handler.view = {
    getQuestionTimerSeconds = function(game, ctx)
      if allowSteal and ctx and ctx.data and ctx.data.reuseWindow then
        return game.deps and game.deps.getStealTimer and game.deps.getStealTimer() or 20
      end
      return game.deps and game.deps.getTimer and game.deps.getTimer() or 20
    end,
    scoreboardRows = TriviaClassic_View_TeamScoreboard,
  }

  return handler
end

TriviaClassic_BuildFlowTurnBasedHandler = buildTurnBasedHandler
