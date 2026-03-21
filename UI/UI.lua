local UI = {}
TriviaClassicUI = UI

local CONST = TriviaClassic_UI_GetConstants()
local trim = TriviaClassic_UI_Trim
local channels = TriviaClassic_GetChannels()
local channelMap = TriviaClassic_GetChannelMap()
local channelLabels = {}
for _, ch in ipairs(channels) do
  channelLabels[ch.key] = ch.label
end
local gameModes = TriviaClassic_GetGameModes()
local modeLabels = {}
for _, mode in ipairs(gameModes) do
  modeLabels[mode.key] = mode.label
end

local function normalizeCategoryName(name)
  return trim(name or ""):lower()
end

function UI:GetSelectableSets()
  local mode = self.gameModeKey or TriviaClassic:GetGameMode()
  if TriviaClassic.GetSetsForMode then
    return TriviaClassic:GetSetsForMode(mode) or {}
  end
  return TriviaClassic:GetAllSets() or {}
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

function UI:SetChannel(key)
  key = key or TriviaClassic_GetDefaultChannel()
  self.channelKey = key

  if key == "CUSTOM" then
    if self.customLabel then self.customLabel:Show() end
    if self.customInput then self.customInput:Show() end
    local name = trim(self.customInput and self.customInput:GetText() or "")
    self:SetCustomChannel(name ~= "" and name or nil)
  else
    if self.customLabel then self.customLabel:Hide() end
    if self.customInput then self.customInput:Hide() end
    TriviaClassic:SetChannel(key)
    if self.channelStatus then
      self.channelStatus:SetText("Channel: " .. (channelLabels[key] or key))
    end
  end
end

function UI:SetCustomChannel(name)
  name = trim(name or "")
  self.channelKey = "CUSTOM"
  if self.dropDown then
    UIDropDownMenu_SetSelectedValue(self.dropDown, "CUSTOM")
  end
  if name == "" then
    TriviaClassic:SetChannel("CUSTOM", nil)
    if self.channelStatus then
      self.channelStatus:SetText("Channel: Custom (enter a name)")
    end
    return
  end
  if self.customInput and self.customInput:GetText() ~= name then
    self.customInput:SetText(name)
  end
  TriviaClassic:SetChannel("CUSTOM", name)
  if self.channelStatus then
    self.channelStatus:SetText("Channel: Custom - " .. name)
  end
end

function UI:SetGameMode(key)
  local modeKey = modeLabels[key] and key or TriviaClassic_GetDefaultMode()
  self.gameModeKey = modeKey
  if self.modeDropDown then
    UIDropDownMenu_SetSelectedValue(self.modeDropDown, modeKey)
    UIDropDownMenu_SetText(self.modeDropDown, modeLabels[modeKey] or modeKey)
  end
  TriviaClassic:SetGameMode(modeKey)
  self:RefreshSetList()
end

function UI:GetTimerSeconds()
  return TriviaClassic:GetTimer()
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

function UI:GetStealTimerSeconds()
  return TriviaClassic:GetStealTimer()
end

function UI:SetStealTimerSeconds(seconds)
  TriviaClassic:SetStealTimer(seconds)
  self:SyncTimerInput()
end

function UI:SetTimerSeconds(seconds)
  TriviaClassic:SetTimer(seconds)
  self:SyncTimerInput()
end

function UI:SyncTimerInput()
  if self.timerInput then
    self.timerInput:SetText(tostring(self:GetTimerSeconds()))
  end
  if self.stealTimerInput then
    self.stealTimerInput:SetText(tostring(self:GetStealTimerSeconds()))
  end
end

function UI:ApplyTimerInput()
  if not self.timerInput then
    return
  end
  local value = tonumber(self.timerInput:GetText() or "")
  local minTimer, maxTimer = TriviaClassic:GetTimerBounds()
  if not value then
    value = self:GetTimerSeconds()
  end
  if value < minTimer then value = minTimer end
  if value > maxTimer then value = maxTimer end
  self:SetTimerSeconds(value)
