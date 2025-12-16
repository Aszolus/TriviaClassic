-- UI Presenter: centralizes orchestration and chat broadcasts from user actions.

local Presenter = {}
Presenter.__index = Presenter

function Presenter:new(trivia)
  local o = { trivia = trivia }
  setmetatable(o, self)
  return o
end

local function getFormatter(game)
  local defaultF = TriviaClassic_MessageFormatter
  if not game or not game.GetModeHandler then return defaultF end
  local handler = game:GetModeHandler()
  if handler and handler.format then
    -- Return a proxy that prefers handler.format functions if present
    local H = handler.format
    return setmetatable({}, {
      __index = function(_, k)
        return H[k] or defaultF[k]
      end,
    })
  end
  return defaultF
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
    local F = getFormatter(self.trivia and self.trivia.game)
    self.trivia.chat:Send(F.formatStart(meta))
  end
  return meta
end

--- Returns the current primary action for the UI.
---@return table action
function Presenter:PrimaryAction()
  return self.trivia:GetPrimaryAction()
end

--- Returns a simplified primary view model for the main button.
---@return table vm {label:string, enabled:boolean, command:string}
function Presenter:PrimaryView()
  -- Prefer mode-provided primaryAction view if available
  local game = self.trivia and self.trivia.game
  local handler = game and game.GetModeHandler and game:GetModeHandler() or nil
  if handler and handler.view and type(handler.view.primaryAction) == "function" then
    local vm = handler.view.primaryAction(game, game and game.state and game.state.modeState)
    if vm and vm.label then
      return {
        label = vm.label or "Next",
        enabled = (vm.enabled ~= false),
        command = vm.command or (self:PrimaryAction() and self:PrimaryAction().command) or "waiting",
      }
    end
  end
  local a = self:PrimaryAction() or { command = "waiting", label = "Start", enabled = false }
  return { label = a.label or "Next", enabled = (a.enabled ~= false), command = a.command or "waiting" }
end

--- Announces next question and broadcasts it.
---@return table|nil result
function Presenter:AnnounceQuestion()
  local result = self.trivia:PerformPrimaryAction("announce_question")
  local q = result and result.question
  local index = result and result.index
  local total = result and result.total
  if q and index and total then
    local activeTeamName = select(1, self.trivia:GetActiveTeam())
    local F = getFormatter(self.trivia and self.trivia.game)
    self.trivia.chat:Send(F.formatQuestion(index, total, q, activeTeamName))
  end
  return result
end

function Presenter:GetQuestionTimerSeconds()
  local game = self.trivia and self.trivia.game
  if game and game.GetModeHandler then
    local handler = game:GetModeHandler()
    if handler and handler.view and type(handler.view.getQuestionTimerSeconds) == "function" then
      return handler.view.getQuestionTimerSeconds(game, game.state and game.state.modeState)
    end
  end
  return self.trivia and self.trivia.GetTimer and self.trivia:GetTimer() or 20
end

--- Handles the primary button click using the current primary action.
function Presenter:OnPrimaryPressed()
  local a = self:PrimaryAction()
  if not a or a.enabled == false or a.command == "waiting" or a.command == "wait" then
    return nil
  end
  if a.command == "announce_question" then
    return self:AnnounceQuestion()
  elseif a.command == "announce_winner" then
    return self:AnnounceWinner()
  elseif a.command == "announce_no_winner" then
    return self:AnnounceNoWinner()
  elseif a.command == "end_game" then
    return self:EndGame()
  else
    -- Generic advance: delegate to mode via Game; handle window reopen or next question
    if self.trivia and self.trivia.game and self.trivia.game.PerformPrimaryAction then
      local res = self.trivia:PerformPrimaryAction(a.command == "announce_incorrect" and "announce_incorrect" or "advance")
      if res and res.participants then
        local F = getFormatter(self.trivia and self.trivia.game)
        self.trivia.chat:Send(F.formatParticipants(res.participants))
        return res
      end
      if res and res.announceIncorrect then
        local F = getFormatter(self.trivia and self.trivia.game)
        local prev = res.announceIncorrect.prev
        local nxt = res.announceIncorrect.next
        if F and F.formatIncorrect then
          self.trivia.chat:Send(F.formatIncorrect(prev, nxt))
        end
        -- If still queued, do not progress further
        if res.pendingStealQueued then
          return res
        end
      end
      if res and (res.command == "announce_question" or res.question) then
        local q = res.question or (self.trivia and self.trivia:GetCurrentQuestion())
        local idx = res.index or (self.trivia and select(1, self.trivia:GetCurrentQuestionIndex()))
        local total = res.total or (self.trivia and select(2, self.trivia:GetCurrentQuestionIndex()))
        local activeTeamName = select(1, self.trivia:GetActiveTeam())
        local F = getFormatter(self.trivia and self.trivia.game)
        self.trivia.chat:Send(F.formatQuestion(idx or 0, total or 0, q, activeTeamName))
        local seconds = self:GetQuestionTimerSeconds()
        return { question = q, index = idx, total = total, timerSeconds = seconds, activeTeamName = activeTeamName }
      end
      return res
    end
  end
