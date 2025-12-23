-- Platform clock wrapper for the WoW API.
-- Abstracts time for deterministic tests and consistent formatting.
function TriviaClassic_CreateWowClock()
  return {
    -- Monotonic time (seconds since UI load), used for elapsed measurements.
    now = function()
      return GetTime()
    end,
    -- Date formatting wrapper for UI timestamps.
    date = function(fmt)
      return date(fmt)
    end,
  }
end
