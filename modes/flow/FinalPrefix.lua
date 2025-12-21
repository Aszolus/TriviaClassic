-- Flow: shared "final:" prefix parsing helpers.

local function startsWithFinalPrefix(msg)
  local lowered = tostring(msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  return lowered:find("^final:%s*")
end

local function stripFinalPrefix(msg)
  local lowered = tostring(msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  return lowered:gsub("^final:%s*", "")
end

function TriviaClassic_FinalPrefix_Matches(msg)
  return startsWithFinalPrefix(msg)
end

function TriviaClassic_FinalPrefix_Extract(game, msg)
  local A = game and game.deps and game.deps.answer or nil
  -- Prefer AnswerService extraction when available.
  if A and A.extract then
    return A.extract(msg, { requiredPrefix = "final:", dropPrefix = true })
  end
  return stripFinalPrefix(msg)
end
