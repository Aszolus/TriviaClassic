local C = TriviaClassic_UI_GetConstants()

local Button = TriviaClassic_UI_CreateButton
local Checkbox = TriviaClassic_UI_CreateCheckbox
local initialTimer = (TriviaClassic and TriviaClassic.GetTimer and TriviaClassic:GetTimer()) or TriviaClassic.DEFAULT_TIMER

function TriviaClassic_UI_BuildLayout(ui)
  local frame = CreateFrame("Frame", "TriviaClassicFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(C.frameWidth, C.frameHeight)
  frame:SetPoint("CENTER")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame.TitleText:SetText("TriviaClassic - Host Panel")
  ui.frame = frame

  -- Reduce top padding so the category list sits closer to the tabs (less empty space)
  local originX, originY = C.padding, -44

  -- Tabs (Blizzard-style)
  local tabGame = CreateFrame("Button", frame:GetName() .. "Tab1", frame, "CharacterFrameTabButtonTemplate")
  tabGame:SetID(1)
  tabGame:SetText("Game")
  PanelTemplates_TabResize(tabGame, 0)
  tabGame:SetPoint("TOPLEFT", frame, "TOPLEFT", C.spacingLG, -28)
  ui.tabGame = tabGame

  local tabOptions = CreateFrame("Button", frame:GetName() .. "Tab2", frame, "CharacterFrameTabButtonTemplate")
  tabOptions:SetID(2)
  tabOptions:SetText("Options")
  PanelTemplates_TabResize(tabOptions, 0)
  tabOptions:SetPoint("LEFT", tabGame, "RIGHT", -14, 0)
  ui.tabOptions = tabOptions

  local tabTeams = CreateFrame("Button", frame:GetName() .. "Tab3", frame, "CharacterFrameTabButtonTemplate")
  tabTeams:SetID(3)
  tabTeams:SetText("Teams")
  PanelTemplates_TabResize(tabTeams, 0)
  tabTeams:SetPoint("LEFT", tabOptions, "RIGHT", -14, 0)
  ui.tabTeams = tabTeams

  frame.numTabs = 3
  PanelTemplates_SetNumTabs(frame, 3)
  PanelTemplates_SetTab(frame, 1)

  -- Pages
  local optionsPage = CreateFrame("Frame", nil, frame)
  optionsPage:SetAllPoints(frame.InsetBg or frame)
  ui.optionsPage = optionsPage

  local gamePage = CreateFrame("Frame", nil, frame)
  gamePage:SetAllPoints(frame.InsetBg or frame)
  ui.gamePage = gamePage
  gamePage:SetPoint("TOPLEFT", frame.InsetBg or frame, "TOPLEFT")

  local teamsPage = CreateFrame("Frame", nil, frame)
  teamsPage:SetAllPoints(frame.InsetBg or frame)
  ui.teamsPage = teamsPage

  -- Options page
  local setLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  setLabel:SetPoint("TOPLEFT", originX, originY)
  setLabel:SetText("Question Sets:")

  local setSelectAllBtn = Button(optionsPage, "Select All", C.btnWidthMD, C.btnHeightSM)
  setSelectAllBtn:SetPoint("LEFT", setLabel, "RIGHT", C.spacingMD, 0)
  ui.setSelectAllBtn = setSelectAllBtn

  local setClearBtn = Button(optionsPage, "Clear All", C.btnWidthMD, C.btnHeightSM)
  setClearBtn:SetPoint("LEFT", setSelectAllBtn, "RIGHT", C.spacingSM, 0)
  ui.setClearBtn = setClearBtn

  local setScroll = CreateFrame("ScrollFrame", "TriviaClassicSetScrollFrame", optionsPage, "UIPanelScrollFrameTemplate")
  setScroll:SetPoint("TOPLEFT", setLabel, "BOTTOMLEFT", 0, -C.spacingSM)
  setScroll:SetSize(C.leftWidth, C.setHeight)
  if setScroll.EnableMouseWheel then
    setScroll:EnableMouseWheel(true)
    local scrollStep = 20
    setScroll:SetScript("OnMouseWheel", function(self, delta)
      local sb = self.ScrollBar or _G[self:GetName() .. "ScrollBar"]
      if not sb then return end
      local newVal = (sb:GetValue() or 0) - (delta * scrollStep)
      local min, max = sb:GetMinMaxValues()
      if newVal < min then newVal = min end
      if newVal > max then newVal = max end
      sb:SetValue(newVal)
    end)
  end
  ui.setScroll = setScroll

  local setContent = CreateFrame("Frame", nil, setScroll)
  setContent:SetSize(C.leftWidth - 24, 1)
  if setContent.SetPoint then
    setContent:SetPoint("TOPLEFT", setScroll, "TOPLEFT", 0, 0)
  end
  setScroll:SetScrollChild(setContent)
  ui.setContainer = setContent

  local detailTitle = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  detailTitle:SetPoint("TOPLEFT", setScroll, "TOPRIGHT", C.controlGap + C.spacingMD, 0)
  detailTitle:SetWidth(C.rightWidth)
  detailTitle:SetJustifyH("LEFT")
  detailTitle:SetText("Set Details")
  ui.setDetailTitle = detailTitle

  local detailName = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  detailName:SetPoint("TOPLEFT", detailTitle, "BOTTOMLEFT", 0, -C.spacingSM)
  detailName:SetWidth(C.rightWidth)
  detailName:SetJustifyH("LEFT")
  detailName:SetJustifyV("TOP")
  detailName:SetText("")
  ui.setDetailName = detailName

  local detailBody = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  detailBody:SetPoint("TOPLEFT", detailName, "BOTTOMLEFT", 0, -C.spacingSM)
  detailBody:SetWidth(C.rightWidth)
  detailBody:SetJustifyH("LEFT")
  detailBody:SetJustifyV("TOP")
  detailBody:SetText("")
  ui.setDetailBody = detailBody

  local detailCategoryLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  detailCategoryLabel:SetPoint("TOPLEFT", detailBody, "BOTTOMLEFT", 0, -C.spacingMD)
  detailCategoryLabel:SetWidth(C.rightWidth)
  detailCategoryLabel:SetJustifyH("LEFT")
  detailCategoryLabel:SetText("Categories")
  ui.setDetailCategoryLabel = detailCategoryLabel

  local detailCategoryScroll = CreateFrame("ScrollFrame", "TriviaClassicSetDetailCategoryScrollFrame", optionsPage, "UIPanelScrollFrameTemplate")
  detailCategoryScroll:SetPoint("TOPLEFT", detailCategoryLabel, "BOTTOMLEFT", 0, -C.spacingXS)
  detailCategoryScroll:SetSize(C.rightWidth, 96)
  ui.setDetailCategoryScroll = detailCategoryScroll

  local detailCategoryContainer = CreateFrame("Frame", nil, detailCategoryScroll)
  detailCategoryContainer:SetSize(C.rightWidth - 24, 1)
  detailCategoryScroll:SetScrollChild(detailCategoryContainer)
  ui.setDetailCategoryContainer = detailCategoryContainer

  local detailCategoryHint = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  detailCategoryHint:SetPoint("TOPLEFT", detailCategoryScroll, "BOTTOMLEFT", 0, -C.spacingXS)
  detailCategoryHint:SetWidth(C.rightWidth)
  detailCategoryHint:SetJustifyH("LEFT")
  detailCategoryHint:SetJustifyV("TOP")
  detailCategoryHint:SetText("")
  ui.setDetailCategoryHint = detailCategoryHint

  local channelLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  channelLabel:SetPoint("TOPLEFT", setScroll, "BOTTOMLEFT", 0, -C.spacingMD)
  channelLabel:SetText("Announce / listen channel:")

  local dropDown = CreateFrame("Frame", "TriviaClassicChannelDropDown", optionsPage, "UIDropDownMenuTemplate")
  dropDown:SetPoint("LEFT", channelLabel, "RIGHT", C.spacingXS, -2)
  UIDropDownMenu_SetWidth(dropDown, 110)
  ui.dropDown = dropDown

  local customLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  customLabel:SetPoint("TOPLEFT", channelLabel, "BOTTOMLEFT", 0, -C.spacingMD)
  customLabel:SetText("Custom channel:")
  ui.customLabel = customLabel

  local customInput = CreateFrame("EditBox", nil, optionsPage, "InputBoxTemplate")
  customInput:SetSize(160, 20)
  customInput:SetPoint("LEFT", customLabel, "RIGHT", C.spacingSM, 0)
  customInput:SetAutoFocus(false)
  ui.customInput = customInput

  local channelStatus = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  channelStatus:SetPoint("TOPLEFT", customLabel, "BOTTOMLEFT", 0, -C.spacingSM)
  channelStatus:SetWidth(C.leftWidth)
  channelStatus:SetJustifyH("LEFT")
  channelStatus:SetText("Channel: Guild")
  ui.channelStatus = channelStatus

  local setCountLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  setCountLabel:SetPoint("TOPLEFT", channelStatus, "BOTTOMLEFT", 0, -C.spacingMD)
  setCountLabel:SetWidth(C.leftWidth)
  setCountLabel:SetJustifyH("LEFT")
  setCountLabel:SetText("Questions selected: 0")
  ui.setCountLabel = setCountLabel

  local questionCountLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  questionCountLabel:SetPoint("TOPLEFT", setCountLabel, "BOTTOMLEFT", 0, -C.spacingSM)
  questionCountLabel:SetText("Questions this game:")

  local questionCountInput = CreateFrame("EditBox", nil, optionsPage, "InputBoxTemplate")
  questionCountInput:SetSize(C.btnWidthSM, 20)
  questionCountInput:SetPoint("LEFT", questionCountLabel, "RIGHT", C.spacingSM, 0)
  questionCountInput:SetAutoFocus(false)
  questionCountInput:SetNumeric(true)
  questionCountInput:SetMaxLetters(3)
  questionCountInput:SetText("10")
  ui.questionCountInput = questionCountInput

  local timerLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  timerLabel:SetPoint("TOPLEFT", questionCountLabel, "BOTTOMLEFT", 0, -C.spacingMD)
  timerLabel:SetText("Timer (seconds):")
  ui.timerLabel = timerLabel

  local timerInput = CreateFrame("EditBox", nil, optionsPage, "InputBoxTemplate")
  timerInput:SetSize(C.btnWidthSM, 20)
  timerInput:SetPoint("LEFT", timerLabel, "RIGHT", C.spacingSM, 0)
  timerInput:SetAutoFocus(false)
  timerInput:SetNumeric(true)
  timerInput:SetMaxLetters(3)
  ui.timerInput = timerInput

  local stealTimerLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  stealTimerLabel:SetPoint("TOPLEFT", timerLabel, "BOTTOMLEFT", 0, -C.spacingMD)
  stealTimerLabel:SetText("Steal timer (seconds):")
  ui.stealTimerLabel = stealTimerLabel

  local stealTimerInput = CreateFrame("EditBox", nil, optionsPage, "InputBoxTemplate")
  stealTimerInput:SetSize(C.btnWidthSM, 20)
  stealTimerInput:SetPoint("LEFT", stealTimerLabel, "RIGHT", C.spacingSM, 0)
  stealTimerInput:SetAutoFocus(false)
  stealTimerInput:SetNumeric(true)
  stealTimerInput:SetMaxLetters(3)
  ui.stealTimerInput = stealTimerInput

  local modeLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  modeLabel:SetPoint("TOPLEFT", stealTimerLabel, "BOTTOMLEFT", 0, -C.spacingXL)
  modeLabel:SetText("Game mode:")
  ui.modeLabel = modeLabel

  local modeDropDown = CreateFrame("Frame", "TriviaClassicModeDropDown", optionsPage, "UIDropDownMenuTemplate")
  modeDropDown:SetPoint("LEFT", modeLabel, "RIGHT", C.spacingXS, -2)
  UIDropDownMenu_SetWidth(modeDropDown, 240)
  ui.modeDropDown = modeDropDown

  local modeHint = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  modeHint:SetPoint("TOPLEFT", modeLabel, "BOTTOMLEFT", 0, -C.spacingXS)
  modeHint:SetWidth(C.leftWidth)
  modeHint:SetJustifyH("LEFT")
  modeHint:SetText("Choose how winners are scored for each question.")
  ui.modeHint = modeHint

  -- Game page controls - top button row
  local startButton = Button(gamePage, "Start", C.btnWidthSM, C.btnHeightMD)
  startButton:SetPoint("TOPLEFT", originX, originY)
  ui.startButton = startButton

  local nextButton = Button(gamePage, "Next", C.btnWidthSM, C.btnHeightMD)
  nextButton:SetPoint("LEFT", startButton, "RIGHT", C.spacingSM, 0)
  nextButton:Disable()
  ui.nextButton = nextButton

  local skipButton = Button(gamePage, "Skip", C.btnWidthSM, C.btnHeightMD)
  skipButton:SetPoint("LEFT", nextButton, "RIGHT", C.spacingSM, 0)
  skipButton:Disable()
  ui.skipButton = skipButton

  local warningButton = Button(gamePage, "Time Left", C.btnWidthMD, C.btnHeightMD)
  warningButton:SetPoint("LEFT", skipButton, "RIGHT", C.spacingSM, 0)
  warningButton:Disable()
  ui.warningButton = warningButton

  local hintButton = Button(gamePage, "Hint", C.btnWidthSM, C.btnHeightMD)
  hintButton:SetPoint("LEFT", warningButton, "RIGHT", C.spacingSM, 0)
  hintButton:Disable()
  ui.hintButton = hintButton

  -- Second button row
  local sessionBtn = Button(gamePage, "Game Scores", C.btnWidthLG, C.btnHeightMD)
  sessionBtn:SetPoint("TOPLEFT", startButton, "BOTTOMLEFT", 0, -C.spacingSM)
  ui.sessionBtn = sessionBtn

  local allTimeBtn = Button(gamePage, "All-Time Scores", C.btnWidthLG, C.btnHeightMD)
  allTimeBtn:SetPoint("LEFT", sessionBtn, "RIGHT", C.spacingSM, 0)
  ui.allTimeBtn = allTimeBtn

  local endButton = Button(gamePage, "End", C.btnWidthSM, C.btnHeightMD)
  endButton:SetPoint("LEFT", allTimeBtn, "RIGHT", C.spacingSM, 0)
  endButton:Disable()
  ui.endButton = endButton

  -- Main content
  local questionLabel = gamePage:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  questionLabel:SetPoint("TOPLEFT", sessionBtn, "BOTTOMLEFT", 0, -C.spacingLG)
  questionLabel:SetJustifyH("LEFT")
  questionLabel:SetJustifyV("TOP")
  questionLabel:SetWidth(C.leftWidth)
  questionLabel:SetHeight(70)
  questionLabel:SetText("Press Start to begin.")
  ui.questionLabel = questionLabel

  local categoryLabel = gamePage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  categoryLabel:SetPoint("TOPLEFT", questionLabel, "BOTTOMLEFT", 0, -C.spacingSM)
  categoryLabel:SetText("")
  ui.categoryLabel = categoryLabel

  local gc = C.timerGreen
  local timerBar = CreateFrame("StatusBar", nil, gamePage)
  timerBar:SetPoint("TOPLEFT", categoryLabel, "BOTTOMLEFT", 0, -C.spacingLG)
  timerBar:SetSize(C.leftWidth, 16)
  timerBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
  timerBar:SetStatusBarColor(gc[1], gc[2], gc[3])
  timerBar:SetMinMaxValues(0, initialTimer)
  timerBar:SetValue(initialTimer)
  ui.timerBar = timerBar

  local timerText = timerBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  timerText:SetPoint("CENTER", timerBar, "CENTER", 0, 0)
  timerText:SetText(string.format("Time: %ds", initialTimer))
  ui.timerText = timerText

  local function updateTimerTextPosition()
    local minV, maxV = timerBar:GetMinMaxValues()
    local value = timerBar:GetValue() or 0
    local width = timerBar:GetWidth() or 0
    local denom = (maxV or 0) - (minV or 0)
    local ratio = 0
    if denom > 0 then
      ratio = (value - (minV or 0)) / denom
    end
    if ratio < 0 then ratio = 0 elseif ratio > 1 then ratio = 1 end
    timerText:ClearAllPoints()
    timerText:SetPoint("CENTER", timerBar, "LEFT", (width * ratio) * 0.5, 0)
  end

  timerBar:SetScript("OnValueChanged", function()
    updateTimerTextPosition()
  end)

  updateTimerTextPosition()

  local statusText = gamePage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  statusText:SetPoint("TOPLEFT", timerBar, "BOTTOMLEFT", 0, -C.spacingLG)
  statusText:SetWidth(C.leftWidth)
  statusText:SetJustifyH("LEFT")
  statusText:SetText("Load a set and press Start.")
  frame.statusText = statusText

  local rerollLabel = gamePage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  rerollLabel:SetPoint("TOPLEFT", statusText, "BOTTOMLEFT", 0, -C.spacingLG)
  rerollLabel:SetText("Head-to-Head: Next player")
  ui.rerollLabel = rerollLabel

  local rerollDropDown = CreateFrame("Frame", "TriviaClassicRerollTeamDropDown", gamePage, "UIDropDownMenuTemplate")
  rerollDropDown:SetPoint("LEFT", rerollLabel, "RIGHT", C.spacingSM, -2)
  UIDropDownMenu_SetWidth(rerollDropDown, 140)
  ui.rerollTeamDropDown = rerollDropDown

  local rerollButton = Button(gamePage, "Next Player", C.btnWidthMD, C.btnHeightSM)
  rerollButton:SetPoint("LEFT", rerollDropDown, "RIGHT", C.spacingSM, 2)
  rerollButton:Disable()
  ui.rerollTeamButton = rerollButton

  -- Right column
  local sessionLabel = gamePage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  sessionLabel:SetPoint("TOPLEFT", frame.InsetBg or gamePage, "TOPRIGHT", -C.rightWidth - C.padding, originY)
  sessionLabel:SetText("Current game scores:")
  ui.sessionLabel = sessionLabel

  local sessionBoard = gamePage:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  sessionBoard:SetPoint("TOPLEFT", sessionLabel, "BOTTOMLEFT", 0, -C.spacingSM)
  sessionBoard:SetWidth(C.rightWidth)
  sessionBoard:SetJustifyH("LEFT")
  sessionBoard:SetJustifyV("TOP")
  sessionBoard:SetText("No answers yet.")
  ui.sessionBoard = sessionBoard

  -- Teams page
  local teamTitle = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  teamTitle:SetPoint("TOPLEFT", originX, originY)
  teamTitle:SetText("Team Management")

  local teamNameLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  teamNameLabel:SetPoint("TOPLEFT", teamTitle, "BOTTOMLEFT", 0, -C.spacingMD)
  teamNameLabel:SetText("Team name:")

  local teamNameInput = CreateFrame("EditBox", nil, teamsPage, "InputBoxTemplate")
  teamNameInput:SetSize(180, 20)
  teamNameInput:SetPoint("LEFT", teamNameLabel, "RIGHT", C.spacingSM, 0)
  teamNameInput:SetAutoFocus(false)
  ui.teamNameInput = teamNameInput

  local addTeamBtn = Button(teamsPage, "Add Team", C.btnWidthMD, C.btnHeightSM)
  addTeamBtn:SetPoint("LEFT", teamNameInput, "RIGHT", C.spacingMD, 0)
  ui.addTeamBtn = addTeamBtn

  local teamSelectorLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  teamSelectorLabel:SetPoint("TOPLEFT", teamNameLabel, "BOTTOMLEFT", 0, -C.spacingLG)
  teamSelectorLabel:SetText("Target team:")

  local teamTargetDropDown = CreateFrame("Frame", "TriviaClassicTeamDropDown", teamsPage, "UIDropDownMenuTemplate")
  teamTargetDropDown:SetPoint("LEFT", teamSelectorLabel, "RIGHT", C.spacingSM, -2)
  UIDropDownMenu_SetWidth(teamTargetDropDown, 180)
  ui.teamTargetDropDown = teamTargetDropDown

  local removeTeamBtn = Button(teamsPage, "Remove Team", C.btnWidthLG, C.btnHeightSM)
  removeTeamBtn:SetPoint("LEFT", teamTargetDropDown, "RIGHT", C.spacingLG, 0)
  ui.removeTeamBtn = removeTeamBtn

  local waitingLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  waitingLabel:SetPoint("TOPLEFT", teamSelectorLabel, "BOTTOMLEFT", 0, -C.spacingLG)
  waitingLabel:SetText("Registered players (type 'trivia register'):")

  local teamMemberLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  teamMemberLabel:SetPoint("TOPLEFT", waitingLabel, "TOPLEFT", C.leftWidth/2 + C.spacingXL, 0)
  teamMemberLabel:SetText("Team members:")

  local waitingScroll = CreateFrame("ScrollFrame", "TriviaClassicWaitingScrollFrame", teamsPage, "UIPanelScrollFrameTemplate")
  waitingScroll:SetPoint("TOPLEFT", waitingLabel, "BOTTOMLEFT", 0, -C.spacingSM)
  waitingScroll:SetSize(C.leftWidth/2 - C.spacingXL, 220)
  ui.waitingScroll = waitingScroll

  local waitingContent = CreateFrame("Frame", nil, waitingScroll)
  waitingContent:SetSize(C.leftWidth/2 - 40, 1)
  waitingScroll:SetScrollChild(waitingContent)
  ui.waitingContent = waitingContent

  local waitingStatus = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  waitingStatus:SetPoint("TOPLEFT", waitingScroll, "BOTTOMLEFT", 0, -C.spacingXS)
  waitingStatus:SetText("Select players to move to a team.")
  waitingStatus:SetWidth(C.leftWidth/2 - C.spacingXL)
  waitingStatus:SetJustifyH("LEFT")
  ui.waitingStatus = waitingStatus

  local memberScroll = CreateFrame("ScrollFrame", "TriviaClassicTeamMemberScrollFrame", teamsPage, "UIPanelScrollFrameTemplate")
  memberScroll:SetPoint("TOPLEFT", teamMemberLabel, "BOTTOMLEFT", 0, -C.spacingSM)
  memberScroll:SetSize(C.leftWidth/2 - C.spacingXL, 220)
  ui.memberScroll = memberScroll

  local memberContent = CreateFrame("Frame", nil, memberScroll)
  memberContent:SetSize(C.leftWidth/2 - 40, 1)
  memberScroll:SetScrollChild(memberContent)
  ui.memberContent = memberContent

  local memberStatus = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  memberStatus:SetPoint("TOPLEFT", memberScroll, "BOTTOMLEFT", 0, -C.spacingXS)
  memberStatus:SetText("Select players to remove from the team.")
  memberStatus:SetWidth(C.leftWidth/2 - C.spacingXL)
  memberStatus:SetJustifyH("LEFT")
  ui.memberStatus = memberStatus

  local moveRightBtn = Button(teamsPage, ">>", 40, C.btnHeightSM)
  moveRightBtn:SetPoint("LEFT", waitingScroll, "RIGHT", C.spacingSM, C.spacingXL)
  ui.moveRightBtn = moveRightBtn

  local moveLeftBtn = Button(teamsPage, "<<", 40, C.btnHeightSM)
  moveLeftBtn:SetPoint("TOP", moveRightBtn, "BOTTOM", 0, -C.spacingSM)
  ui.moveLeftBtn = moveLeftBtn

  local teamListLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  teamListLabel:SetPoint("TOPLEFT", memberScroll, "BOTTOMLEFT", 0, -C.spacingXL - C.spacingLG)
  teamListLabel:SetText("Teams:")

  local announceTeamsBtn = Button(teamsPage, "Announce Teams", 140, C.btnHeightSM)
  announceTeamsBtn:SetPoint("LEFT", teamListLabel, "RIGHT", C.spacingLG, 0)
  ui.announceTeamsBtn = announceTeamsBtn

  local teamScroll = CreateFrame("ScrollFrame", "TriviaClassicTeamScrollFrame", teamsPage, "UIPanelScrollFrameTemplate")
  teamScroll:SetPoint("TOPLEFT", teamListLabel, "BOTTOMLEFT", 0, -C.spacingSM)
  teamScroll:SetSize(C.leftWidth, 220)
  ui.teamScroll = teamScroll

  local teamContent = CreateFrame("Frame", nil, teamScroll)
  teamContent:SetSize(C.leftWidth - 24, 1)
  teamScroll:SetScrollChild(teamContent)
  ui.teamContent = teamContent

  local teamList = teamContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  teamList:SetPoint("TOPLEFT", 0, 0)
  teamList:SetWidth(C.leftWidth - 30)
  teamList:SetJustifyH("LEFT")
  teamList:SetJustifyV("TOP")
  teamList:SetText("No teams yet.")
  ui.teamList = teamList

  local teamStatus = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  teamStatus:SetPoint("TOPLEFT", teamScroll, "BOTTOMLEFT", 0, -C.spacingSM)
  teamStatus:SetWidth(C.leftWidth)
  teamStatus:SetJustifyH("LEFT")
  teamStatus:SetText("")
  ui.teamStatus = teamStatus

  return frame
end
