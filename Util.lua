-- Shared utility helpers for TriviaClassic.

--- Trims leading and trailing whitespace.
---@param text any
---@return string
function TriviaClassic_Trim(text)
  local s = text or ""
  s = tostring(s)
  s = s:gsub("^%s+", "")
  s = s:gsub("%s+$", "")
  return s
end

--- Normalizes a display name: trims; returns nil for empty.
---@param text any
---@return string|nil
function TriviaClassic_NormalizeName(text)
  local trimmed = TriviaClassic_Trim(text)
  if trimmed == "" then return nil end
  return trimmed
end

--- Normalizes a key: trimmed lowercase; returns nil for empty.
---@param text any
---@return string|nil
function TriviaClassic_NormalizeKey(text)
  local name = TriviaClassic_NormalizeName(text)
  return name and name:lower() or nil
end

--- Generic clamp for numeric values with default fallback.
---@param value any
---@param min number
---@param max number
---@param default number
---@return integer
function TriviaClassic_ClampNumber(value, min, max, default)
  local n = tonumber(value)
  if not n then return default end
  if n < min then n = min elseif n > max then n = max end
  return math.floor(n + 0.5)
end