end

function UI:ResetTimerDisplay(seconds)
  local secs = tonumber(seconds) or self:GetTimerSeconds()
  self.timerRemaining = secs
  self.timerRunning = false
  if self.timerUI then
    self.timerUI:Reset(secs)
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

function UI:RefreshSetList()
  if not self.setContainer then
    return
  end

  -- Reset scroll to top if present
  if self.setScroll then
    local sb = self.setScroll.ScrollBar or _G[(self.setScroll:GetName() or "") .. "ScrollBar"]
    if sb and sb.GetMinMaxValues then
      local min = select(1, sb:GetMinMaxValues())
      if min then sb:SetValue(min) end
    end
    if self.setScroll.SetVerticalScroll then
      self.setScroll:SetVerticalScroll(0)
    end
  end

  for _, item in ipairs(self.setItems or {}) do
    item:Hide()
  end

  self.setItems = {}
  -- Initialize per-set selection storage if missing
  self.selectedBySet = self.selectedBySet or {}
  self.selectedSetIds = self.selectedSetIds or {}
  local sets = self:GetSelectableSets()
  local yOffset = 0

  for _, set in ipairs(sets) do
    local setId = set.id
    local setTitle = set.title or "Set"
    if self.selectedSetIds[setId] == nil then
      self.selectedSetIds[setId] = true
    end
    local setCheck = TriviaClassic_UI_CreateCheckbox(self.setContainer, setTitle, -yOffset, function(checked)
      self.selectedSetIds[setId] = checked and true or false
      self:UpdateQuestionCount()
    end)
    setCheck:SetChecked(self.selectedSetIds[setId] and true or false)
    table.insert(self.setItems, setCheck)
    yOffset = yOffset + 22

    if set.categories then
      -- Ensure a bucket exists for this set
      local bucket = self.selectedBySet[setId]
      if not bucket then
        bucket = { keys = {}, names = {} }
        self.selectedBySet[setId] = bucket
      end
      for _, cat in ipairs(set.categories) do
        -- Important: capture the category value per-iteration to avoid Lua closure rebinding issues
        local catName = cat
        local catKey = normalizeCategoryName(catName)
        local check = TriviaClassic_UI_CreateCheckbox(self.setContainer, "  - " .. catName, -yOffset, function(checked)
          -- Track per-set selections
          if checked then
            bucket.names[catName] = true
            bucket.keys[catKey] = true
          else
            bucket.names[catName] = nil
            bucket.keys[catKey] = nil
          end
          self:UpdateQuestionCount()
        end)
        -- Checked state from per-set bucket
        check:SetChecked(bucket.names[catName] or false)
        table.insert(self.setItems, check)
        yOffset = yOffset + 20
      end
    end
  end

  -- Update content height so the scrollbar knows the scrollable range
  if self.setContainer and self.setContainer.SetHeight then
    self.setContainer:SetHeight(math.max(1, yOffset))
  end

  self:UpdateQuestionCount()
end

function UI:CategorySelected(category, setId)
  -- Default-deny: if nothing selected for this set, do not include any questions
  local bucket = self.selectedBySet and self.selectedBySet[setId]
  if not bucket or (not bucket.keys or next(bucket.keys) == nil) then
    return false
  end
  if not category then
    return false
  end
  local key = normalizeCategoryName(category)
  return (bucket.keys and bucket.keys[key]) or (bucket.names and (bucket.names[category] or bucket.names[category:lower()]))
end

function UI:UpdateQuestionCount()
  local mode = self.gameModeKey or TriviaClassic:GetGameMode()
  local total = 0
  for _, set in ipairs(self:GetSelectableSets()) do
    local selected = self.selectedSetIds == nil or self.selectedSetIds[set.id] ~= false
    if selected then
      if mode == "CONNECTIONS" then
        if set.puzzles then
          total = total + #set.puzzles
        end
      elseif set.questions then
        for _, q in ipairs(set.questions) do
          if self:CategorySelected(q.categoryKey or q.category, set.id) then
            total = total + 1
          end
        end
      end
    end
  end
  if self.setCountLabel then
    if mode == "CONNECTIONS" then
      self.setCountLabel:SetText(string.format("Puzzles selected: %d", total))
    else
      self.setCountLabel:SetText(string.format("Questions selected: %d", total))
    end
  end
