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
    on = function(self, event, handler)
      if not handlers[event] then
        handlers[event] = {}
        frame:RegisterEvent(event)
      end
      table.insert(handlers[event], handler)
    end,
  }
end
