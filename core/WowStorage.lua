function TriviaClassic_CreateWowStorage()
  return {
    get = function()
      return TriviaClassicCharacterDB
    end,
    set = function(db)
      TriviaClassicCharacterDB = db
    end,
  }
end