end

--- Sets up the UI for a connections-mode question.
function UI:SetupConnectionsQuestion(index, total)
  self.questionLabel:SetText(string.format("Puzzle %d/%d: Connections", index, total))
  self.categoryLabel:SetText("Find 4 groups of 4 words. Click Show Words anytime.")
  self.frame.statusText:SetText("Puzzle announced. Listening for group guesses...")
  self.timerRunning = false
  self.timerService = nil
  self.timerUI:ResetNoTimer()
  self.warningButton:Disable()
  if self.hintButton then
    self.hintButton:Disable()
  end
end

--- Sets up the UI for a standard (non-connections) question with timer.
function UI:SetupStandardQuestion(q, index, total, timerSeconds, activeTeamName)
  self.questionLabel:SetText(string.format("Q%d/%d: %s", index, total, q.question))
  self.categoryLabel:SetText(string.format("Category: %s  |  Points: %s", q.category or "General", tostring(q.points or 1)))
  local modeLabel = TriviaClassic:GetGameModeLabel()
  if self.presenter and self.presenter.StatusQuestionAnnounced then
    self.frame.statusText:SetText(self.presenter:StatusQuestionAnnounced(activeTeamName, modeLabel, timerSeconds))
  else
    if activeTeamName then
      self.frame.statusText:SetText(string.format("Question announced. Active team: %s. Listening for answers... (%s)", activeTeamName, modeLabel))
      self.timerUI:SetText(string.format("Time: %ds (Team: %s)", timerSeconds, activeTeamName))
    else
      self.frame.statusText:SetText(string.format("Question announced. Listening for answers... (%s)", modeLabel))
    end
  end
  self.timerService = TriviaClassic_CreateTimer(timerSeconds)
  self.timerRunning = true
  self.timerUI:Reset(timerSeconds)
  self.warningButton:Enable()
  if self.hintButton then
    local hint = q.hint or (q.hints and q.hints[1])
    if hint and hint ~= "" then
      self.hintButton:Enable()
    else
      self.hintButton:Disable()
    end
  end
end

function UI:StartGame()
  local desiredCount = tonumber(self.questionCountInput and self.questionCountInput:GetText() or "")
  self:ApplyTimerInput()
  -- Persist selected mode before starting
  local modeToStart = self.gameModeKey or TriviaClassic:GetGameMode()
  self:SetGameMode(modeToStart)
  -- Build per-set categories map for all sets (default-deny when empty)
  local categoriesBySet = {}
  local selectedIds = {}
  for _, set in ipairs(self:GetSelectableSets()) do
    local selected = self.selectedSetIds == nil or self.selectedSetIds[set.id] ~= false
    if selected then
      table.insert(selectedIds, set.id)
      categoriesBySet[set.id] = {}
      local bucket = self.selectedBySet and self.selectedBySet[set.id]
      if bucket and bucket.keys then
        for key, checked in pairs(bucket.keys) do
          if checked then categoriesBySet[set.id][key] = true end
        end
      end
    end
  end
  local meta = self.presenter and self.presenter:StartGame(desiredCount, categoriesBySet, selectedIds, modeToStart) or TriviaClassic:StartGame(selectedIds, desiredCount, categoriesBySet, modeToStart)
  if not meta then
    print(CONST.colorError .. "TriviaClassic: No questions available." .. CONST.colorClose)
    return
  end

  self:RefreshPrimaryButton()
  if self.skipButton then
    self.skipButton:Enable()
  end
  self.warningButton:Disable()
  self.frame.statusText:SetText(string.format("Game started (%s). %d questions ready.", meta.modeLabel or TriviaClassic:GetGameModeLabel(), meta.total))
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
  local mode = TriviaClassic:GetGameMode()
  local activeTeamName = select(1, TriviaClassic:GetActiveTeam())
  if not q then
    self.frame.statusText:SetText("No more questions. End the game.")
    self:RefreshPrimaryButton()
    return
  end

  self.questionNumber = index
  self.currentQuestion = q

  if mode == "CONNECTIONS" then
    self:SetupConnectionsQuestion(index, total)
    if self.skipButton then
      self.skipButton:Enable()
    end
    self:RefreshPrimaryButton()
    return
  end

  self:SetupStandardQuestion(q, index, total, self:GetTimerSeconds(), activeTeamName)
  if self.skipButton then
    self.skipButton:Enable()
  end
  -- Chat already sent by presenter
  self:RefreshPrimaryButton()
