-- Participation: head-to-head participant selection helpers.

local function shuffle(list)
  for i = #list, 2, -1 do
    local j = math.random(i)
    list[i], list[j] = list[j], list[i]
  end
end

function TriviaClassic_Participation_HeadToHead_SelectParticipants(game, ctx)
  -- Rotate each team through a shuffled permutation of members.
  local data = ctx.data
  data.permByTeam = data.permByTeam or {}
  data.idxByTeam = data.idxByTeam or {}
  data.selectedByTeam = data.selectedByTeam or {}
  data.teamNames = data.teamNames or {}
  local tnames = game:GetTeamList() or {}
  data.teamNames = {}
  for _, name in ipairs(tnames) do table.insert(data.teamNames, name) end
  data.selectedByTeam = {}
  for _, team in ipairs(data.teamNames) do
    local members = game:GetTeamMembers(team) or {}
    local perm = data.permByTeam[team]
    local idx = data.idxByTeam[team] or 1

    local function permInvalid()
      if not perm or #perm == 0 then return true end
      if idx > #perm then return true end
      local set = {}
      for _, m in ipairs(members) do
        set[m] = true
      end
      for _, p in ipairs(perm) do
        if not set[p] then
          return true
        end
        set[p] = nil
      end
      for _ in pairs(set) do
        return true
      end
      return false
    end

    if permInvalid() then
      perm = {}
      for _, m in ipairs(members) do
        table.insert(perm, m)
      end
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
end

function TriviaClassic_Participation_HeadToHead_RerollTeam(game, ctx, teamName)
  if not ctx.data.pairAnnounced then
    return nil
  end
  local target = tostring(teamName or ""):lower()
  if target == "" then
    return nil
  end
  local data = ctx.data
  local resolved = nil
  for _, name in ipairs(data.teamNames or {}) do
    if tostring(name or ""):lower() == target then
      resolved = name
      break
    end
  end
  if not resolved then
    return nil
  end

  local members = game:GetTeamMembers(resolved) or {}
  if #members == 0 then
    return nil
  end

  local perm = data.permByTeam[resolved]
  local idx = data.idxByTeam[resolved] or 1

  local function permInvalid()
    if not perm or #perm == 0 then return true end
    local set = {}
    for _, m in ipairs(members) do
      set[m] = true
    end
    for _, p in ipairs(perm) do
      if not set[p] then
        return true
      end
      set[p] = nil
    end
    for _ in pairs(set) do
      return true
    end
    return false
  end

  local function rebuild()
    perm = {}
    for _, m in ipairs(members) do
      table.insert(perm, m)
    end
    if #perm > 1 then shuffle(perm) end
    data.permByTeam[resolved] = perm
    idx = 1
  end

  if permInvalid() or idx > #perm then
    rebuild()
  end

  local prev = data.selectedByTeam[resolved]
  local player = perm[idx]
  data.idxByTeam[resolved] = idx + 1
  if player and player ~= "" then
    data.selectedByTeam[resolved] = player
  end

  return { teamName = resolved, player = player, prevPlayer = prev }
end

function TriviaClassic_Participation_HeadToHead_IsEligible(ctx, sender, activeTeamName)
  local data = ctx.data or {}
  local snd = tostring(sender or ""):lower()
  if activeTeamName and activeTeamName ~= "" then
    local player = data.selectedByTeam and data.selectedByTeam[activeTeamName]
    return player and snd == tostring(player or ""):lower()
  end
  for _, player in pairs(data.selectedByTeam or {}) do
    if snd == tostring(player or ""):lower() then
      return true
    end
  end
  return false
end

function TriviaClassic_Participation_HeadToHead_Participants(ctx)
  local list = {}
  for _, team in ipairs((ctx.data and ctx.data.teamNames) or {}) do
    local player = ctx.data.selectedByTeam and ctx.data.selectedByTeam[team]
    if player then
      table.insert(list, { team = team, player = player })
    end
  end
  return list
end

function TriviaClassic_Participation_HeadToHead_CreateState()
  return {
    teamNames = {},
    permByTeam = {},
    idxByTeam = {},
    selectedByTeam = {},
    pairAnnounced = false,
  }
end

function TriviaClassic_Participation_HeadToHead_BeginQuestion(ctx, _)
  if ctx and ctx.data then
    ctx.data.pairAnnounced = false
  end
end

function TriviaClassic_Participation_HeadToHead_NeedsPreAdvance(ctx)
  return not (ctx and ctx.data and ctx.data.pairAnnounced)
end

function TriviaClassic_Participation_HeadToHead_PreAdvance(game, ctx)
  TriviaClassic_Participation_HeadToHead_SelectParticipants(game, ctx)
  if ctx and ctx.data then
    ctx.data.pairAnnounced = true
  end
  return { participants = TriviaClassic_Participation_HeadToHead_Participants(ctx) }
end

function TriviaClassic_Participation_HeadToHead_ActiveLabel(_, ctx, activeTeamName)
  if not activeTeamName or activeTeamName == "" then
    return nil, nil
  end
  local player = ctx and ctx.data and ctx.data.selectedByTeam and ctx.data.selectedByTeam[activeTeamName]
  if player and player ~= "" then
    return string.format("%s (%s)", player, activeTeamName), nil
  end
  return activeTeamName, nil
end

function TriviaClassic_Participation_HeadToHead_CanAnswer(game, ctx, sender, activeTeamName)
  local teamName, teamMembers = game:_resolveTeamInfo(sender)
  if not teamName then
    return { eligible = false }
  end
  -- Only the selected representative for a team can answer.
  if not TriviaClassic_Participation_HeadToHead_IsEligible(ctx, sender, activeTeamName) then
    return { eligible = false }
  end
  if activeTeamName and activeTeamName ~= "" and teamName ~= activeTeamName then
    return { eligible = false }
  end
  return { eligible = true, key = teamName, teamName = teamName, teamMembers = teamMembers }
end
