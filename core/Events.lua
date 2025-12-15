-- Lightweight event bus for decoupling modules.

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
  -- Copy to avoid modification during iteration
  local copy = {}
  for i = 1, #arr do copy[i] = arr[i] end
  for _, fn in ipairs(copy) do
    pcall(fn, ...)
  end
end