end

function UI:StartSteal()
  local result = self.presenter and self.presenter:StartSteal() or TriviaClassic:PerformPrimaryAction("start_steal")
  local teamName = result and result.teamName
  local q = result and result.question or TriviaClassic:GetCurrentQuestion()
  local activeLabel = teamName or "Next team"
  if not q then
    self.frame.statusText:SetText("No question available to steal.")
    self:RefreshPrimaryButton()
    return
  end
  self.currentQuestion = q
  if self.presenter and self.presenter.StatusStealListening then
    self.frame.statusText:SetText(self.presenter:StatusStealListening(activeLabel))
  else
    self.frame.statusText:SetText(string.format("%s can steal. Listening for answers...", activeLabel))
  end
  local timerSeconds = (self.presenter and self.presenter:GetStealTimerSeconds()) or self:GetTimerSeconds()
  self.timerRemaining = timerSeconds
  self.timerRunning = true
  self.timerUI:Reset(timerSeconds)
  self.timerUI:SetText(string.format("Time: %ds (Steal)", timerSeconds))
  self.warningButton:Enable()
  if self.hintButton then
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

-- New: UI reaction when a steal phase starts (from presenter via event)
-- removed: mode-specific steal UI handler; handled via generic question announce

function UI:AnnounceWinner()
  if not TriviaClassic:IsPendingWinner() then
    return
  end
  local mode = TriviaClassic:GetGameMode()
  if mode == "ALL_CORRECT" then
    self.timerRunning = false
    local winners = TriviaClassic:GetPendingWinners()
    local q = TriviaClassic:GetCurrentQuestion()
    if winners and #winners > 0 then
      if self.presenter then self.presenter:AnnounceWinner() end
      self.frame.statusText:SetText("Results announced. Click Next for the next question.")
    else
      self:AnnounceNoWinner()
      return
    end
    local result = TriviaClassic:PerformPrimaryAction("announce_winner")
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
    if res and res.command == "show_words" then
      self.frame.statusText:SetText("Remaining words shown in chat.")
    elseif res and res.question then
      local q = res.question
      local index = res.index or 0
      local total = res.total or 0
      local mode = TriviaClassic:GetGameMode()
      self.questionNumber = index
      self.currentQuestion = q

      if mode == "CONNECTIONS" then
        self:SetupConnectionsQuestion(index, total)
      else
        local timerSeconds = res.timerSeconds or self:GetTimerSeconds()
        self:SetupStandardQuestion(q, index, total, timerSeconds, res.activeTeamName)
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
    self.timerUI:SetSkipped()
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
    TriviaClassic:MarkTimeout()
    self.timerUI:SetExpired()
    self.warningButton:Disable()
    if self.hintButton then self.hintButton:Disable() end
    if self.skipButton then self.skipButton:Disable() end
    local action = TriviaClassic:GetPrimaryAction()
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
  self.timerUI:Update(snap)
end

