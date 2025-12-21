-- Flow: Open for participation types, Fastest/All-Correct scoring.


local function getParticipation(key)
  -- Map participation keys to their hook tables.
  if key == "INDIVIDUAL" then
    return {
      createState = TriviaClassic_Participation_Individual_CreateState,
      beginQuestion = TriviaClassic_Participation_Individual_BeginQuestion,
      needsPreAdvance = TriviaClassic_Participation_Individual_NeedsPreAdvance,
      preAdvance = TriviaClassic_Participation_Individual_PreAdvance,
      activeLabel = TriviaClassic_Participation_Individual_ActiveLabel,
      canAnswer = TriviaClassic_Participation_Individual_CanAnswer,
    }
  elseif key == "TEAM" then
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

local function buildOpenHandler(config, modeKey)
  local participation = getParticipation(config.participation)
  local scoringKey = config.scoring
  local attemptKey = config.attempt or "MULTI"
  if not participation then
    return nil
  end
  if scoringKey ~= "FASTEST" and scoringKey ~= "ALL_CORRECT" then
    return nil
  end

  local scoring = (scoringKey == "ALL_CORRECT") and TriviaClassic_Scoring_AllCorrect or TriviaClassic_Scoring_Fastest
  local singleAttempt = attemptKey == "SINGLE_ATTEMPT"

  local handler = {
    createState = function()
      local state = (participation.createState and participation.createState()) or {}
      local scoringState = scoring.createState()
      for k, v in pairs(scoringState) do
        state[k] = v
      end
      return state
    end,
    beginQuestion = function(ctx, game)
      scoring.beginQuestion(ctx)
      if ctx.data then
        ctx.data.attemptedKeys = {}
      end
      if participation.beginQuestion then
        participation.beginQuestion(ctx, game)
      end
    end,
    rerollTeam = function(game, ctx, teamName)
      if participation.rerollTeam then
        return participation.rerollTeam(game, ctx, teamName)
      end
      return nil
    end,
    onAdvance = function(game, ctx)
      if participation.needsPreAdvance and participation.needsPreAdvance(ctx, game) then
        -- Allow pre-advance steps like head-to-head participant announcements.
        return participation.preAdvance and participation.preAdvance(game, ctx) or nil
      end
      local q, idx, total = game:NextQuestion()
      return { command = "announce_question", question = q, index = idx, total = total }
    end,
    evaluateAnswer = function(game, ctx, sender, rawMsg)
      if not game:IsQuestionOpen() then return nil end
      local q = game:GetCurrentQuestion()
      if not q or not q.answers then return nil end
      local info = participation.canAnswer and participation.canAnswer(game, ctx, sender, nil) or { eligible = true, key = sender }
      if not info.eligible then
        return nil
      end
      local attemptKey = info.key or sender
      if singleAttempt and ctx.data and ctx.data.attemptedKeys and ctx.data.attemptedKeys[attemptKey] then
        return nil
      end
      local candidate = rawMsg
      if singleAttempt then
        if not TriviaClassic_FinalPrefix_Matches(rawMsg) then
          return nil
        end
        candidate = TriviaClassic_FinalPrefix_Extract(game, rawMsg)
      end
      local A = game.deps.answer
      if singleAttempt and ctx.data and ctx.data.attemptedKeys then
        ctx.data.attemptedKeys[attemptKey] = true
      end
      if A and A.match and candidate and A.match(candidate, q) then
        local elapsed = math.max(0.01, game:Now() - (game.state.questionStartTime or game:Now()))
        local entry = {
          key = attemptKey,
          teamName = info.teamName,
          teamMembers = info.teamMembers,
        }
        if ctx.handler and ctx.handler.handleCorrect then
          return ctx.handler.handleCorrect(game, ctx, sender, elapsed, entry)
        end
      end
      return nil
    end,
    handleCorrect = function(game, ctx, sender, elapsed, entry)
      return scoring.handleCorrect(game, ctx, sender, elapsed, modeKey, entry)
    end,
    onTimeout = function(_, ctx)
      scoring.onTimeout(ctx)
    end,
    pendingWinners = function(game, ctx)
      return scoring.pendingWinners(game, ctx)
    end,
    winnerCount = function(ctx)
      return scoring.winnerCount(ctx)
    end,
    resetProgress = function(ctx)
      scoring.resetProgress(ctx)
      if ctx.data and ctx.data.pairAnnounced ~= nil then
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
        return { command = "announce_winner", label = scoring.winnerLabel(), enabled = true }
      end
      if ctx.pendingNoWinner then
        return { command = "announce_no_winner", label = "Announce No Winner", enabled = true }
      end
      if participation.needsPreAdvance and participation.needsPreAdvance(ctx, game) then
        return { command = "advance", label = "Announce Participants", enabled = true }
      end
      if game:HasMoreQuestions() then
        return { command = "announce_question", label = "Next", enabled = true }
      end
      return { command = "end_game", label = "End", enabled = true }
    end,
  }

  handler.view = handler.view or {}
  if scoringKey == "ALL_CORRECT" then
    handler.view.onWinnerFound = scoring.onWinnerFound
  end
  if config.participation == "TEAM" or config.participation == "HEAD_TO_HEAD" then
    handler.view.scoreboardRows = TriviaClassic_View_TeamScoreboard
  end

  return handler
end

TriviaClassic_BuildFlowOpenHandler = buildOpenHandler
