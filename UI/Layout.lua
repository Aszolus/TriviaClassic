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
  tabGame:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -28)
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
  -- Constrain content to the inset area so it doesn't overlap the frame borders/tabs
  optionsPage:SetAllPoints(frame.InsetBg or frame)
  ui.optionsPage = optionsPage

  local gamePage = CreateFrame("Frame", nil, frame)
  -- Constrain content to the inset area so it doesn't overlap the frame borders/tabs
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

  -- Scrollable area for the (potentially long) list of sets and categories
  local setScroll = CreateFrame("ScrollFrame", "TriviaClassicSetScrollFrame", optionsPage, "UIPanelScrollFrameTemplate")
  setScroll:SetPoint("TOPLEFT", setLabel, "BOTTOMLEFT", 0, -6)
  setScroll:SetSize(C.leftWidth, C.setHeight)
  -- Enable mouse wheel scrolling for convenience
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

  -- Content frame that will hold all dynamically created set/category widgets
  local setContent = CreateFrame("Frame", nil, setScroll)
  -- Width slightly reduced to account for scrollbar so text doesn't clip under it
  setContent:SetSize(C.leftWidth - 24, 1)
  if setContent.SetPoint then
    setContent:SetPoint("TOPLEFT", setScroll, "TOPLEFT", 0, 0)
  end
  setScroll:SetScrollChild(setContent)
  ui.setContainer = setContent

  local channelLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  -- Place channel selection below the sets within the left column
  -- Anchor channel controls under the scroll frame container (visual area)
  channelLabel:SetPoint("TOPLEFT", setScroll, "BOTTOMLEFT", 0, -8)
  channelLabel:SetText("Announce / listen channel:")

  local dropDown = CreateFrame("Frame", "TriviaClassicChannelDropDown", optionsPage, "UIDropDownMenuTemplate")
  dropDown:SetPoint("LEFT", channelLabel, "RIGHT", 4, -2)
  UIDropDownMenu_SetWidth(dropDown, 110)
  ui.dropDown = dropDown

  local customLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  -- Keep custom channel controls stacked under the channel dropdown
  customLabel:SetPoint("TOPLEFT", channelLabel, "BOTTOMLEFT", 0, -8)
  customLabel:SetText("Custom channel:")
  ui.customLabel = customLabel

  local customInput = CreateFrame("EditBox", nil, optionsPage, "InputBoxTemplate")
  customInput:SetSize(160, 20)
  customInput:SetPoint("LEFT", customLabel, "RIGHT", 6, 0)
  customInput:SetAutoFocus(false)
  ui.customInput = customInput

  local channelStatus = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  channelStatus:SetPoint("TOPLEFT", customLabel, "BOTTOMLEFT", 0, -6)
  -- Ensure status fits within the left column
  channelStatus:SetWidth(C.leftWidth)
  channelStatus:SetJustifyH("LEFT")
  channelStatus:SetText("Channel: Guild")
  ui.channelStatus = channelStatus

  local setCountLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  -- Move questions-selected label below the channel section
  setCountLabel:SetPoint("TOPLEFT", channelStatus, "BOTTOMLEFT", 0, -8)
  setCountLabel:SetWidth(C.leftWidth)
  setCountLabel:SetJustifyH("LEFT")
  setCountLabel:SetText("Questions selected: 0")
  ui.setCountLabel = setCountLabel

  local questionCountLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  questionCountLabel:SetPoint("TOPLEFT", setCountLabel, "BOTTOMLEFT", 0, -6)
  questionCountLabel:SetText("Questions this game:")

  local questionCountInput = CreateFrame("EditBox", nil, optionsPage, "InputBoxTemplate")
  questionCountInput:SetSize(60, 20)
  questionCountInput:SetPoint("LEFT", questionCountLabel, "RIGHT", 6, 0)
  questionCountInput:SetAutoFocus(false)
  questionCountInput:SetNumeric(true)
  questionCountInput:SetMaxLetters(3)
  -- Default to 10 questions instead of blank/random
  questionCountInput:SetText("10")
  ui.questionCountInput = questionCountInput

  local timerLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  timerLabel:SetPoint("TOPLEFT", questionCountLabel, "BOTTOMLEFT", 0, -8)
  timerLabel:SetText("Timer (seconds):")

  local timerInput = CreateFrame("EditBox", nil, optionsPage, "InputBoxTemplate")
  timerInput:SetSize(60, 20)
  timerInput:SetPoint("LEFT", timerLabel, "RIGHT", 6, 0)
  timerInput:SetAutoFocus(false)
  timerInput:SetNumeric(true)
  timerInput:SetMaxLetters(3)
  ui.timerInput = timerInput

  local modeLabel = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  -- Place mode selection clearly below the timer input
  modeLabel:SetPoint("TOPLEFT", timerLabel, "BOTTOMLEFT", 0, -20)
  modeLabel:SetText("Game mode:")

  local modeDropDown = CreateFrame("Frame", "TriviaClassicModeDropDown", optionsPage, "UIDropDownMenuTemplate")
  modeDropDown:SetPoint("LEFT", modeLabel, "RIGHT", 4, -2)
  UIDropDownMenu_SetWidth(modeDropDown, 240)
  ui.modeDropDown = modeDropDown

  local modeHint = optionsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  modeHint:SetPoint("TOPLEFT", modeLabel, "BOTTOMLEFT", 0, -4)
  modeHint:SetWidth(C.leftWidth)
  modeHint:SetJustifyH("LEFT")
  modeHint:SetText("Choose how winners are scored for each question.")
  ui.modeHint = modeHint

  -- Removed obsolete hint label about blank/random question count

  -- Game page controls
  -- Keep the top button row within the left column to avoid overlap with the right column
  local startButton = Button(gamePage, "Start", 64, 26)
  startButton:SetPoint("TOPLEFT", originX, originY)
  ui.startButton = startButton

  local nextButton = Button(gamePage, "Next", 70, 28)
  nextButton:SetPoint("LEFT", startButton, "RIGHT", 8, 0)
  nextButton:Disable()
  ui.nextButton = nextButton

  local skipButton = Button(gamePage, "Skip", 50, 24)
  skipButton:SetPoint("LEFT", nextButton, "RIGHT", 6, 0)
  skipButton:Disable()
  ui.skipButton = skipButton

  local warningButton = Button(gamePage, "10s Left", 80, 24)
  warningButton:SetPoint("LEFT", skipButton, "RIGHT", 8, 0)
  warningButton:Disable()
  ui.warningButton = warningButton

  local hintButton = Button(gamePage, "Hint", 60, 24)
  hintButton:SetPoint("LEFT", warningButton, "RIGHT", 8, 0)
  hintButton:Disable()
  ui.hintButton = hintButton

  local sessionBtn = Button(gamePage, "Game Scores", 110, 24)
  sessionBtn:SetPoint("TOPLEFT", startButton, "BOTTOMLEFT", 0, -6)
  ui.sessionBtn = sessionBtn

  local allTimeBtn = Button(gamePage, "All-Time\nScores", 110, 28)
  allTimeBtn:SetPoint("LEFT", sessionBtn, "RIGHT", 8, 0)
  ui.allTimeBtn = allTimeBtn

  local endButton = Button(gamePage, "End", 70, 24)
  endButton:SetPoint("LEFT", allTimeBtn, "RIGHT", 8, 0)
  endButton:Disable()
  ui.endButton = endButton

  -- Main content
  local questionLabel = gamePage:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  questionLabel:SetPoint("TOPLEFT", sessionBtn, "BOTTOMLEFT", 0, -14)
  questionLabel:SetJustifyH("LEFT")
  questionLabel:SetJustifyV("TOP")
  -- Match left column width so the text wraps within the compact layout
  questionLabel:SetWidth(C.leftWidth)
  questionLabel:SetHeight(70)
  questionLabel:SetText("Press Start to begin.")
  ui.questionLabel = questionLabel

  local categoryLabel = gamePage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  categoryLabel:SetPoint("TOPLEFT", questionLabel, "BOTTOMLEFT", 0, -6)
  categoryLabel:SetText("")
  ui.categoryLabel = categoryLabel

  local timerBar = CreateFrame("StatusBar", nil, gamePage)
  timerBar:SetPoint("TOPLEFT", categoryLabel, "BOTTOMLEFT", 0, -10)
  -- Use full left column width; timer text will be centered on the bar
  timerBar:SetSize(C.leftWidth, 16)
  timerBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
  timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  timerBar:SetMinMaxValues(0, initialTimer)
  timerBar:SetValue(initialTimer)
  ui.timerBar = timerBar

  local timerText = timerBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  -- Center the timer text on the timer bar
  timerText:SetPoint("CENTER", timerBar, "CENTER", 0, 0)
  timerText:SetText(string.format("Time: %ds", initialTimer))
  ui.timerText = timerText

  -- Keep the timer text centered over the filled portion of the bar as it moves
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
    -- Position the label so its center sits at the center of the filled area
    -- Anchor the text's CENTER at the center of the filled portion
    timerText:ClearAllPoints()
    timerText:SetPoint("CENTER", timerBar, "LEFT", (width * ratio) * 0.5, 0)
  end

  timerBar:SetScript("OnValueChanged", function()
    updateTimerTextPosition()
  end)

  -- Initialize the position based on the initial value
  updateTimerTextPosition()

  local statusText = gamePage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  statusText:SetPoint("TOPLEFT", timerBar, "BOTTOMLEFT", 0, -10)
  statusText:SetWidth(C.leftWidth)
  statusText:SetJustifyH("LEFT")
  statusText:SetText("Load a set and press Start.")
  frame.statusText = statusText

  -- Right column
  local sessionLabel = gamePage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  -- Anchor the right column to the inset area to keep it inside the panel borders
  sessionLabel:SetPoint("TOPLEFT", frame.InsetBg or gamePage, "TOPRIGHT", -C.rightWidth - C.padding, originY)
  sessionLabel:SetText("Current game scores:")

  local sessionBoard = gamePage:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  sessionBoard:SetPoint("TOPLEFT", sessionLabel, "BOTTOMLEFT", 0, -6)
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
  teamNameLabel:SetPoint("TOPLEFT", teamTitle, "BOTTOMLEFT", 0, -8)
  teamNameLabel:SetText("Team name:")

  local teamNameInput = CreateFrame("EditBox", nil, teamsPage, "InputBoxTemplate")
  teamNameInput:SetSize(180, 20)
  teamNameInput:SetPoint("LEFT", teamNameLabel, "RIGHT", 6, 0)
  teamNameInput:SetAutoFocus(false)
  ui.teamNameInput = teamNameInput

  local addTeamBtn = Button(teamsPage, "Add Team", 90, 22)
  addTeamBtn:SetPoint("LEFT", teamNameInput, "RIGHT", 8, 0)
  ui.addTeamBtn = addTeamBtn

  local teamSelectorLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  teamSelectorLabel:SetPoint("TOPLEFT", teamNameLabel, "BOTTOMLEFT", 0, -12)
  teamSelectorLabel:SetText("Target team:")

  local teamTargetDropDown = CreateFrame("Frame", "TriviaClassicTeamDropDown", teamsPage, "UIDropDownMenuTemplate")
  teamTargetDropDown:SetPoint("LEFT", teamSelectorLabel, "RIGHT", 6, -2)
  UIDropDownMenu_SetWidth(teamTargetDropDown, 180)
  ui.teamTargetDropDown = teamTargetDropDown

  local removeTeamBtn = Button(teamsPage, "Remove Team", 110, 22)
  removeTeamBtn:SetPoint("LEFT", teamTargetDropDown, "RIGHT", 10, 0)
  ui.removeTeamBtn = removeTeamBtn

  local waitingLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  waitingLabel:SetPoint("TOPLEFT", teamSelectorLabel, "BOTTOMLEFT", 0, -14)
  waitingLabel:SetText("Registered players (type 'trivia register'):")

  local teamMemberLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  teamMemberLabel:SetPoint("TOPLEFT", waitingLabel, "TOPLEFT", C.leftWidth/2 + 20, 0)
  teamMemberLabel:SetText("Team members:")

  local waitingScroll = CreateFrame("ScrollFrame", "TriviaClassicWaitingScrollFrame", teamsPage, "UIPanelScrollFrameTemplate")
  waitingScroll:SetPoint("TOPLEFT", waitingLabel, "BOTTOMLEFT", 0, -6)
  waitingScroll:SetSize(C.leftWidth/2 - 20, 220)
  ui.waitingScroll = waitingScroll

  local waitingContent = CreateFrame("Frame", nil, waitingScroll)
  waitingContent:SetSize(C.leftWidth/2 - 40, 1)
  waitingScroll:SetScrollChild(waitingContent)
  ui.waitingContent = waitingContent

  local waitingStatus = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  waitingStatus:SetPoint("TOPLEFT", waitingScroll, "BOTTOMLEFT", 0, -4)
  waitingStatus:SetText("Select players to move to a team.")
  waitingStatus:SetWidth(C.leftWidth/2 - 20)
  waitingStatus:SetJustifyH("LEFT")
  ui.waitingStatus = waitingStatus

  local memberScroll = CreateFrame("ScrollFrame", "TriviaClassicTeamMemberScrollFrame", teamsPage, "UIPanelScrollFrameTemplate")
  memberScroll:SetPoint("TOPLEFT", teamMemberLabel, "BOTTOMLEFT", 0, -6)
  memberScroll:SetSize(C.leftWidth/2 - 20, 220)
  ui.memberScroll = memberScroll

  local memberContent = CreateFrame("Frame", nil, memberScroll)
  memberContent:SetSize(C.leftWidth/2 - 40, 1)
  memberScroll:SetScrollChild(memberContent)
  ui.memberContent = memberContent

  local memberStatus = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  memberStatus:SetPoint("TOPLEFT", memberScroll, "BOTTOMLEFT", 0, -4)
  memberStatus:SetText("Select players to remove from the team.")
  memberStatus:SetWidth(C.leftWidth/2 - 20)
  memberStatus:SetJustifyH("LEFT")
  ui.memberStatus = memberStatus

  local moveRightBtn = Button(teamsPage, ">>", 40, 24)
  moveRightBtn:SetPoint("LEFT", waitingScroll, "RIGHT", 6, 20)
  ui.moveRightBtn = moveRightBtn

  local moveLeftBtn = Button(teamsPage, "<<", 40, 24)
  moveLeftBtn:SetPoint("TOP", moveRightBtn, "BOTTOM", 0, -6)
  ui.moveLeftBtn = moveLeftBtn

  local teamListLabel = teamsPage:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  teamListLabel:SetPoint("TOPLEFT", memberScroll, "BOTTOMLEFT", 0, -30)
  teamListLabel:SetText("Teams:")

  local teamScroll = CreateFrame("ScrollFrame", "TriviaClassicTeamScrollFrame", teamsPage, "UIPanelScrollFrameTemplate")
  teamScroll:SetPoint("TOPLEFT", teamListLabel, "BOTTOMLEFT", 0, -6)
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
  teamStatus:SetPoint("TOPLEFT", teamScroll, "BOTTOMLEFT", 0, -6)
  teamStatus:SetWidth(C.leftWidth)
  teamStatus:SetJustifyH("LEFT")
  teamStatus:SetText("")
  ui.teamStatus = teamStatus

  return frame
end
