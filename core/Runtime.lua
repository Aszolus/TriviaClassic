local function buildRuntime()
  local runtime = {}
  if TriviaClassic_CreateWowClock then
    runtime.clock = TriviaClassic_CreateWowClock()
  end
  if TriviaClassic_CreateWowChatTransport then
    runtime.chatTransport = TriviaClassic_CreateWowChatTransport()
  end
  if TriviaClassic_CreateWowEvents then
    runtime.events = TriviaClassic_CreateWowEvents()
  end
  if TriviaClassic_CreateWowStorage then
    runtime.storage = TriviaClassic_CreateWowStorage()
  end
  return runtime
end

function TriviaClassic_GetRuntime()
  if not _G.TriviaClassic_Runtime then
    _G.TriviaClassic_Runtime = buildRuntime()
  end
  return _G.TriviaClassic_Runtime
end

function TriviaClassic_SetRuntime(runtime)
  _G.TriviaClassic_Runtime = runtime
end

function TriviaClassic_EnsureDB()
  local runtime = TriviaClassic_GetRuntime()
  if runtime and runtime.storage and runtime.storage.get then
    local db = runtime.storage.get()
    if db then
      _G.TriviaClassicCharacterDB = db
    end
  end
  return _G.TriviaClassicCharacterDB
end
