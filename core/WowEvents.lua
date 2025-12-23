-- Lightweight event broker over a hidden WoW frame.
-- Used by core init to hook ADDON_LOADED, PLAYER_LOGIN, and chat events.
-- Normalizes WoW events into a simple on/emit API for the addon.
function TriviaClassic_CreateWowEvents()
  local frame = CreateFrame("Frame")
  local handlers = {}

  frame:SetScript("OnEvent", function(_, event, ...)
    local list = handlers[event]
    if not list then
      return
    end
    for _, handler in ipairs(list) do
      handler(event, ...)
    end
  end)

  return {
    -- Subscribe to an event, registering the frame on first use.
    on = function(self, event, handler)
      if not handlers[event] then
        handlers[event] = {}
        frame:RegisterEvent(event)
      end
      table.insert(handlers[event], handler)
    end,
    -- Manual emit used in tests or internal triggers.
    emit = function(self, event, ...)
      local list = handlers[event]
      if not list then
        return
      end
      for _, handler in ipairs(list) do
        handler(event, ...)
      end
    end,
  }
end
