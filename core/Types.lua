-- Shared type hints for better IDE assistance (EmmyLua).
-- These are editor-only annotations; they do not affect runtime behavior.

---@class TC_Question
---@field qid string Unique id (setId::sourceIndex)
---@field question string
---@field answers string[] Normalized acceptable answers
---@field displayAnswers any[]|nil Original display answers
---@field hint string|nil Optional hint text
---@field category string Display category name
---@field categoryKey string Lowercased category key
---@field points integer Points for this question
---@field sourceIndex integer Original numeric index from source

---@class TC_Winner
---@field name string|nil Player name (solo)
---@field teamName string|nil Team name (team modes)
---@field teamMembers string[]|nil Team member display names
---@field elapsed number|nil Time to answer in seconds
---@field points integer|nil Points awarded

---@class TC_ScoreRow
---@field name string
---@field points integer
---@field correct integer
---@field bestTime number|nil
---@field times number[]|nil

