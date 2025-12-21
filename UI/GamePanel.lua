local UI = TriviaClassicUI
if not UI then
  UI = {}
  TriviaClassicUI = UI
end

function UI:RefreshPrimaryButton()
  if not self.nextButton then
    return
  end
  local vm = (self.presenter and self.presenter:PrimaryView()) or { label = "Next", enabled = true }
  self.nextButton:SetText(vm.label or "Next")
  if vm.enabled == false then self.nextButton:Disable() else self.nextButton:Enable() end
  self:UpdateRerollControls()
end

function UI:OnPendingSteal(event)
  if not event then
    return
  end
  local teamName = event.teamName or "the next team"
  if self.presenter and self.presenter.StatusPendingSteal then
    self.frame.statusText:SetText(self.presenter:StatusPendingSteal(teamName))
  else
    self.frame.statusText:SetText(string.format("%s can steal. Click the button to offer the steal.", teamName))
  end
  self:RefreshPrimaryButton()
end

function UI:SetRerollTeam(name)
  self.rerollTeamName = name
  if self.rerollTeamDropDown then
    UIDropDownMenu_SetSelectedValue(self.rerollTeamDropDown, name)
    UIDropDownMenu_SetText(self.rerollTeamDropDown, name or "Select team")
  end
end

function UI:RefreshRerollTeamDropdown()
  if not self.rerollTeamDropDown then
    return
  end
  local teams = (TriviaClassic.game and TriviaClassic.game.GetTeamList and TriviaClassic.game:GetTeamList()) or {}
  local current = self.rerollTeamName
  if not current and teams[1] then
    current = teams[1]
  end
  UIDropDownMenu_Initialize(self.rerollTeamDropDown, function()
    for _, name in ipairs(teams) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = name
      info.value = name
      info.func = function()
        self:SetRerollTeam(name)
      end
      info.checked = (self.rerollTeamName == name)
      UIDropDownMenu_AddButton(info)
    end
  end)
  self:SetRerollTeam(current)
end

function UI:UpdateRerollControls()
  if not (self.rerollTeamButton and self.rerollTeamDropDown and self.rerollLabel) then
    return
  end
  local cfg = TriviaClassic:GetGameAxisConfig()
  if not cfg or cfg.participation ~= "HEAD_TO_HEAD" then
    self.rerollLabel:Hide()
    self.rerollTeamDropDown:Hide()
    self.rerollTeamButton:Hide()
    return
  end
  self.rerollLabel:Show()
  self.rerollTeamDropDown:Show()
  self.rerollTeamButton:Show()
  self:RefreshRerollTeamDropdown()

  local ready = false
  local game = TriviaClassic.game
  if game and game.state and game.state.modeState and game.state.modeState.data then
    ready = game.state.modeState.data.pairAnnounced == true
  end
  if ready and self.rerollTeamName then
    self.rerollTeamButton:Enable()
  else
    self.rerollTeamButton:Disable()
  end
end

function UI:UpdateSessionBoard()
  if not self.sessionBoard then
    return
  end
  local rows, fastestName, fastestTime = TriviaClassic:GetSessionScoreboard()
  local S = TriviaClassic_Scoreboard
  local text = S.formatUIPanel(rows, fastestName, fastestTime)
  self.sessionBoard:SetText(text)
end

function UI:ShowSessionScores()
  if self.presenter then self.presenter:ShowSessionScores() end
end

function UI:ShowAllTimeScores()
  if self.presenter then self.presenter:ShowAllTimeScores() end
end

function UI:GetCurrentTimerRemaining()
  local remaining = nil
  if self.timerRunning and self.timerService and self.timerService.remaining then
    remaining = self.timerService.remaining
  elseif self.timerBar and self.timerBar.GetValue then
    remaining = self.timerBar:GetValue()
  end
  if remaining and remaining >= 0 then
    return math.ceil(remaining)
  end
end

function UI:ResetTimerDisplay(seconds)
  local secs = tonumber(seconds) or self:GetTimerSeconds()
  self.timerRemaining = secs
  self.timerRunning = false
  if self.timerBar then
    self.timerBar:SetMinMaxValues(0, secs)
    self.timerBar:SetValue(secs)
    self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  end
  if self.timerText then
    self.timerText:SetText(string.format("Time: %ds", secs))
  end
end

