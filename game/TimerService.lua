-- TimerService manages per-question countdown state (no UI or chat side effects).
-- Used by the UI to drive countdown bars and warnings.

local Timer = {}
Timer.__index = Timer

-- Warning thresholds for UI color changes.
local WARNING_ORANGE_SECONDS = 10
local WARNING_RED_SECONDS = 5

function Timer:new(totalSeconds)
  local o = {
    total = tonumber(totalSeconds) or 0,
    remaining = tonumber(totalSeconds) or 0,
    running = false,
  }
  setmetatable(o, self)
  return o
end

function Timer:Start(totalSeconds)
  -- Start resets remaining time and marks the timer running.
  self.total = tonumber(totalSeconds) or self.total or 0
  self.remaining = self.total
  self.running = self.total > 0
end

function Timer:Stop()
  -- Stop hard-resets remaining time to zero.
  self.running = false
  self.remaining = 0
end

--- Advances the timer and returns a snapshot for UI.
---@param elapsed number
---@return table snapshot { remaining:number, expired:boolean, color:string }
function Timer:Tick(elapsed)
  -- Color is a UI hint (green/orange/red) based on remaining time.
  if not self.running then
    return { remaining = self.remaining or 0, expired = self.remaining <= 0, color = "green" }
  end
  self.remaining = (self.remaining or 0) - (tonumber(elapsed) or 0)
  if self.remaining <= 0 then
    self.remaining = 0
    self.running = false
    return { remaining = 0, expired = true, color = "red" }
  end
  local color = "green"
  if self.remaining <= WARNING_RED_SECONDS then
    color = "red"
  elseif self.remaining <= WARNING_ORANGE_SECONDS then
    color = "orange"
  end
  return { remaining = self.remaining, expired = false, color = color }
end

function TriviaClassic_CreateTimer(totalSeconds)
  local t = Timer:new(totalSeconds)
  t:Start(totalSeconds)
  return t
end

