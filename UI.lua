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

local function normalizeCategoryName(name)
  return trim(name or ""):lower()
end

local function formatScoreLines(rows)
  if not rows or #rows == 0 then
    return "No answers yet."
  end
  local lines = {}
  for i, entry in ipairs(rows) do
    if i > 12 then
      break
    end
    local best = entry.bestTime and string.format(" (best %.1fs)", entry.bestTime) or ""
    table.insert(lines, string.format("%d) %s - %d pts (%d correct)%s", i, entry.name, entry.points or 0, entry.correct or 0, best))
  end
  return table.concat(lines, "\n")
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

function UI:UpdateSessionBoard()
  if not self.sessionBoard then
    return
  end
  local rows, fastestName, fastestTime = TriviaClassic:GetSessionScoreboard()
  local text = formatScoreLines(rows)
  if fastestName and fastestTime then
    text = text .. "\nFastest answer: " .. fastestName .. " (" .. string.format("%.2f", fastestTime) .. "s)"
  end
  self.sessionBoard:SetText(text)
end

function UI:ShowSessionScores()
  local rows, fastestName, fastestTime = TriviaClassic:GetSessionScoreboard()
  local chat = TriviaClassic.chat
  chat:Send("[Trivia] Current game scores:")
  if not rows or #rows == 0 then
    chat:Send("[Trivia] No answers yet.")
    return
  end
  for _, entry in ipairs(rows) do
    chat:Send(string.format("[Trivia] %s - %d pts (%d correct, best %.2fs)", entry.name, entry.points or 0, entry.correct or 0, (entry.bestTime or 0)))
  end
  if fastestName and fastestTime then
    chat:Send(string.format("[Trivia] Speed record this game: %s (%.2fs)", fastestName, fastestTime))
  end
end

function UI:ShowAllTimeScores()
  local rows = TriviaClassic:GetLeaderboard(10)
  local chat = TriviaClassic.chat
  chat:Send("[Trivia] All-time scores:")
  if not rows or #rows == 0 then
    chat:Send("[Trivia] No scores recorded.")
    return
  end
  for i, entry in ipairs(rows) do
    chat:Send(string.format("[Trivia] %d) %s - %d pts (%d correct)", i, entry.name, entry.points or 0, entry.correct or 0))
  end
end

function UI:RefreshSetList()
  if not self.setContainer then
    return
  end

  for _, item in ipairs(self.setItems or {}) do
    item:Hide()
  end

  self.setItems = {}
  -- Initialize per-set selection storage if missing
  self.selectedBySet = self.selectedBySet or {}
  local sets = TriviaClassic:GetAllSets()
  local yOffset = 0

  for _, set in ipairs(sets) do
    local title = self.setContainer:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOPLEFT", 0, -yOffset)
    title:SetText(set.title or "Set")
    title:SetJustifyH("LEFT")
    table.insert(self.setItems, title)
    yOffset = yOffset + 18

    if set.categories then
      -- Ensure a bucket exists for this set
      local bucket = self.selectedBySet[set.id]
      if not bucket then
        bucket = { keys = {}, names = {} }
        self.selectedBySet[set.id] = bucket
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
  local total = 0
  for _, set in ipairs(TriviaClassic:GetAllSets()) do
    if set.questions then
      for _, q in ipairs(set.questions) do
        if self:CategorySelected(q.categoryKey or q.category, set.id) then
          total = total + 1
        end
      end
    end
  end
  if self.setCountLabel then
    self.setCountLabel:SetText(string.format("Questions selected: %d", total))
  end
end

function UI:StartGame()
  local selectedIds = {}
  for _, set in ipairs(TriviaClassic:GetAllSets()) do
    table.insert(selectedIds, set.id)
  end

  local desiredCount = tonumber(self.questionCountInput and self.questionCountInput:GetText() or "")
  -- Build per-set categories map for all sets (default-deny when empty)
  local categoriesBySet = {}
  for _, set in ipairs(TriviaClassic:GetAllSets()) do
    categoriesBySet[set.id] = {}
    local bucket = self.selectedBySet and self.selectedBySet[set.id]
    if bucket and bucket.keys then
      for key, checked in pairs(bucket.keys) do
        if checked then categoriesBySet[set.id][key] = true end
      end
    end
  end
  local meta = TriviaClassic:StartGame(selectedIds, desiredCount, categoriesBySet)
  if not meta then
    print("|cffff5050TriviaClassic: No questions available.|r")
    return
  end

  self.nextButton:SetText("Next")
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

  TriviaClassic.chat:SendStart({ total = meta.total, setNames = meta.setNames })
  if self.endButton then
    self.endButton:Enable()
  end
