-- Lightweight event bus for decoupling modules.
-- Used for intra-addon signals without hard module dependencies.
-- Map of event name -> array of listeners.
local listeners = {}

--- Subscribe to an event.
---@param name string
---@param fn fun(...)
---@return fun() unsubscribe
function TriviaClassic_On(name, fn)
  if not name or type(fn) ~= "function" then return function() end end
  listeners[name] = listeners[name] or {}
  table.insert(listeners[name], fn)
  return function()
    -- Remove the first matching function instance to preserve order.
    local arr = listeners[name]
    if not arr then return end
    for i = #arr, 1, -1 do
      if arr[i] == fn then table.remove(arr, i) break end
    end
  end
end

--- Emit an event to all subscribers.
---@param name string
---@param ... any
function TriviaClassic_Emit(name, ...)
  local arr = listeners[name]
  if not arr then return end
  -- Copy to avoid modification during iteration (listeners can unsubscribe).
  local copy = {}
  for i = 1, #arr do copy[i] = arr[i] end
  -- Protect emitters from listener errors so one bad handler doesn't break flow.
  for _, fn in ipairs(copy) do
    pcall(fn, ...)
  end
end

