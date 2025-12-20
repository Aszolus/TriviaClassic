function TC_MAKE_REPO(questions)
  local pool = questions or {}
  return {
    BuildPool = function(_, _, _)
      return pool, { "Set A" }
    end,
  }
end

function TC_MAKE_STORE(teams)
  return { leaderboard = {}, teams = { teams = teams or {} } }
end

function TC_ADD_TEAM(store, key, name, members)
  store.teams = store.teams or {}
  store.teams.teams = store.teams.teams or {}
  store.teams.teams[key] = { name = name, members = members or {} }
end

function TC_MAKE_TEAM_MAP(entries)
  local map = {}
  for player, teamKey in pairs(entries or {}) do
    map[tostring(player or ""):lower()] = teamKey
  end
  return map
end

function TC_RESET_DB()
  local runtime = TriviaClassic_GetRuntime and TriviaClassic_GetRuntime()
  if runtime and runtime.storage and runtime.storage.set then
    runtime.storage.set({})
  else
    _G.TriviaClassicCharacterDB = {}
  end
end
