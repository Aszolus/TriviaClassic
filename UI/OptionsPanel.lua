local UI = TriviaClassicUI
if not UI then
  UI = {}
  TriviaClassicUI = UI
end

local trim = TriviaClassic_UI_Trim

function UI:InitOptionsData()
  if self.optionsDataInitialized then
    return
  end
  self.channels = TriviaClassic_GetChannels()
  self.channelLabels = {}
  for _, ch in ipairs(self.channels) do
    self.channelLabels[ch.key] = ch.label
  end
  self.participationTypes = TriviaClassic_GetParticipationTypes()
  self.flowTypes = TriviaClassic_GetFlowTypes()
  self.scoringTypes = TriviaClassic_GetScoringTypes()
  self.attemptTypes = TriviaClassic_GetAttemptTypes()
  self.participationLabels = {}
  for _, entry in ipairs(self.participationTypes) do
    self.participationLabels[entry.key] = entry.label
  end
  self.flowLabels = {}
  for _, entry in ipairs(self.flowTypes) do
    self.flowLabels[entry.key] = entry.label
  end
  self.scoringLabels = {}
  for _, entry in ipairs(self.scoringTypes) do
    self.scoringLabels[entry.key] = entry.label
  end
  self.attemptLabels = {}
  for _, entry in ipairs(self.attemptTypes) do
    self.attemptLabels[entry.key] = entry.label
  end
  self.flowOptions = {}
  for _, entry in ipairs(self.flowTypes) do
    if entry.key ~= "TURN_BASED_STEAL" then
      table.insert(self.flowOptions, entry)
    end
  end
  self.optionsDataInitialized = true
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
    if self.presenter and self.presenter.SetChannel then
      self.presenter:SetChannel(key)
    else
      TriviaClassic:SetChannel(key)
    end
    if self.channelStatus then
      self.channelStatus:SetText("Channel: " .. (self.channelLabels and self.channelLabels[key] or key))
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
    if self.presenter and self.presenter.SetChannel then
      self.presenter:SetChannel("CUSTOM", nil)
    else
      TriviaClassic:SetChannel("CUSTOM", nil)
    end
    if self.channelStatus then
      self.channelStatus:SetText("Channel: Custom (enter a name)")
    end
    return
  end
  if self.customInput and self.customInput:GetText() ~= name then
    self.customInput:SetText(name)
  end
  if self.presenter and self.presenter.SetChannel then
    self.presenter:SetChannel("CUSTOM", name)
  else
    TriviaClassic:SetChannel("CUSTOM", name)
  end
  if self.channelStatus then
    self.channelStatus:SetText("Channel: Custom - " .. name)
  end
end

function UI:ApplyAxisConstraints()
  if not self.participationLabels[self.participationKey] then
    self.participationKey = "INDIVIDUAL"
  end
  if not self.flowLabels[self.flowKey] then
    self.flowKey = "OPEN"
  end
  if not self.scoringLabels[self.scoringKey] then
    self.scoringKey = "FASTEST"
  end
  if not self.attemptLabels[self.attemptKey] then
    self.attemptKey = "MULTI"
  end
  if self.flowKey ~= "TURN_BASED" then
    self.stealAllowed = false
  end
  if self.participationKey == "INDIVIDUAL" and self.flowKey == "TURN_BASED" then
    self.flowKey = "OPEN"
    self.stealAllowed = false
  end
  if self.flowKey == "TURN_BASED" then
    if self.scoringKey ~= "FASTEST" then
      self.scoringKey = "FASTEST"
    end
  end
end

function UI:ComputeAxisFlow()
  if self.flowKey == "TURN_BASED" and self.stealAllowed then
    return "TURN_BASED_STEAL"
  end
  return self.flowKey
end

function UI:SyncAxisSelectors()
  if self.participationDropDown then
    UIDropDownMenu_SetSelectedValue(self.participationDropDown, self.participationKey)
    UIDropDownMenu_SetText(self.participationDropDown, self.participationLabels[self.participationKey] or self.participationKey)
  end
  if self.flowDropDown then
    UIDropDownMenu_SetSelectedValue(self.flowDropDown, self.flowKey)
    UIDropDownMenu_SetText(self.flowDropDown, self.flowLabels[self.flowKey] or self.flowKey)
  end
  if self.scoringDropDown then
    UIDropDownMenu_SetSelectedValue(self.scoringDropDown, self.scoringKey)
    UIDropDownMenu_SetText(self.scoringDropDown, self.scoringLabels[self.scoringKey] or self.scoringKey)
  end
  if self.attemptDropDown then
    UIDropDownMenu_SetSelectedValue(self.attemptDropDown, self.attemptKey)
    UIDropDownMenu_SetText(self.attemptDropDown, self.attemptLabels[self.attemptKey] or self.attemptKey)
  end
  if self.stealCheck then
    if self.flowKey == "TURN_BASED" then
      self.stealCheck:Show()
      self.stealCheck:SetChecked(self.stealAllowed and true or false)
      self.stealCheck:Enable()
    else
      self.stealCheck:SetChecked(false)
      self.stealCheck:Disable()
      self.stealCheck:Hide()
    end
  end
end

function UI:SetAxisSelection(participationKey, flowKey, scoringKey, attemptKey, stealAllowed)
  if participationKey then
    self.participationKey = participationKey
  end
  if flowKey then
    self.flowKey = flowKey
  end
  if scoringKey then
    self.scoringKey = scoringKey
  end
  if attemptKey then
    self.attemptKey = attemptKey
  end
  if stealAllowed ~= nil then
    self.stealAllowed = stealAllowed and true or false
  end
  self:ApplyAxisConstraints()
  self:SyncAxisSelectors()
  local config = {
    participation = self.participationKey,
    flow = self:ComputeAxisFlow(),
    scoring = self.scoringKey,
    attempt = self.attemptKey,
  }
  if self.presenter and self.presenter.SetGameAxisConfig then
    self.presenter:SetGameAxisConfig(config)
  else
    TriviaClassic:SetGameAxisConfig(config)
  end
  self:UpdateRerollControls()
end

function UI:GetTimerSeconds()
  if self.presenter and self.presenter.GetTimer then
    return self.presenter:GetTimer()
  end
  return TriviaClassic:GetTimer()
end

function UI:GetStealTimerSeconds()
  if self.presenter and self.presenter.GetStealTimer then
    return self.presenter:GetStealTimer()
  end
  return TriviaClassic:GetStealTimer()
end

function UI:SetStealTimerSeconds(seconds)
  if self.presenter and self.presenter.SetStealTimer then
    self.presenter:SetStealTimer(seconds)
  else
    TriviaClassic:SetStealTimer(seconds)
  end
  self:SyncTimerInput()
end

function UI:SetTimerSeconds(seconds)
  if self.presenter and self.presenter.SetTimer then
    self.presenter:SetTimer(seconds)
  else
    TriviaClassic:SetTimer(seconds)
  end
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
