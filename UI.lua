local UI = {}
TriviaClassicUI = UI

local channels = {
  { key = "GUILD", label = "Guild" },
  { key = "PARTY", label = "Party" },
  { key = "RAID", label = "Raid" },
  { key = "SAY", label = "Say" },
  { key = "YELL", label = "Yell" },
  { key = "CUSTOM", label = "Custom" },
}

local function trim(text)
  return (text or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function createButton(parent, label, width, height)
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btn:SetSize(width, height)
  btn:SetText(label)
  return btn
end

local function createCheckbox(parent, label, yOffset, onClick)
  local check = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
  check:SetPoint("TOPLEFT", 0, yOffset)
  check.Text:SetText(label)
  check:SetScript("OnClick", function(self) onClick(self:GetChecked()) end)
  return check
end

function UI:RefreshSetList()
  if not self.setContainer then
    return
  end

  for _, item in ipairs(self.setItems or {}) do
    item:Hide()
  end

  self.setItems = {}
  self.selectedSets = self.selectedSets or {}
  local shouldSelectAll = (next(self.selectedSets) == nil)
  local sets = TriviaClassic:GetAllSets()
  local yOffset = 0
  local questionCount = 0

  for _, set in ipairs(sets) do
    local check = createCheckbox(self.setContainer, set.title, -yOffset, function(checked)
      if checked then
        self.selectedSets[set.id] = true
      else
        self.selectedSets[set.id] = false
      end
    end)
    if shouldSelectAll then
      self.selectedSets[set.id] = true
    end
    check:SetChecked(self.selectedSets[set.id] or false)
    check.tooltip = set.description or set.title
    if self.selectedSets[set.id] and set.questions then
      questionCount = questionCount + #set.questions
    end
    table.insert(self.setItems, check)
    yOffset = yOffset + 24
  end

  if self.setCountLabel then
    self.setCountLabel:SetText(string.format("Questions selected: %d", questionCount))
  end
end

local function showCustomControls(self, show)
  if not self.customLabel or not self.customInput then
    return
  end
  if show then
    self.customLabel:Show()
    self.customInput:Show()
  else
    self.customLabel:Hide()
    self.customInput:Hide()
  end
end

function UI:SetChannel(key)
  self.channelKey = key
  if key == "CUSTOM" then
    showCustomControls(self, true)
    local name = trim(self.customInput:GetText())
    if name ~= "" then
      TriviaClassic:SetChannel("CUSTOM", name)
    end
  else
    showCustomControls(self, false)
    TriviaClassic:SetChannel(key)
  end
  if self.channelStatus then
    local label = key == "CUSTOM" and ("Custom: " .. (self.customInput:GetText() or "")) or key:sub(1,1) .. key:sub(2):lower()
    self.channelStatus:SetText("Channel: " .. label)
  end
end

function UI:SetCustomChannel(name)
  name = trim(name or "")
  if name == "" then
    return
  end
  self.customInput:SetText(name)
  self.channelKey = "CUSTOM"
  showCustomControls(self, true)
  TriviaClassic:SetChannel("CUSTOM", name)
  if self.channelStatus then
    self.channelStatus:SetText("Channel: Custom - " .. name)
  end
end

local function formatSetNames(names)
  if not names or #names == 0 then
    return "unknown sets"
  end
  return table.concat(names, ", ")
end

function UI:UpdateSessionBoard()
  local rows = {}
  for idx, entry in ipairs(TriviaClassic:GetSessionScoreboard()) do
    local timeInfo = entry.bestTime and string.format(" (best %.1fs)", entry.bestTime) or ""
    table.insert(rows, string.format("%d) %s - %d pts (%d correct)%s", idx, entry.name, entry.points, entry.correct, timeInfo))
  end
  if #rows == 0 then
    rows[1] = "No answers yet."
  end
  self.sessionBoard:SetText(table.concat(rows, "\n"))
end

function UI:ShowSessionScores()
  local rows = TriviaClassic:GetSessionScoreboard()
  DEFAULT_CHAT_FRAME:AddMessage("|cffffff00[Trivia]|r Current game scores:")
  if #rows == 0 then
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00[Trivia]|r No answers yet.")
  else
    for _, entry in ipairs(rows) do
      DEFAULT_CHAT_FRAME:AddMessage(string.format("|cffffff00[Trivia]|r %s - %d pts (%d correct)", entry.name, entry.points, entry.correct))
    end
  end
end

function UI:ShowAllTimeScores()
  local rows = TriviaClassic:GetLeaderboard(20)
  DEFAULT_CHAT_FRAME:AddMessage("|cffffff00[Trivia]|r All-time scores:")
  if #rows == 0 then
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00[Trivia]|r No scores yet.")
  else
    for _, entry in ipairs(rows) do
      DEFAULT_CHAT_FRAME:AddMessage(string.format("|cffffff00[Trivia]|r %s - %d pts (%d correct)", entry.name, entry.points or 0, entry.correct or 0))
    end
  end
end

function UI:StartGame()
  local selectedIds = {}
  for id, checked in pairs(self.selectedSets or {}) do
    if checked then
      table.insert(selectedIds, id)
    end
  end

  if #selectedIds == 0 then
    print("|cffff5050TriviaClassic: Select at least one question set.|r")
    return
  end

  local desiredCount = tonumber(self.questionCountInput and self.questionCountInput:GetText() or "")
  local meta = TriviaClassic:StartGame(selectedIds, desiredCount)
  if not meta then
    print("|cffff5050TriviaClassic: No questions available.|r")
    return
  end

  self.nextButton:SetText("Next Question")
  self.nextButton:Enable()
  if self.skipButton then
    self.skipButton:Enable()
  end
  self.warningButton:Disable()
  self.frame.statusText:SetText(string.format("Game started with %d questions.", meta.total))
  self.questionLabel:SetText("Press Next to announce Question 1.")
  self.categoryLabel:SetText("")
  self.timerText:SetText(string.format("Time: %ds", TriviaClassic.DEFAULT_TIMER))
  self.timerBar:SetMinMaxValues(0, TriviaClassic.DEFAULT_TIMER)
  self.timerBar:SetValue(TriviaClassic.DEFAULT_TIMER)
  self.timerRunning = false
  self.questionNumber = 0
  self:UpdateSessionBoard()

  TriviaClassic.chat:SendStart({ total = meta.total, setNames = formatSetNames(meta.setNames) })
  if self.endButton then
    self.endButton:Enable()
  end
end

function UI:AnnounceQuestion()
  local q, index, total = TriviaClassic:NextQuestion()
  if not q then
    self.frame.statusText:SetText("No more questions. End the game.")
    self.nextButton:SetText("End Game")
    return
  end

  self.questionNumber = index
  self.currentQuestion = q
  self.questionLabel:SetText(string.format("Q%d/%d: %s", index, total, q.question))
  self.categoryLabel:SetText(string.format("Category: %s  |  Points: %s", q.category or "General", tostring(q.points or 1)))
  self.frame.statusText:SetText("Question announced. Listening for answers...")

  self.timerRemaining = TriviaClassic.DEFAULT_TIMER
  self.timerRunning = true
  self.timerBar:SetMinMaxValues(0, TriviaClassic.DEFAULT_TIMER)
  self.timerBar:SetValue(TriviaClassic.DEFAULT_TIMER)
  self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  self.timerText:SetText(string.format("Time: %ds", TriviaClassic.DEFAULT_TIMER))
  self.warningButton:Enable()
  self.nextButton:SetText("Waiting for Answer")
  self.nextButton:Disable()
  if self.skipButton then
    self.skipButton:Enable()
  end
  if self.skipButton then
    self.skipButton:Disable()
  end

  TriviaClassic.chat:SendQuestion(index, total, q)
end

function UI:AnnounceWinner()
  if not TriviaClassic:IsPendingWinner() then
    return
  end
  local winnerName, elapsed = TriviaClassic:GetLastWinner()
  if not winnerName then
    return
  end
  local q = TriviaClassic:GetCurrentQuestion()
  TriviaClassic.chat:SendWinner(winnerName, elapsed or 0, q and q.points)
  self.frame.statusText:SetText("Winner announced. Click Next for the next question.")
  local finished = TriviaClassic:CompleteWinnerBroadcast()
  if finished then
    self.nextButton:SetText("End Game")
  else
    self.nextButton:SetText("Next Question")
  end
  self.nextButton:Enable()
  if self.skipButton then
    self.skipButton:Disable()
  end
end

function UI:AnnounceNoWinner()
  local q = TriviaClassic:GetCurrentQuestion()
  local answersText = ""
  if q and q.displayAnswers then
    answersText = table.concat(q.displayAnswers, ", ")
  elseif q and q.answers then
    answersText = table.concat(q.answers, ", ")
  end
  TriviaClassic.chat:SendNoWinner(answersText)
  local finished = TriviaClassic:CompleteNoWinnerBroadcast()
  if finished then
    self.nextButton:SetText("End Game")
  else
    self.nextButton:SetText("Next Question")
  end
  self.nextButton:Enable()
end

function UI:EndGame()
  local rows = TriviaClassic:GetSessionScoreboard()
  TriviaClassic.chat:SendEnd(rows)
  TriviaClassic:EndGame()
  self.frame.statusText:SetText("Game ended. Press Start to begin a new game.")
  self.nextButton:SetText("Next Question")
  self.nextButton:Disable()
  self.warningButton:Disable()
  self.timerRunning = false
end

function UI:OnNextPressed()
  if not TriviaClassic:IsGameActive() then
    self.frame.statusText:SetText("Start a game first.")
    return
  end

  if self.nextButton:GetText() == "End Game" then
    self:EndGame()
    return
  end

  if TriviaClassic:IsPendingWinner() then
    self:AnnounceWinner()
    self:UpdateSessionBoard()
    return
  end

  if TriviaClassic:IsPendingNoWinner() then
    self:AnnounceNoWinner()
    return
  end

  if TriviaClassic:IsQuestionOpen() then
    self.frame.statusText:SetText("A question is already active.")
    return
  end

  if not TriviaClassic:HasMoreQuestions() then
    self.nextButton:SetText("End Game")
    return
  end

  self:AnnounceQuestion()
end

function UI:SkipQuestion()
  if not TriviaClassic:IsGameActive() then
    return
  end
  if TriviaClassic:IsQuestionOpen() then
    TriviaClassic:MarkTimeout()
    self.frame.statusText:SetText("Question skipped. Click Next for the next question.")
    self.timerRunning = false
    self.timerBar:SetValue(0)
    self.timerText:SetText("Time: skipped")
    self.warningButton:Disable()
    self.nextButton:SetText("Next Question")
    self.nextButton:Enable()
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
  TriviaClassic.chat:SendWarning()
end

function UI:OnWinnerFound(winnerName, elapsed)
  self.timerRunning = false
  self.warningButton:Disable()
  self.frame.statusText:SetText(string.format("%s answered correctly in %.1fs. Click 'Announce Winner' to broadcast.", winnerName, elapsed or 0))
  self.nextButton:SetText("Announce Winner")
  self.nextButton:Enable()
  self:UpdateSessionBoard()
end

function UI:UpdateTimer(elapsed)
  if not self.timerRunning then
    return
  end
  self.timerRemaining = (self.timerRemaining or TriviaClassic.DEFAULT_TIMER) - elapsed
  if self.timerRemaining <= 0 then
    self.timerRemaining = 0
    self.timerRunning = false
    TriviaClassic:MarkTimeout()
    self.timerBar:SetValue(0)
    self.timerText:SetText("Time: 0s")
    self.timerBar:SetStatusBarColor(0.7, 0.1, 0.1)
    self.warningButton:Disable()
    self.nextButton:SetText("Announce No Winner")
    self.nextButton:Enable()
    self.frame.statusText:SetText("Time expired. Click 'Announce No Winner' to continue.")
    return
  end
  self.timerBar:SetValue(self.timerRemaining)
  local pct = self.timerRemaining / (TriviaClassic.DEFAULT_TIMER or self.timerRemaining)
  if pct > 0.66 then
    self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  elseif pct > 0.33 then
    self.timerBar:SetStatusBarColor(0.95, 0.7, 0.2)
  else
    self.timerBar:SetStatusBarColor(0.9, 0.2, 0.2)
  end
  self.timerText:SetText(string.format("Time: %ds", math.ceil(self.timerRemaining)))
end

function UI:BuildUI()
  if self.frame then
    self:RefreshSetList()
    self:UpdateSessionBoard()
    return
  end

  self.channelKey = "GUILD"
  TriviaClassic:SetChannel(self.channelKey)

  local frame = CreateFrame("Frame", "TriviaClassicFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(620, 420)
  frame:SetPoint("CENTER")
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  frame.TitleText:SetText("TriviaClassic - Host Panel")
  self.frame = frame

  local setLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  setLabel:SetPoint("TOPLEFT", 16, -34)
  setLabel:SetText("Question Sets (auto-select all):")

  local setContainer = CreateFrame("Frame", nil, frame)
  setContainer:SetPoint("TOPLEFT", setLabel, "BOTTOMLEFT", 0, -6)
  setContainer:SetSize(260, 140)
  self.setContainer = setContainer

  -- Channel + custom input
  local channelLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  channelLabel:SetPoint("TOPLEFT", setContainer, "TOPRIGHT", 20, 0)
  channelLabel:SetText("Announce / listen channel:")

  local dropDown = CreateFrame("Frame", "TriviaClassicChannelDropDown", frame, "UIDropDownMenuTemplate")
  dropDown:SetPoint("LEFT", channelLabel, "RIGHT", 4, -2)
  UIDropDownMenu_SetWidth(dropDown, 110)
  UIDropDownMenu_SetSelectedValue(dropDown, self.channelKey)
  UIDropDownMenu_Initialize(dropDown, function(_, _, _)
    for _, ch in ipairs(channels) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = ch.label
      info.value = ch.key
      info.func = function()
        UIDropDownMenu_SetSelectedValue(dropDown, ch.key)
        self:SetChannel(ch.key)
      end
      info.checked = (self.channelKey == ch.key)
      UIDropDownMenu_AddButton(info)
    end
  end)
  self.dropDown = dropDown

  local customLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  customLabel:SetPoint("TOPLEFT", channelLabel, "BOTTOMLEFT", 0, -6)
  customLabel:SetText("Custom channel:")
  self.customLabel = customLabel

  local customInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
  customInput:SetSize(160, 20)
  customInput:SetPoint("LEFT", customLabel, "RIGHT", 6, 0)
  customInput:SetAutoFocus(false)
  customInput:SetScript("OnEnterPressed", function(box)
    self:SetCustomChannel(box:GetText())
    box:ClearFocus()
  end)
  customInput:SetScript("OnEditFocusLost", function(box)
    self:SetCustomChannel(box:GetText())
  end)
  self.customInput = customInput
  showCustomControls(self, false)

  -- Question count + totals
  local setCountLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  setCountLabel:SetPoint("TOPLEFT", setContainer, "BOTTOMLEFT", 0, -8)
  setCountLabel:SetText("Questions selected: 0")
  self.setCountLabel = setCountLabel

  local channelStatus = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  channelStatus:SetPoint("TOPLEFT", setCountLabel, "BOTTOMLEFT", 0, -6)
  channelStatus:SetText("Channel: Guild")
  self.channelStatus = channelStatus

  local questionCountLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  questionCountLabel:SetPoint("TOPLEFT", channelStatus, "BOTTOMLEFT", 0, -6)
  questionCountLabel:SetText("Questions this game:")

  local questionCountInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
  questionCountInput:SetSize(60, 20)
  questionCountInput:SetPoint("LEFT", questionCountLabel, "RIGHT", 6, 0)
  questionCountInput:SetAutoFocus(false)
  questionCountInput:SetNumeric(true)
  questionCountInput:SetMaxLetters(3)
  questionCountInput:SetText("")
  self.questionCountInput = questionCountInput

  local hintCount = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  hintCount:SetPoint("LEFT", questionCountInput, "RIGHT", 6, 0)
  hintCount:SetText("(blank = 10-20 random)")
  self.questionCountHint = hintCount

  -- Control bar
  local startButton = createButton(frame, "Start Game", 110, 26)
  startButton:SetPoint("TOPLEFT", questionCountLabel, "BOTTOMLEFT", 0, -10)
  startButton:SetScript("OnClick", function()
    self:StartGame()
  end)
  self.startButton = startButton

  local nextButton = createButton(frame, "Next Question", 120, 28)
  nextButton:SetPoint("LEFT", startButton, "RIGHT", 8, 0)
  nextButton:SetScript("OnClick", function()
    self:OnNextPressed()
  end)
  nextButton:Disable()
  self.nextButton = nextButton

  local skipButton = createButton(frame, "Skip", 80, 24)
  skipButton:SetPoint("LEFT", nextButton, "RIGHT", 6, 0)
  skipButton:SetScript("OnClick", function()
    self:SkipQuestion()
  end)
  skipButton:Disable()
  self.skipButton = skipButton

  local warningButton = createButton(frame, "10s Remaining", 120, 24)
  warningButton:SetPoint("LEFT", skipButton, "RIGHT", 8, 0)
  warningButton:SetScript("OnClick", function()
    self:SendWarning()
  end)
  warningButton:Disable()
  self.warningButton = warningButton

  local sessionBtn = createButton(frame, "Show Game Scores", 140, 24)
  sessionBtn:SetPoint("TOPLEFT", startButton, "BOTTOMLEFT", 0, -6)
  sessionBtn:SetScript("OnClick", function()
    self:ShowSessionScores()
  end)
  self.sessionBtn = sessionBtn

  local allTimeBtn = createButton(frame, "Show All-Time Scores", 160, 24)
  allTimeBtn:SetPoint("LEFT", sessionBtn, "RIGHT", 8, 0)
  allTimeBtn:SetScript("OnClick", function()
    self:ShowAllTimeScores()
  end)
  self.allTimeBtn = allTimeBtn

  local endButton = createButton(frame, "End Game", 100, 24)
  endButton:SetPoint("LEFT", allTimeBtn, "RIGHT", 8, 0)
  endButton:SetScript("OnClick", function()
    self:EndGame()
  end)
  endButton:Disable()
  self.endButton = endButton

  -- Question area
  local questionLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  questionLabel:SetPoint("TOPLEFT", sessionBtn, "BOTTOMLEFT", 0, -12)
  questionLabel:SetJustifyH("LEFT")
  questionLabel:SetJustifyV("TOP")
  questionLabel:SetWidth(400)
  questionLabel:SetHeight(70)
  questionLabel:SetText("Press Start to begin.")
  self.questionLabel = questionLabel

  local categoryLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  categoryLabel:SetPoint("TOPLEFT", questionLabel, "BOTTOMLEFT", 0, -6)
  categoryLabel:SetText("")
  self.categoryLabel = categoryLabel

  local timerBar = CreateFrame("StatusBar", nil, frame)
  timerBar:SetPoint("TOPLEFT", categoryLabel, "BOTTOMLEFT", 0, -10)
  timerBar:SetSize(320, 16)
  timerBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
  timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  timerBar:SetMinMaxValues(0, TriviaClassic.DEFAULT_TIMER)
  timerBar:SetValue(TriviaClassic.DEFAULT_TIMER)
  self.timerBar = timerBar

  local timerText = timerBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  timerText:SetPoint("LEFT", timerBar, "RIGHT", 8, 0)
  timerText:SetText(string.format("Time: %ds", TriviaClassic.DEFAULT_TIMER))
  self.timerText = timerText

  -- Scoreboard panel
  local sessionLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  sessionLabel:SetPoint("TOPLEFT", questionLabel, "TOPRIGHT", 40, 0)
  sessionLabel:SetText("Current game scores:")

  local sessionBoardBg = CreateFrame("Frame", nil, frame, "InsetFrameTemplate")
  sessionBoardBg:SetPoint("TOPLEFT", sessionLabel, "BOTTOMLEFT", -4, -6)
  sessionBoardBg:SetSize(260, 140)

  local sessionBoard = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  sessionBoard:SetPoint("TOPLEFT", sessionBoardBg, "TOPLEFT", 8, -8)
  sessionBoard:SetWidth(240)
  sessionBoard:SetJustifyH("LEFT")
  sessionBoard:SetJustifyV("TOP")
  sessionBoard:SetText("No answers yet.")
  self.sessionBoard = sessionBoard

  local statusText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  statusText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 16, 16)
  statusText:SetWidth(360)
  statusText:SetJustifyH("LEFT")
  statusText:SetText("Load a set and press Start.")
  frame.statusText = statusText

  local ticker = CreateFrame("Frame", nil, frame)
  ticker:SetScript("OnUpdate", function(_, elapsed)
    self:UpdateTimer(elapsed)
  end)
  self.ticker = ticker

  self:RefreshSetList()
  self:UpdateSessionBoard()

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
    if self.frame:IsShown() then
      self.frame:Hide()
    else
      self.frame:Show()
    end
  end
end