function UI:BuildUI()
  if self.frame then
    self.gameModeKey = TriviaClassic:GetGameMode()
    if self.modeDropDown then
      UIDropDownMenu_SetSelectedValue(self.modeDropDown, self.gameModeKey)
      UIDropDownMenu_SetText(self.modeDropDown, modeLabels[self.gameModeKey] or self.gameModeKey)
    end
    self:SyncTimerInput()
    self:ResetTimerDisplay(self:GetTimerSeconds())
    self:RefreshSetList()
    self:UpdateSessionBoard()
    self:UpdateTeamUI()
    self:RefreshPrimaryButton()
    return
  end

  self.channelKey = TriviaClassic_GetDefaultChannel()
  self.gameModeKey = TriviaClassic:GetGameMode()
  self.selectedWaiting = {}
  self.selectedMembers = {}

  local frame = TriviaClassic_UI_BuildLayout(self)
  self.timerUI = TriviaClassic_UI_CreateTimerUI(self.timerBar, self.timerText)
  self:SetChannel(self.channelKey)
  self.presenter = TriviaClassic_UI_CreatePresenter(TriviaClassic)

  -- Subscribe to core events to keep UI in sync (no chat sends here)
  if TriviaClassic_On then
    self._unsub = self._unsub or {}
    table.insert(self._unsub, TriviaClassic_On("teams_updated", function()
      if self and self.UpdateTeamUI then self:UpdateTeamUI() end
    end))
    table.insert(self._unsub, TriviaClassic_On("pending_steal", function(evt)
      if self and self.OnPendingSteal then self:OnPendingSteal(evt) end
    end))
    table.insert(self._unsub, TriviaClassic_On("winner_found", function(evt)
      if self and self.OnWinnerFound then self:OnWinnerFound(evt) end
    end))
  end

  -- Tab switching
  local function showPage(which)
    self.optionsPage:Hide()
    self.gamePage:Hide()
    self.teamsPage:Hide()
    if which == "options" then
      self.optionsPage:Show()
      PanelTemplates_SetTab(self.frame, 2)
    elseif which == "teams" then
      self.teamsPage:Show()
      PanelTemplates_SetTab(self.frame, 3)
    else
      self.gamePage:Show()
      PanelTemplates_SetTab(self.frame, 1)
    end
  end
  self.tabGame:SetScript("OnClick", function() showPage("game") end)
  self.tabOptions:SetScript("OnClick", function() showPage("options") end)
  self.tabTeams:SetScript("OnClick", function() showPage("teams") end)
  showPage("game")

  UIDropDownMenu_SetSelectedValue(self.dropDown, self.channelKey)
  UIDropDownMenu_SetText(self.dropDown, channelLabels[self.channelKey] or self.channelKey)
  UIDropDownMenu_Initialize(self.dropDown, function(_, _, _)
    for _, ch in ipairs(channels) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = ch.label
      info.value = ch.key
      info.func = function()
        UIDropDownMenu_SetSelectedValue(self.dropDown, ch.key)
        self:SetChannel(ch.key)
      end
      info.checked = (self.channelKey == ch.key)
      UIDropDownMenu_AddButton(info)
    end
  end)

  UIDropDownMenu_SetSelectedValue(self.modeDropDown, self.gameModeKey)
  UIDropDownMenu_SetText(self.modeDropDown, modeLabels[self.gameModeKey] or self.gameModeKey)
  UIDropDownMenu_Initialize(self.modeDropDown, function(_, _, _)
    for _, mode in ipairs(gameModes) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = mode.label
      info.value = mode.key
      info.func = function()
        UIDropDownMenu_SetSelectedValue(self.modeDropDown, mode.key)
        self:SetGameMode(mode.key)
      end
      info.checked = (self.gameModeKey == mode.key)
      UIDropDownMenu_AddButton(info)
    end
  end)

  -- Teams tab wiring
  self:UpdateTeamUI()
  self.addTeamBtn:SetScript("OnClick", function()
    self:AddTeam()
  end)
  self.removeTeamBtn:SetScript("OnClick", function()
    self:RemoveTeam()
  end)
  self.moveRightBtn:SetScript("OnClick", function()
    self:MoveWaitingToTeam()
  end)
  self.moveLeftBtn:SetScript("OnClick", function()
    self:RemoveMembersToWaiting()
  end)
  if self.announceTeamsBtn then
    self.announceTeamsBtn:SetScript("OnClick", function()
      if self.presenter and self.presenter.AnnounceTeams then
        self.presenter:AnnounceTeams()
        if self.teamStatus then
          self.teamStatus:SetText(CONST.colorSuccess .. "Teams announced to chat." .. CONST.colorClose)
        end
      end
    end)
  end
  self.teamNameInput:SetScript("OnEnterPressed", function(box)
    self:AddTeam()
    box:ClearFocus()
  end)

  self.customInput:SetScript("OnEnterPressed", function(box)
    self:SetCustomChannel(box:GetText())
    box:ClearFocus()
  end)
  self.customInput:SetScript("OnEditFocusLost", function(box)
    self:SetCustomChannel(box:GetText())
  end)
  self.timerInput:SetScript("OnEnterPressed", function(box)
    self:ApplyTimerInput()
    box:ClearFocus()
  end)
  self.timerInput:SetScript("OnEditFocusLost", function()
    self:ApplyTimerInput()
  end)
  if self.stealTimerInput then
    self.stealTimerInput:SetScript("OnEnterPressed", function(box)
      local value = tonumber(box:GetText() or "")
      if value then
        self:SetStealTimerSeconds(value)
      end
      box:ClearFocus()
    end)
    self.stealTimerInput:SetScript("OnEditFocusLost", function(box)
      local value = tonumber(box:GetText() or "")
      if value then
        self:SetStealTimerSeconds(value)
      end
    end)
  end
  self:SyncTimerInput()
  self:ResetTimerDisplay(self:GetTimerSeconds())

  self.startButton:SetScript("OnClick", function()
    self:StartGame()
  end)
  self.nextButton:SetScript("OnClick", function()
    self:OnNextPressed()
  end)
  self.skipButton:SetScript("OnClick", function()
    self:SkipQuestion()
  end)
  self.warningButton:SetScript("OnClick", function()
    self:SendWarning()
  end)
  if self.hintButton then
    self.hintButton:SetScript("OnClick", function()
      self:AnnounceHint()
    end)
  end
  if self.rerollTeamButton then
    self.rerollTeamButton:SetScript("OnClick", function()
      self:RerollTeamParticipant()
    end)
  end
  self.sessionBtn:SetScript("OnClick", function()
    self:ShowSessionScores()
  end)
  self.allTimeBtn:SetScript("OnClick", function()
    self:ShowAllTimeScores()
  end)
  self.endButton:SetScript("OnClick", function()
    self:EndGame()
  end)

  local ticker = CreateFrame("Frame", nil, frame)
  ticker:SetScript("OnUpdate", function(_, elapsed)
    self:UpdateTimer(elapsed)
  end)
  self.ticker = ticker

  self:RefreshSetList()
  self:UpdateSessionBoard()
  self:RefreshPrimaryButton()

  frame:Hide()
  SLASH_TRIVIACLASSIC1 = "/trivia"
  SlashCmdList["TRIVIACLASSIC"] = function(msg)
    local command = trim(msg)
    if command == "scores" then
      for _, entry in ipairs(TriviaClassic:GetLeaderboard(10)) do
        DEFAULT_CHAT_FRAME:AddMessage(string.format(CONST.colorHighlight .. "[Trivia]" .. CONST.colorClose .. " %s - %d pts (%d correct)", entry.name, entry.points or 0, entry.correct or 0))
      end
      return
    end
    if command == "teams" then
      if self.presenter and self.presenter.AnnounceTeams then
        self.presenter:AnnounceTeams()
      end
      return
    end
    if self.frame:IsShown() then
      self.frame:Hide()
    else
      self.frame:Show()
    end
  end
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
