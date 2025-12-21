local UI = TriviaClassicUI
if not UI then
  UI = {}
  TriviaClassicUI = UI
end

local trim = TriviaClassic_UI_Trim

local function normalizeCategoryName(name)
  return trim(name or ""):lower()
end

local function getAxisLabel()
  local cfg = TriviaClassic:GetGameAxisConfig()
  return TriviaClassic_GetAxisLabel(cfg) or TriviaClassic:GetGameModeLabel()
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
  local desiredCount = tonumber(self.questionCountInput and self.questionCountInput:GetText() or "")
  self:ApplyTimerInput()
  -- Persist selected axis config before starting
  self:SetAxisSelection(self.participationKey, self.flowKey, self.scoringKey, self.attemptKey, self.stealAllowed)
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
  self.frame.statusText:SetText(string.format("Game started (%s). %d questions ready.", meta.modeLabel or getAxisLabel(), meta.total))
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
