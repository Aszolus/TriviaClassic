-- Shared chat filtering helpers for incoming messages.

-- Remove WoW color formatting so tag matching works on raw text.
local function stripColorCodes(text)
  local s = tostring(text or "")
  s = s:gsub("|c%x%x%x%x%x%x%x%x", "")
  s = s:gsub("|r", "")
  return s
end

--- Returns true if the message should be ignored by the chat answer handler.
---@param msg any
---@return boolean
function TriviaClassic_ShouldIgnoreMessage(msg)
  local stripped = stripColorCodes(msg)
  local normalized = stripped:lower():gsub("^%s+", "")
  -- Ignore addon-originated messages to avoid feedback loops.
  if normalized:find("^%[trivia%]") then
    return true
  end
  return false
end
