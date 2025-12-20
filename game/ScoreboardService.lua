-- Scoreboard helpers for UI text and chat summaries.

local S = {}

local function sortRowsByPoints(rows)
  local list = {}
  for i, entry in ipairs(rows or {}) do
    list[i] = entry
  end
  table.sort(list, function(a, b)
    local ap = tonumber(a.points) or 0
    local bp = tonumber(b.points) or 0
    if ap == bp then
      local ac = tonumber(a.correct) or 0
      local bc = tonumber(b.correct) or 0
      if ac == bc then
        local at = tonumber(a.bestTime) or math.huge
        local bt = tonumber(b.bestTime) or math.huge
        if at == bt then
          return tostring(a.name or ""):lower() < tostring(b.name or ""):lower()
        end
        return at < bt
      end
      return ac > bc
    end
    return ap > bp
  end)
  return list
end

--- Format scoreboard text for UI panel.
---@param rows TC_ScoreRow[]
---@param fastestName string|nil
---@param fastestTime number|nil
---@return string
function S.formatUIPanel(rows, fastestName, fastestTime)
  if not rows or #rows == 0 then
    return "No answers yet."
  end
  rows = sortRowsByPoints(rows)
  local lines = {}
  for i, entry in ipairs(rows) do
    if i > 12 then break end
    local best = entry.bestTime and string.format(" (best %.1fs)", entry.bestTime) or ""
    table.insert(lines, string.format("%d) %s - %d pts (%d correct)%s", i, entry.name, entry.points or 0, entry.correct or 0, best))
  end
  local text = table.concat(lines, "\n")
  if fastestName and fastestTime then
    text = text .. "\nFastest answer: " .. fastestName .. " (" .. string.format("%.2f", fastestTime) .. "s)"
  end
  return text
end

--- Build chat lines for session scoreboard (not including the header).
---@param rows TC_ScoreRow[]
---@param fastestName string|nil
---@param fastestTime number|nil
---@return string[] lines
function S.sessionChatLines(rows, fastestName, fastestTime)
  local lines = {}
  if not rows or #rows == 0 then
    table.insert(lines, "No answers yet.")
    return lines
  end
  rows = sortRowsByPoints(rows)
  for _, entry in ipairs(rows) do
    table.insert(lines, string.format("%s - %d pts (%d correct, best %.2fs)", entry.name, entry.points or 0, entry.correct or 0, (entry.bestTime or 0)))
  end
  if fastestName and fastestTime then
    table.insert(lines, string.format("Speed record this game: %s (%.2fs)", fastestName, fastestTime))
  end
  return lines
end

--- Build chat lines for all-time leaderboard (not including the header).
---@param rows TC_ScoreRow[]
---@param fastestName string|nil
---@param fastestTime number|nil
---@return string[] lines
function S.allTimeChatLines(rows, fastestName, fastestTime)
  local lines = {}
  if not rows or #rows == 0 then
    table.insert(lines, "No scores recorded.")
    return lines
  end
  rows = sortRowsByPoints(rows)
  for i, entry in ipairs(rows) do
    table.insert(lines, string.format("%d) %s - %d pts (%d correct)", i, entry.name, entry.points or 0, entry.correct or 0))
  end
  if fastestName and fastestTime then
    table.insert(lines, string.format("All-time fastest: %s (%.2fs)", fastestName, fastestTime))
  end
  return lines
end

TriviaClassic_Scoreboard = S

