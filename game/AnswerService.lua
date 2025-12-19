-- Shared answer normalization and matching utilities

local Answer = {}

local STOP_WORDS = {
  a = true,
  an = true,
  the = true,
  of = true,
  and = true,
  or = true,
  to = true,
  in = true,
  on = true,
  for = true,
  with = true,
  from = true,
}

local function normalizeLoose(text)
  local s = tostring(text or ""):lower()
  -- Replace punctuation with spaces to preserve word boundaries.
  s = s:gsub("%p+", " ")
  s = s:gsub("%s+", " ")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function compact(text)
  return (text or ""):gsub("%s+", "")
end

local function tokenize(text)
  local tokens = {}
  for token in string.gmatch(text or "", "%S+") do
    if not STOP_WORDS[token] then
      table.insert(tokens, token)
    end
  end
  return tokens
end

local function tokenSubset(needles, haystack)
  if #needles == 0 then
    return false
  end
  local set = {}
  for _, t in ipairs(haystack) do
    set[t] = true
  end
  for _, t in ipairs(needles) do
    if not set[t] then
      return false
    end
  end
  return true
end

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
  if norm == "" then
    return false
  end
  local looseCandidate = normalizeLoose(candidate)
  local compactCandidate = compact(looseCandidate)
  local candTokens = tokenize(looseCandidate)
  for _, ans in ipairs((question and question.answers) or {}) do
    local normAns = Answer.normalize(ans)
    if norm == normAns then
      return true
    end

    local looseAns = normalizeLoose(ans)
    if looseCandidate ~= "" and looseCandidate == looseAns then
      return true
    end
    if compactCandidate ~= "" and compactCandidate == compact(looseAns) then
      return true
    end

    local ansTokens = tokenize(looseAns)
    if tokenSubset(candTokens, ansTokens) or tokenSubset(ansTokens, candTokens) then
      return true
    end
  end
  return false
end

TriviaClassic_Answer = Answer
