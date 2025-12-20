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
  if runtime.chatTransport and runtime.chatTransport.log then
    runtime.logger = runtime.chatTransport
  end
  if runtime.clock and runtime.clock.date then
    runtime.date = runtime.clock.date
  end
  runtime.answer = _G.TriviaClassic_Answer
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

function TriviaClassic_GetLogger()
  local runtime = TriviaClassic_GetRuntime()
  return runtime and runtime.logger
end
