-- Shared answer normalization and matching utilities

local Answer = {}

--- Normalize a free-form answer string: lowercase, trim, collapse spaces,
--- and strip leading/trailing punctuation.
---@param text any
---@return string
function Answer.normalize(text)
  local s = tostring(text or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("%s+", " ")
  -- strip punctuation/symbols only at the start/end
  s = s:gsub("^%p+", ""):gsub("%p+$", "")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
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
    if norm == Answer.normalize(ans) then
      return true
    end
  end
  return false
end

TriviaClassic_Answer = Answer

