-- Saved-variable storage wrapper.
-- Keeps persistence behind a tiny interface to simplify testing.
function TriviaClassic_CreateWowStorage()
  return {
    -- Read the current per-character DB.
    get = function()
      return TriviaClassicCharacterDB
    end,
    -- Replace the per-character DB reference (used on initialization).
    set = function(db)
      TriviaClassicCharacterDB = db
    end,
  }
end
