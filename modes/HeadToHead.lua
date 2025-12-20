local MODE_HEAD_TO_HEAD = "HEAD_TO_HEAD"

local function shuffle(list)
  for i = #list, 2, -1 do
    local j = math.random(i)
    list[i], list[j] = list[j], list[i]
  end
end

local handler = {
  createState = function()
    return {
      data = {
        teamNames = {},
        permByTeam = {},
        idxByTeam = {},
        selectedByTeam = {},
        pairAnnounced = false,
        reuseWindow = false,
      },
      pendingWinner = false,
      pendingNoWinner = false,
      lastWinnerName = nil,
      lastWinnerTime = nil,
      lastTeamName = nil,
    }
  end,

  beginQuestion = function(ctx, game)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = nil
    ctx.lastWinnerTime = nil
    ctx.lastTeamName = nil
    ctx.data.pairAnnounced = false
    ctx.data.reuseWindow = false
    -- teamNames will be refreshed on announce step
  end,

  -- Build or advance per-team player permutations and select one player per team
  _selectParticipants = function(game, ctx)
    local data = ctx.data
    data.permByTeam = data.permByTeam or {}
    data.idxByTeam = data.idxByTeam or {}
    data.selectedByTeam = data.selectedByTeam or {}
    data.teamNames = data.teamNames or {}
    -- Refresh team list
    local tnames = game:GetTeamList() or {}
    data.teamNames = {}
    for _, name in ipairs(tnames) do table.insert(data.teamNames, name) end
    data.selectedByTeam = {}
    for _, team in ipairs(data.teamNames) do
      -- build or refresh permutation
      local perm = data.permByTeam[team]
      local idx = data.idxByTeam[team] or 1
      if not perm or #perm == 0 or idx > #perm then
        perm = {}
        for _, m in ipairs(game:GetTeamMembers(team) or {}) do
          table.insert(perm, m)
        end
        -- keep non-empty
        if #perm > 1 then shuffle(perm) end
        data.permByTeam[team] = perm
        idx = 1
      end
      local player = perm[idx]
      data.idxByTeam[team] = idx + 1
      if player and player ~= "" then
        data.selectedByTeam[team] = player
      end
    end
  end,

  onAdvance = function(game, ctx)
    local data = ctx.data
    if not data.pairAnnounced then
      -- Prefer the context-bound handler so we don't rely on a global
      local h = ctx.handler or handler
      if h and h._selectParticipants then
        h._selectParticipants(game, ctx)
      end
      data.pairAnnounced = true
      -- build participants list for formatter
      local list = {}
      for _, team in ipairs(data.teamNames or {}) do
        local player = data.selectedByTeam[team]
        if player then table.insert(list, { team = team, player = player }) end
      end
      return { participants = list }
    end
    -- Start the question window
    local q, idx, total = game:NextQuestion()
    return { command = "announce_question", question = q, index = idx, total = total }
  end,

  evaluateAnswer = function(game, ctx, sender, rawMsg)
    if not game:IsQuestionOpen() then return nil end
    local q = game:GetCurrentQuestion()
    if not q or not q.answers then return nil end
    -- Eligibility: sender must be one of selected players across teams
    local data = ctx.data
    local eligible = false
    local snd = tostring(sender or ""):lower()
    for _, player in pairs(data.selectedByTeam or {}) do
      if snd == tostring(player or ""):lower() then eligible = true break end
    end
    if not eligible then return nil end
    local A = _G.TriviaClassic_Answer
    local candidate = A and A.extract and A.extract(rawMsg) or rawMsg
    if candidate and A and A.match and A.match(candidate, q) then
      local elapsed = math.max(0.01, game:Now() - (game.state.questionStartTime or game:Now()))
      if ctx.handler and ctx.handler.handleCorrect then
        return ctx.handler.handleCorrect(game, ctx, sender, elapsed)
      end
    end
    return nil
  end,

  handleCorrect = function(game, ctx, sender, elapsed)
    ctx.pendingWinner = true
    ctx.pendingNoWinner = false
    ctx.lastWinnerName = sender
    ctx.lastWinnerTime = elapsed
    local teamName = select(1, game:_resolveTeamInfo(sender))
    ctx.lastTeamName = teamName
    game.state.questionOpen = false
    local points = game:_recordCorrectAnswer(sender, elapsed)
    return {
      winner = sender,
      elapsed = elapsed,
      points = points,
      mode = ctx.key,
      teamName = teamName,
      totalWinners = 1,
    }
  end,

  onTimeout = function(game, ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = true
  end,

  resetProgress = function(ctx)
    ctx.pendingWinner = false
    ctx.pendingNoWinner = false
    ctx.data.pairAnnounced = false
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
    if ctx.pendingNoWinner then
      return { command = "announce_no_winner", label = "Announce No Winner", enabled = true }
    end
    if not ctx.data.pairAnnounced then
      return { command = "advance", label = "Announce Participants", enabled = true }
    end
    if game:HasMoreQuestions() then
      return { command = "announce_question", label = "Start Question", enabled = true }
    end
    return { command = "end_game", label = "End", enabled = true }
  end,
}

handler.view = {
  getActiveTeam = function(game, ctx)
    local names = {}
    for _, team in ipairs((ctx.data and ctx.data.teamNames) or {}) do
      local p = ctx.data.selectedByTeam and ctx.data.selectedByTeam[team]
      if p then table.insert(names, string.format("%s (%s)", p, team)) end
    end
    local label = (#names > 0) and ("Head-to-Head: " .. table.concat(names, " vs ")) or nil
    return label, nil
  end,
  getQuestionTimerSeconds = function(game, ctx)
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

handler.format = {
  formatParticipants = function(participants)
    local parts = {}
    for _, p in ipairs(participants or {}) do
      table.insert(parts, string.format("%s (%s)", p.player or "Player", p.team or "Team"))
    end
    return string.format("[Trivia] Head-to-Head: %s", table.concat(parts, " vs "))
  end,
}

TriviaClassic_RegisterMode(MODE_HEAD_TO_HEAD, handler)