function UI:StartGame()
  local desiredCount = tonumber(self.questionCountInput and self.questionCountInput:GetText() or "")
  self:ApplyTimerInput()
  -- Persist selected axis config before starting
  self:SetAxisSelection(self.participationKey, self.flowKey, self.scoringKey, self.attemptKey, self.stealAllowed)
  -- Build per-set categories map for all sets (default-deny when empty)
  local categoriesBySet = self.BuildSelectedCategoriesBySet and self:BuildSelectedCategoriesBySet() or {}
  local meta = self.presenter and self.presenter:StartGame(desiredCount, categoriesBySet) or TriviaClassic:StartGame({}, desiredCount, categoriesBySet)
  if not meta then
    print("|cffff5050TriviaClassic: No questions available.|r")
    return
  end

  self:RefreshPrimaryButton()
  if self.skipButton then
    self.skipButton:Enable()
  end
  self.warningButton:Disable()
  self.frame.statusText:SetText(string.format("Game started (%s). %d questions ready.", meta.modeLabel or self:GetAxisLabel(), meta.total))
  self.questionLabel:SetText("Press Next to announce Question 1.")
  self.categoryLabel:SetText("")
  local timerSeconds = self:GetTimerSeconds()
  self:ResetTimerDisplay(timerSeconds)
  self.timerRunning = false
  self.questionNumber = 0
  self:UpdateSessionBoard()
  self:UpdateRerollControls()
  -- Chat already sent by presenter
  if self.endButton then
    self.endButton:Enable()
  end
end

function UI:AnnounceQuestion()
  local result = self.presenter and self.presenter:AnnounceQuestion() or TriviaClassic:PerformPrimaryAction("announce_question")
  local q = result and result.question
  local index = result and result.index
  local total = result and result.total
  local activeTeamName = select(1, TriviaClassic:GetActiveTeam())
  if not q then
    self.frame.statusText:SetText("No more questions. End the game.")
    self:RefreshPrimaryButton()
    return
  end

  self.questionNumber = index
  self.currentQuestion = q
  self.questionLabel:SetText(string.format("Q%d/%d: %s", index, total, q.question))
  self.categoryLabel:SetText(string.format("Category: %s  |  Points: %s", q.category or "General", tostring(q.points or 1)))
  local modeLabel = self:GetAxisLabel()
  if self.presenter and self.presenter.StatusQuestionAnnounced then
    self.frame.statusText:SetText(self.presenter:StatusQuestionAnnounced(activeTeamName, modeLabel, self:GetTimerSeconds()))
  else
    if activeTeamName then
      self.frame.statusText:SetText(string.format("Question announced. Active team: %s. Listening for answers... (%s)", activeTeamName, modeLabel))
      self.timerText:SetText(string.format("Time: %ds (Team: %s)", self:GetTimerSeconds(), activeTeamName))
    else
      self.frame.statusText:SetText(string.format("Question announced. Listening for answers... (%s)", modeLabel))
    end
  end

  local timerSeconds = self:GetTimerSeconds()
  -- Initialize timer service (UI still controls side-effects on expiration)
  self.timerService = TriviaClassic_CreateTimer(timerSeconds)
  self.timerRunning = true
  self.timerBar:SetMinMaxValues(0, timerSeconds)
  self.timerBar:SetValue(timerSeconds)
  self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  self.timerText:SetText(string.format("Time: %ds", timerSeconds))
  self.warningButton:Enable()
  if self.hintButton then
    -- Enable hint button only if this question actually has a hint
    local hint = q.hint or (q.hints and q.hints[1])
    if hint and hint ~= "" then
      self.hintButton:Enable()
    else
      self.hintButton:Disable()
    end
  end
  if self.skipButton then
    self.skipButton:Enable()
  end

  -- Chat already sent by presenter
  self:RefreshPrimaryButton()
end

