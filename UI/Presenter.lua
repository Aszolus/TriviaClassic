-- UI Presenter: centralizes orchestration and chat broadcasts from user actions.

local Presenter = {}
Presenter.__index = Presenter

function Presenter:new(trivia)
  local o = { trivia = trivia }
  setmetatable(o, self)
  return o
end

--- Starts a game and broadcasts to chat.
---@param desiredCount integer|nil
---@param categoriesBySet table|nil Per-set map of allowed category keys
---@return table|nil meta
function Presenter:StartGame(desiredCount, categoriesBySet)
  local selectedIds = {}
  for _, set in ipairs(self.trivia:GetAllSets()) do
    table.insert(selectedIds, set.id)
  end
  local meta = self.trivia:StartGame(selectedIds, desiredCount, categoriesBySet)
  if meta then
    self.trivia.chat:SendStart(meta)
  end
  return meta
end

--- Announces next question and broadcasts it.
---@return table|nil result
function Presenter:AnnounceQuestion()
  local result = self.trivia:PerformPrimaryAction("announce_question")
  local q = result and result.question
  local index = result and result.index
  local total = result and result.total
  if q and index and total then
    local activeTeamName = nil
    if self.trivia:GetGameMode() == "TEAM_STEAL" then
      activeTeamName = select(1, self.trivia:GetActiveTeam())
    end
    self.trivia.chat:SendQuestion(index, total, q, activeTeamName)
  end
  return result
end

function Presenter:StartSteal()
  local result = self.trivia:PerformPrimaryAction("start_steal")
  local teamName = result and result.teamName
  local q = result and result.question or self.trivia:GetCurrentQuestion()
  local timerSeconds = self.trivia:GetStealTimer()
  self.trivia.chat:SendSteal(teamName, q, timerSeconds)
  self.trivia.chat:SendActiveTeamReminder(teamName or select(1, self.trivia:GetActiveTeam()) or "Next team")
  return result
end

function Presenter:AnnounceWinner()
  local mode = self.trivia:GetGameMode()
  if mode == "ALL_CORRECT" then
    local winners = self.trivia:GetPendingWinners()
    local q = self.trivia:GetCurrentQuestion()
    if winners and #winners > 0 then
      self.trivia.chat:SendWinners(winners, q, mode)
    else
      self:AnnounceNoWinner()
      return { finished = true }
    end
    local result = self.trivia:PerformPrimaryAction("announce_winner")
    return result
  end

  local winnerName, elapsed, teamName, teamMembers = self.trivia:GetLastWinner()
  if not winnerName then
    return nil
  end
  local q = self.trivia:GetCurrentQuestion()
  self.trivia.chat:SendWinner(winnerName, elapsed or 0, q and q.points, teamName, teamMembers)
  local result = self.trivia:PerformPrimaryAction("announce_winner")
  return result
end

function Presenter:AnnounceNoWinner()
  local q = self.trivia:GetCurrentQuestion()
  local answersText = ""
  if q and q.displayAnswers then
    answersText = table.concat(q.displayAnswers, ", ")
  elseif q and q.answers then
    answersText = table.concat(q.answers, ", ")
  end
  self.trivia.chat:SendNoWinner(answersText)
  return self.trivia:PerformPrimaryAction("announce_no_winner")
end

function Presenter:SendWarning()
  self.trivia.chat:SendWarning()
end

function Presenter:AnnounceHint()
  local q = self.trivia:GetCurrentQuestion()
  local hint = q and (q.hint or (q.hints and q.hints[1])) or nil
  if hint and hint ~= "" then
    self.trivia.chat:SendHint(hint)
    return true
  end
  return false
end

function Presenter:SkipQuestion()
  if self.trivia:IsQuestionOpen() then
    self.trivia:SkipCurrentQuestion()
    self.trivia.chat:SendSkipped()
    return true
  end
  return false
end

function Presenter:EndGame()
  local rows, fastestName, fastestTime = self.trivia:GetSessionScoreboard()
  self.trivia.chat:SendEnd(rows, fastestName, fastestTime)
  self.trivia:EndGame()
end

function Presenter:ShowSessionScores()
  local rows, fastestName, fastestTime = self.trivia:GetSessionScoreboard()
  local S = TriviaClassic_Scoreboard
  local lines = S.sessionChatLines(rows, fastestName, fastestTime)
  local chat = self.trivia.chat
  chat:Send("[Trivia] Current game scores:")
  for _, line in ipairs(lines) do
    chat:Send("[Trivia] " .. line)
  end
end

function Presenter:ShowAllTimeScores()
  local rows, fastestName, fastestTime = self.trivia:GetLeaderboard(5)
  local S = TriviaClassic_Scoreboard
  local lines = S.allTimeChatLines(rows, fastestName, fastestTime)
  local chat = self.trivia.chat
  chat:Send("[Trivia] All-time scores:")
  for _, line in ipairs(lines) do
    chat:Send("[Trivia] " .. line)
  end
end

function TriviaClassic_UI_CreatePresenter(trivia)
  return Presenter:new(trivia or TriviaClassic)
end

