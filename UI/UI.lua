local UI = {}
TriviaClassicUI = UI

local trim = TriviaClassic_UI_Trim


function UI:BuildUI()
  self:InitOptionsData()
  local channelLabels = self.channelLabels or {}
  if self.frame then
    local cfg = TriviaClassic:GetGameAxisConfig()
    self.participationKey = cfg.participation
    self.flowKey = (cfg.flow == "TURN_BASED_STEAL") and "TURN_BASED" or cfg.flow
    self.stealAllowed = (cfg.flow == "TURN_BASED_STEAL")
    self.scoringKey = cfg.scoring
    self.attemptKey = cfg.attempt or "MULTI"
    self:ApplyAxisConstraints()
    self:SyncAxisSelectors()
    self:SyncTimerInput()
    self:ResetTimerDisplay(self:GetTimerSeconds())
    self:RefreshSetList()
    self:UpdateSessionBoard()
    self:UpdateTeamUI()
    self:RefreshPrimaryButton()
    return
  end

  self.channelKey = TriviaClassic_GetDefaultChannel()
  local cfg = TriviaClassic:GetGameAxisConfig()
  self.participationKey = cfg.participation
  self.flowKey = (cfg.flow == "TURN_BASED_STEAL") and "TURN_BASED" or cfg.flow
  self.stealAllowed = (cfg.flow == "TURN_BASED_STEAL")
  self.scoringKey = cfg.scoring
  self.attemptKey = cfg.attempt or "MULTI"
  self.selectedWaiting = {}
  self.selectedMembers = {}

  local frame = TriviaClassic_UI_BuildLayout(self)
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
    self.setsPage:Hide()
    self.teamsPage:Hide()
    if which == "options" then
      self.optionsPage:Show()
      PanelTemplates_SetTab(self.frame, 2)
    elseif which == "sets" then
      self.setsPage:Show()
      PanelTemplates_SetTab(self.frame, 3)
    elseif which == "teams" then
      self.teamsPage:Show()
      PanelTemplates_SetTab(self.frame, 4)
    else
      self.gamePage:Show()
      PanelTemplates_SetTab(self.frame, 1)
    end
  end
  self.tabGame:SetScript("OnClick", function() showPage("game") end)
  self.tabOptions:SetScript("OnClick", function() showPage("options") end)
  self.tabSets:SetScript("OnClick", function() showPage("sets") end)
  self.tabTeams:SetScript("OnClick", function() showPage("teams") end)
  showPage("game")

  UIDropDownMenu_SetSelectedValue(self.dropDown, self.channelKey)
  UIDropDownMenu_SetText(self.dropDown, channelLabels[self.channelKey] or self.channelKey)
  UIDropDownMenu_Initialize(self.dropDown, function(_, _, _)
    for _, ch in ipairs(self.channels) do
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

  self:ApplyAxisConstraints()
  UIDropDownMenu_Initialize(self.participationDropDown, function()
    for _, entry in ipairs(self.participationTypes) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = entry.label
      info.value = entry.key
      info.func = function()
        UIDropDownMenu_SetSelectedValue(self.participationDropDown, entry.key)
        self:SetAxisSelection(entry.key, nil, nil, nil, nil)
      end
      info.checked = (self.participationKey == entry.key)
      UIDropDownMenu_AddButton(info)
    end
  end)

  UIDropDownMenu_Initialize(self.flowDropDown, function()
    for _, entry in ipairs(self.flowOptions) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = entry.label
      info.value = entry.key
      info.func = function()
        UIDropDownMenu_SetSelectedValue(self.flowDropDown, entry.key)
        self:SetAxisSelection(nil, entry.key, nil, nil, nil)
      end
      info.checked = (self.flowKey == entry.key)
      UIDropDownMenu_AddButton(info)
    end
  end)

  UIDropDownMenu_Initialize(self.scoringDropDown, function()
    for _, entry in ipairs(self.scoringTypes) do
      if self.flowKey ~= "TURN_BASED" or entry.key == "FASTEST" then
        local info = UIDropDownMenu_CreateInfo()
        info.text = entry.label
        info.value = entry.key
        info.func = function()
          UIDropDownMenu_SetSelectedValue(self.scoringDropDown, entry.key)
          self:SetAxisSelection(nil, nil, entry.key, nil, nil)
        end
        info.checked = (self.scoringKey == entry.key)
        UIDropDownMenu_AddButton(info)
      end
    end
  end)

  UIDropDownMenu_Initialize(self.attemptDropDown, function()
    for _, entry in ipairs(self.attemptTypes) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = entry.label
      info.value = entry.key
      info.func = function()
        UIDropDownMenu_SetSelectedValue(self.attemptDropDown, entry.key)
        self:SetAxisSelection(nil, nil, nil, entry.key, nil)
      end
      info.checked = (self.attemptKey == entry.key)
      UIDropDownMenu_AddButton(info)
    end
  end)

  if self.stealCheck then
    self.stealCheck:SetScript("OnClick", function(btn)
      self:SetAxisSelection(nil, nil, nil, nil, btn:GetChecked())
    end)
  end

  self:SyncAxisSelectors()

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
          self.teamStatus:SetText("|cff20ff20Teams announced to chat.|r")
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
        DEFAULT_CHAT_FRAME:AddMessage(string.format("|cffffff00[Trivia]|r %s - %d pts (%d correct)", entry.name, entry.points or 0, entry.correct or 0))
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

