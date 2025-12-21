-- Shared answer normalization and matching utilities

local Answer = {}

--- Normalize a free-form answer string: lowercase, remove all spaces,
--- and remove punctuation/symbols except apostrophes inside words.
---@param text any
---@return string
function Answer.normalize(text)
  local s = tostring(text or ""):lower()
  s = s:gsub("%s+", "") -- Remove all spaces (tabs, newlines, etc. too)
  local marker = string.char(1)
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
  local norm = Answer.normalize(candidate)
  for _, ans in ipairs((question and question.answers) or {}) do
    local target = Answer.normalize(ans)
    if norm == target or (target ~= "" and norm:find(target, 1, true)) then
      return true
    end
  end
  return false
end

TriviaClassic_Answer = Answer
