local function buildFakeRuntime()
  local now = 1000
  local clock = {
    now = function()
      return now
    end,
    advance = function(seconds)
      now = now + (seconds or 0)
    end,
  }

  local transport = {
    sent = {},
    systemMessages = {},
    send = function(msg, entry, customId)
      table.insert(transport.sent, { msg = msg, entry = entry, customId = customId })
    end,
    system = function(msg)
      table.insert(transport.systemMessages, msg)
    end,
    joinChannel = function(_) end,
    getChannelId = function(_)
      return 1
    end,
    isInRaid = function()
      return true
    end,
    isInGroup = function()
      return true
    end,
    getTimer = function()
      return 20
    end,
    getStealTimer = function()
      return 20
    end,
    log = function(msg)
      table.insert(transport.systemMessages, msg)
    end,
  }

  local handlers = {}
  local events = {
    on = function(_, event, handler)
      handlers[event] = handlers[event] or {}
      table.insert(handlers[event], handler)
    end,
    emit = function(_, event, ...)
      for _, handler in ipairs(handlers[event] or {}) do
        handler(event, ...)
      end
    end,
  }

  local db = {}
  local storage = {
    get = function()
      return db
    end,
    set = function(value)
      db = value
    end,
  }

  return {
    clock = clock,
    chatTransport = transport,
    events = events,
    storage = storage,
    date = function(fmt)
      return os.date(fmt)
    end,
    logger = transport,
  }
end

local runtime = buildFakeRuntime()
TriviaClassic_SetRuntime(runtime)

function __TC_ADVANCE_TIME(seconds)
  runtime.clock.advance(seconds)
end

if not _G.date then
  _G.date = function(fmt)
    local rt = TriviaClassic_GetRuntime()
    return rt.date and rt.date(fmt) or os.date(fmt)
  end
end
