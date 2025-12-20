function TriviaClassic_CreateWowClock()
  return {
    now = function()
      return GetTime()
    end,
  }
end