end

function Presenter:AnnounceWinner()
  local F = getFormatter(self.trivia and self.trivia.game)
  local winners = self.trivia:GetPendingWinners()
  local q = self.trivia:GetCurrentQuestion()
  if winners and #winners > 0 then
    local msg = F.formatWinners(winners, q, self.trivia:GetGameMode())
    if msg then self.trivia.chat:Send(msg) end
    local result = self.trivia:PerformPrimaryAction("announce_winner")
    return result
  end

  local winnerName, elapsed, teamName, teamMembers = self.trivia:GetLastWinner()
  if not winnerName then
    return nil
  end
  self.trivia.chat:Send(F.formatWinner(winnerName, elapsed or 0, q and q.points, teamName, teamMembers))
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
  local F = getFormatter(self.trivia and self.trivia.game)
  self.trivia.chat:Send(F.formatNoWinner(answersText))
  return self.trivia:PerformPrimaryAction("announce_no_winner")
end

function Presenter:SendWarning(remainingSeconds)
  local F = getFormatter(self.trivia and self.trivia.game)
  self.trivia.chat:Send(F.formatWarning(remainingSeconds))
end

function Presenter:AnnounceHint()
  local q = self.trivia:GetCurrentQuestion()
  local hint = q and (q.hint or (q.hints and q.hints[1])) or nil
  if hint and hint ~= "" then
    local F = getFormatter(self.trivia and self.trivia.game)
    local msg = F.formatHint(hint)
    if msg then self.trivia.chat:Send(msg) end
    return true
  end
  return false
end

function Presenter:SkipQuestion()
  if self.trivia:IsQuestionOpen() then
    self.trivia:SkipCurrentQuestion()
    local F = getFormatter(self.trivia and self.trivia.game)
    self.trivia.chat:Send(F.formatSkipped())
    return true
  end
  return false
end

-- View-model helpers for status texts

function Presenter:StatusQuestionAnnounced(activeTeamName, modeLabel, seconds)
  if activeTeamName and activeTeamName ~= "" then
    return string.format("Question announced. Active team: %s. Listening for answers... (%s)", activeTeamName, modeLabel or "")
  end
  return string.format("Question announced. Listening for answers... (%s)", modeLabel or "")
end

function Presenter:StatusStealListening(activeLabel)
  return string.format("%s can steal. Listening for answers...", activeLabel or "Next team")
end

function Presenter:StatusPendingSteal(activeLabel)
  return string.format("%s can steal. Click the button to offer the steal.", activeLabel or "the next team")
end

function Presenter:StatusWinnerPending(result)
  if not result then return "" end
  local game = self.trivia and self.trivia.game
  local handler = game and game.GetModeHandler and game:GetModeHandler() or nil
  if handler and handler.view and type(handler.view.onWinnerFound) == "function" then
    return handler.view.onWinnerFound(game, game and game.state and game.state.modeState, result)
  end
  local winnerName = result.winner
  local elapsed = result.elapsed
  local teamName = result.teamName
  local teamMembers = result.teamMembers
  if teamName then
    local memberText = (teamMembers and #teamMembers > 0) and (" (" .. table.concat(teamMembers, ", ") .. ")") or ""
    return string.format("%s answered correctly in %.2fs. Click 'Announce Winner' to broadcast.", (teamName or "Team") .. memberText, elapsed or 0)
  end
  return string.format("%s answered correctly in %.2fs. Click 'Announce Winner' to broadcast.", winnerName or "Someone", elapsed or 0)
end

function Presenter:StatusTimeExpired(nextCommand, pendingWinner)
  if nextCommand == "start_steal" then
    return "Time expired. Offer a steal to the next team."
  end
  if pendingWinner then
    return "Time expired. Announce results for this question."
  end
  return "Time expired. Click 'Announce No Winner' to continue."
end

function Presenter:EndGame()
  local rows, fastestName, fastestTime = self.trivia:GetSessionScoreboard()
  local F = getFormatter(self.trivia and self.trivia.game)
  self.trivia.chat:Send(F.formatEndHeader())
  if not rows or #rows == 0 then
    self.trivia.chat:Send("[Trivia] No correct answers recorded.")
  else
    for _, entry in ipairs(rows) do
      self.trivia.chat:Send(F.formatEndRow(entry))
    end
  end
  local fastest = F.formatEndFastest(fastestName, fastestTime)
  if fastest then self.trivia.chat:Send(fastest) end
  self.trivia.chat:Send(F.formatThanks())
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
