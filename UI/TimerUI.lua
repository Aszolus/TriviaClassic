-- TimerUI: small controller that encapsulates all timer-bar manipulation.
-- Eliminates duplicated SetStatusBarColor / SetMinMaxValues / SetValue / SetText
-- calls scattered across UI.lua.

local C = TriviaClassic_UI_GetConstants()

local TimerUI = {}
TimerUI.__index = TimerUI

function TimerUI:new(bar, text)
  local o = { bar = bar, text = text }
  setmetatable(o, self)
  return o
end

--- Full reset to green bar with a specific duration.
function TimerUI:Reset(seconds)
  local secs = tonumber(seconds) or 0
  local c = C.timerGreen
  self.bar:SetMinMaxValues(0, secs)
  self.bar:SetValue(secs)
  self.bar:SetStatusBarColor(c[1], c[2], c[3])
  self.text:SetText(string.format("Time: %ds", secs))
end

--- Green bar pegged at 1 with "No timer" label (connections mode).
function TimerUI:ResetNoTimer()
  local c = C.timerGreen
  self.bar:SetMinMaxValues(0, 1)
  self.bar:SetValue(1)
  self.bar:SetStatusBarColor(c[1], c[2], c[3])
  self.text:SetText("Time: No timer")
end

--- Expired state: bar at 0, expired color, "Time: 0s".
function TimerUI:SetExpired()
  local c = C.timerExpired
  self.bar:SetValue(0)
  self.bar:SetStatusBarColor(c[1], c[2], c[3])
  self.text:SetText("Time: 0s")
end

--- Skipped state: bar at 0, orange color, "Time: skipped".
function TimerUI:SetSkipped()
  local c = C.timerOrange
  self.bar:SetValue(0)
  self.bar:SetStatusBarColor(c[1], c[2], c[3])
  self.text:SetText("Time: skipped")
end

--- Apply a timer snapshot from TimerService:Tick().
function TimerUI:Update(snap)
  self.bar:SetValue(snap.remaining)
  local key = "timerGreen"
  if snap.color == "red" then
    key = "timerRed"
  elseif snap.color == "orange" then
    key = "timerOrange"
  end
  local c = C[key]
  self.bar:SetStatusBarColor(c[1], c[2], c[3])
  self.text:SetText(string.format("Time: %ds", math.ceil(snap.remaining)))
end

--- Direct text override (e.g. team label appended).
function TimerUI:SetText(text)
  self.text:SetText(text)
end

function TriviaClassic_UI_CreateTimerUI(bar, text)
  return TimerUI:new(bar, text)
end