function UI:AnnounceWinner()
  if not TriviaClassic:IsPendingWinner() then
    return
  end
  local cfg = TriviaClassic:GetGameAxisConfig()
  if cfg and cfg.scoring == "ALL_CORRECT" then
    self.timerRunning = false
    local winners = TriviaClassic:GetPendingWinners()
    local result = nil
    if winners and #winners > 0 then
      if self.presenter and self.presenter.AnnounceWinner then
        result = self.presenter:AnnounceWinner()
      else
        result = TriviaClassic:PerformPrimaryAction("announce_winner")
      end
      self.frame.statusText:SetText("Results announced. Click Next for the next question.")
    else
      self:AnnounceNoWinner()
      return
    end
    local finished = result and result.finished
    if finished then
      self.frame.statusText:SetText("Results announced. Click End to finish.")
    end
    self.nextButton:Enable()
    if self.skipButton then
      self.skipButton:Disable()
    end
    self:UpdateSessionBoard()
    self:RefreshPrimaryButton()
    return
  end

  local winnerName, elapsed, teamName, teamMembers = TriviaClassic:GetLastWinner()
  if not winnerName then
    return
  end
  if self.presenter then self.presenter:AnnounceWinner() end
  if teamName then
    local memberText = (teamMembers and #teamMembers > 0) and (" (" .. table.concat(teamMembers, ", ") .. ")") or ""
    self.frame.statusText:SetText(string.format("%s answered correctly in %.2fs. Click Next for the next question.", teamName .. memberText, elapsed or 0))
  else
    self.frame.statusText:SetText("Winner announced. Click Next for the next question.")
  end
  -- Game state advanced by presenter
  self.nextButton:Enable()
  if self.skipButton then
    self.skipButton:Disable()
  end
  self:RefreshPrimaryButton()
end

function UI:AnnounceNoWinner()
  if self.presenter then self.presenter:AnnounceNoWinner() end
  self.nextButton:Enable()
  if self.skipButton then
    self.skipButton:Disable()
  end
  self:RefreshPrimaryButton()
end

function UI:EndGame()
  if self.presenter then self.presenter:EndGame() end
  self.frame.statusText:SetText("Game ended. Press Start to begin a new game.")
  self:RefreshPrimaryButton()
  if self.skipButton then
    self.skipButton:Disable()
  end
  self.warningButton:Disable()
  self.timerRunning = false
  self:UpdateRerollControls()
end

function UI:RerollTeamParticipant()
  local teamName = self.rerollTeamName
  if not teamName or teamName == "" then
    self.frame.statusText:SetText("Select a team to rotate.")
    return
  end
  local res = self.presenter and self.presenter.RerollTeam and self.presenter:RerollTeam(teamName)
  if res and res.player then
    local msg = string.format("Head-to-Head: %s now selecting %s.", res.teamName or teamName, res.player)
    if res.prevPlayer and res.prevPlayer ~= res.player then
      msg = string.format("Head-to-Head: %s now selecting %s (was %s).", res.teamName or teamName, res.player, res.prevPlayer)
    end
    self.frame.statusText:SetText(msg)
  end
  self:UpdateRerollControls()
end

function UI:OnNextPressed()
  if not TriviaClassic:IsGameActive() then
    self.frame.statusText:SetText("Start a game first.")
    return
  end

  local action = (self.presenter and self.presenter:PrimaryAction()) or TriviaClassic:GetPrimaryAction()
  if not action or action.command == "waiting" or action.command == "wait" or action.enabled == false then
    self.frame.statusText:SetText("A question is already active.")
    return
  end
  if self.presenter and self.presenter.OnPrimaryPressed then
    local res = self.presenter:OnPrimaryPressed()
    if res and res.question then
      local q = res.question
      local index = res.index or 0
      local total = res.total or 0
      self.questionNumber = index
      self.currentQuestion = q
      self.questionLabel:SetText(string.format("Q%d/%d: %s", index, total, q.question))
      self.categoryLabel:SetText(string.format("Category: %s  |  Points: %s", q.category or "General", tostring(q.points or 1)))
      local modeLabel = self:GetAxisLabel()
      local activeTeamName = res.activeTeamName
      if self.presenter and self.presenter.StatusQuestionAnnounced then
        self.frame.statusText:SetText(self.presenter:StatusQuestionAnnounced(activeTeamName, modeLabel, res.timerSeconds or self:GetTimerSeconds()))
      else
        if activeTeamName then
          self.frame.statusText:SetText(string.format("Question announced. Active team: %s. Listening for answers... (%s)", activeTeamName, modeLabel))
          self.timerText:SetText(string.format("Time: %ds (Team: %s)", res.timerSeconds or self:GetTimerSeconds(), activeTeamName))
        else
          self.frame.statusText:SetText(string.format("Question announced. Listening for answers... (%s)", modeLabel))
        end
      end
      local timerSeconds = res.timerSeconds or self:GetTimerSeconds()
      self.timerService = TriviaClassic_CreateTimer(timerSeconds)
      self.timerRunning = true
      self.timerBar:SetMinMaxValues(0, timerSeconds)
      self.timerBar:SetValue(timerSeconds)
      self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
      self.timerText:SetText(string.format("Time: %ds", timerSeconds))
      self.warningButton:Enable()
      if self.hintButton then
        local hint = q.hint or (q.hints and q.hints[1])
        if hint and hint ~= "" then self.hintButton:Enable() else self.hintButton:Disable() end
      end
      if self.skipButton then self.skipButton:Enable() end
    end
  else
    -- Legacy fallback
    if action.command == "announce_question" then
      self:AnnounceQuestion()
    elseif action.command == "announce_winner" then
      self:AnnounceWinner()
      self:UpdateSessionBoard()
    elseif action.command == "announce_no_winner" then
      self:AnnounceNoWinner()
    elseif action.command == "end_game" then
      self:EndGame()
    end
  end
  self:RefreshPrimaryButton()
end

function UI:SkipQuestion()
  if not TriviaClassic:IsGameActive() then
    return
  end
  if TriviaClassic:IsQuestionOpen() then
    if self.presenter then self.presenter:SkipQuestion() end
    self.frame.statusText:SetText("Question skipped. Click Next for the next question.")
    -- Reset local question number so the next announcement reuses the same slot number.
    local idx = select(1, TriviaClassic:GetCurrentQuestionIndex()) or 0
    if idx > 0 then
      self.questionNumber = idx - 1
    else
      self.questionNumber = 0
    end
    self.timerRunning = false
    self.timerBar:SetValue(0)
    self.timerText:SetText("Time: skipped")
    self.timerBar:SetStatusBarColor(0.95, 0.7, 0.2)
    self.warningButton:Disable()
    if self.hintButton then
      self.hintButton:Disable()
    end
    self:RefreshPrimaryButton()
    if self.skipButton then
      self.skipButton:Disable()
    end
    return
  end
end

function UI:SendWarning()
  if not TriviaClassic:IsQuestionOpen() then
    return
  end
  local remaining = self:GetCurrentTimerRemaining()
  if self.presenter then self.presenter:SendWarning(remaining) end
end

function UI:OnWinnerFound(result)
  if not result then
    return
  end
  if self.presenter and self.presenter.StatusWinnerPending then
    self.frame.statusText:SetText(self.presenter:StatusWinnerPending(result))
  else
    local winnerName = result.winner
    local elapsed = result.elapsed
    local teamName = result.teamName
    local teamMembers = result.teamMembers
    if teamName then
      local memberText = (teamMembers and #teamMembers > 0) and (" (" .. table.concat(teamMembers, ", ") .. ")") or ""
      self.frame.statusText:SetText(string.format("%s answered correctly in %.2fs. Click 'Announce Winner' to broadcast.", teamName .. memberText, elapsed or 0))
    else
      self.frame.statusText:SetText(string.format("%s answered correctly in %.2fs. Click 'Announce Winner' to broadcast.", winnerName, elapsed or 0))
    end
  end
  self:UpdateSessionBoard()
  -- Only stop timer/controls when the window is closed or a winner announcement is pending.
  if not TriviaClassic:IsQuestionOpen() or TriviaClassic:IsPendingWinner() then
    self.timerRunning = false
    self.warningButton:Disable()
    if self.hintButton then
      self.hintButton:Disable()
    end
    self:RefreshPrimaryButton()
    if self.skipButton then
      self.skipButton:Disable()
    end
  end
end

function UI:UpdateTimer(elapsed)
  if not self.timerRunning then
    return
  end
  local snap = self.timerService and self.timerService:Tick(elapsed) or { remaining = 0, expired = true, color = "red" }
  if snap.expired then
    self.timerRunning = false
    if self.presenter and self.presenter.MarkTimeout then
      self.presenter:MarkTimeout()
    else
      TriviaClassic:MarkTimeout()
    end
    self.timerBar:SetValue(0)
    self.timerText:SetText("Time: 0s")
    self.timerBar:SetStatusBarColor(0.7, 0.1, 0.1)
    self.warningButton:Disable()
    if self.hintButton then self.hintButton:Disable() end
    if self.skipButton then self.skipButton:Disable() end
    local action = (self.presenter and self.presenter:PrimaryAction()) or TriviaClassic:GetPrimaryAction()
    if self.presenter and self.presenter.StatusTimeExpired then
      self.frame.statusText:SetText(self.presenter:StatusTimeExpired(action and action.command, TriviaClassic:IsPendingWinner()))
    else
      if action and action.command == "start_steal" then
        self.frame.statusText:SetText("Time expired. Offer a steal to the next team.")
      elseif TriviaClassic:IsPendingWinner() then
        self.frame.statusText:SetText("Time expired. Announce results for this question.")
      else
        self.frame.statusText:SetText("Time expired. Click 'Announce No Winner' to continue.")
      end
    end
    self:RefreshPrimaryButton()
    return
  end
  self.timerBar:SetValue(snap.remaining)
  if snap.color == "red" then
    self.timerBar:SetStatusBarColor(0.9, 0.2, 0.2)
  elseif snap.color == "orange" then
    self.timerBar:SetStatusBarColor(0.95, 0.7, 0.2)
  else
    self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  end
  self.timerText:SetText(string.format("Time: %ds", math.ceil(snap.remaining)))
end

function UI:AnnounceHint()
  local q = TriviaClassic:GetCurrentQuestion()
  if not q then
    self.frame.statusText:SetText("No active question to hint.")
    return
  end
  local hint = q.hint or (q.hints and q.hints[1])
  if hint and hint ~= "" then
    if self.presenter then self.presenter:AnnounceHint() end
    self.frame.statusText:SetText("Hint announced.")
  else
    self.frame.statusText:SetText("No hint available for this question.")
  end
  if self.hintButton then
    self.hintButton:Disable()
  end
end