end

function UI:AnnounceQuestion()
  local q, index, total = TriviaClassic:NextQuestion()
  if not q then
    self.frame.statusText:SetText("No more questions. End the game.")
    self.nextButton:SetText("End")
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
  if self.hintButton then
    self.hintButton:Enable()
  end
  self.nextButton:SetText("Waiting...")
  self.nextButton:Disable()
  if self.skipButton then
    self.skipButton:Enable()
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
    self.nextButton:SetText("End")
  else
    self.nextButton:SetText("Next")
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
    self.nextButton:SetText("End")
  else
    self.nextButton:SetText("Next")
  end
  self.nextButton:Enable()
  if self.skipButton then
    self.skipButton:Disable()
  end
end

function UI:EndGame()
  local rows = TriviaClassic:GetSessionScoreboard()
  TriviaClassic.chat:SendEnd(rows)
  TriviaClassic:EndGame()
  self.frame.statusText:SetText("Game ended. Press Start to begin a new game.")
  self.nextButton:SetText("Next")
  self.nextButton:Disable()
  if self.skipButton then
    self.skipButton:Disable()
  end
  self.warningButton:Disable()
  self.timerRunning = false
end

function UI:OnNextPressed()
  if not TriviaClassic:IsGameActive() then
    self.frame.statusText:SetText("Start a game first.")
    return
  end

  if self.nextButton:GetText() == "End" then
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
    self.nextButton:SetText("End")
    return
  end

  self:AnnounceQuestion()
end

function UI:SkipQuestion()
  if not TriviaClassic:IsGameActive() then
    return
  end
  if TriviaClassic:IsQuestionOpen() then
    TriviaClassic:SkipCurrentQuestion()
    TriviaClassic.chat:SendSkipped()
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
    self.nextButton:SetText("Next")
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
  if self.hintButton then
    self.hintButton:Disable()
  end
  self.frame.statusText:SetText(string.format("%s answered correctly in %.2fs. Click 'Announce Winner' to broadcast.", winnerName, elapsed or 0))
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
    if self.hintButton then
      self.hintButton:Disable()
    end
    self.nextButton:SetText("Announce No Winner")
    self.nextButton:Enable()
    self.frame.statusText:SetText("Time expired. Click 'Announce No Winner' to continue.")
    return
  end
  self.timerBar:SetValue(self.timerRemaining)
  if self.timerRemaining <= 5 then
    self.timerBar:SetStatusBarColor(0.9, 0.2, 0.2)
  elseif self.timerRemaining <= 10 then
    self.timerBar:SetStatusBarColor(0.95, 0.7, 0.2)
  else
    self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  end
  self.timerText:SetText(string.format("Time: %ds", math.ceil(self.timerRemaining)))
end

function UI:BuildUI()
  if self.frame then
    self:RefreshSetList()
    self:UpdateSessionBoard()
    return
  end

  self.channelKey = TriviaClassic_GetDefaultChannel()

  local frame = TriviaClassic_UI_BuildLayout(self)
  self:SetChannel(self.channelKey)

  -- Tab switching
  local function showPage(which)
    if which == "options" then
      self.optionsPage:Show()
      self.gamePage:Hide()
      PanelTemplates_SetTab(self.frame, 2)
    else
      self.optionsPage:Hide()
      self.gamePage:Show()
      PanelTemplates_SetTab(self.frame, 1)
    end
  end
  self.tabGame:SetScript("OnClick", function() showPage("game") end)
  self.tabOptions:SetScript("OnClick", function() showPage("options") end)
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

  self.customInput:SetScript("OnEnterPressed", function(box)
    self:SetCustomChannel(box:GetText())
    box:ClearFocus()
  end)
  self.customInput:SetScript("OnEditFocusLost", function(box)
    self:SetCustomChannel(box:GetText())
  end)

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

function UI:AnnounceHint()
  local q = TriviaClassic:GetCurrentQuestion()
  if not q then
    self.frame.statusText:SetText("No active question to hint.")
    return
  end
  local hint = q.hint or (q.hints and q.hints[1])
  if hint and hint ~= "" then
    TriviaClassic.chat:SendHint(hint)
    self.frame.statusText:SetText("Hint announced.")
  else
    self.frame.statusText:SetText("No hint available for this question.")
  end
  if self.hintButton then
    self.hintButton:Disable()
  end
end
