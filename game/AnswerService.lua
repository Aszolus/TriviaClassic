-- Shared answer normalization and matching utilities.
-- Used by Game:HandleChatAnswer to decide if a chat message is correct.

local Answer = {}
local MIN_SUBSTRING_LEN = 4

-- Strip a leading "the" to avoid penalizing articles in answers.
local function stripLeadingThe(value)
  if value and value:find("^the") then
    return value:sub(4)
  end
  return value
end

--- Normalize a free-form answer string: lowercase, remove all spaces,
--- and remove punctuation/symbols except apostrophes inside words.
---@param text any
---@return string
function Answer.normalize(text)
  local s = tostring(text or ""):lower()
  s = s:gsub("%s+", "") -- Remove all spaces (tabs, newlines, etc. too)
  local marker = string.char(1)
  -- Preserve apostrophes inside words while stripping other punctuation.
  s = s:gsub("(%w)'(%w)", "%1" .. marker .. "%2")
  s = s:gsub("%p+", "") -- Remove all punctuation/symbols
  s = s:gsub(marker, "'")
  return s
end

--- Extract a candidate from a raw message using simple policy options.
--- opts: { requiredPrefix = "final:", dropPrefix = true }
---@param raw any
---@param opts table|nil
---@return string|nil
function Answer.extract(raw, opts)
  local msg = tostring(raw or "")
  opts = opts or {}
  if opts.requiredPrefix then
    local lowered = msg:lower()
    local pref = tostring(opts.requiredPrefix):lower()
    if not lowered:find("^" .. pref .. "%s*") then
      return nil
    end
    if opts.dropPrefix ~= false then
      msg = msg:gsub("^" .. opts.requiredPrefix .. "%s*", "")
    end
  end
  return msg
end

--- Match a candidate string against a question's acceptable answers.
---@param candidate string
---@param question table
---@return boolean
function Answer.match(candidate, question)
  -- Normalized substring matching allows partial answers while avoiding
  -- false positives from very short strings.
  local norm = Answer.normalize(candidate)
  for _, ans in ipairs((question and question.answers) or {}) do
    local target = Answer.normalize(ans)
    if target ~= "" then
      if norm == target or norm == stripLeadingThe(target) then
        return true
      end
      if not target:find("^%d+$") then
        if #target >= MIN_SUBSTRING_LEN and norm:find(target, 1, true) then
          return true
        end
        local stripped = stripLeadingThe(target)
        if stripped and stripped ~= "" and #stripped >= MIN_SUBSTRING_LEN and norm:find(stripped, 1, true) then
          return true
        end
      end
    end
  end
  return false
end

TriviaClassic_Answer = Answer
