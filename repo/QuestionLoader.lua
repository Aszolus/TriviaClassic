-- QuestionLoader is intentionally lightweight. Question set files should call:
-- TriviaClassic:RegisterTriviaBotSet("<optional label>", TriviaBot_Questions)
-- See QuestionSets/Example.lua for the expected structure.

-- Expose a helper for other files if needed later.
function TriviaClassic_RegisterSet(name, data)
  if TriviaClassic and TriviaClassic.RegisterTriviaBotSet then
    TriviaClassic:RegisterTriviaBotSet(name, data)
  end
end
