function TriviaClassic_CreateWowClock()
  return {
    now = function()
      return GetTime()
    end,
    date = function(fmt)
      return date(fmt)
    end,
  }
end
