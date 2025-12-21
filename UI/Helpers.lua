local function trim(text)
  return TriviaClassic_Trim(text)
end

local function createButton(parent, label, width, height, onClick)
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btn:SetSize(width, height)
  btn:SetText(label)
  -- Make button text smaller and allow wrapping/stacking to avoid overflow
  if btn.SetNormalFontObject then
    btn:SetNormalFontObject(GameFontNormalSmall)
  end
  if btn.SetHighlightFontObject then
    btn:SetHighlightFontObject(GameFontHighlightSmall)
  end
  if btn.SetDisabledFontObject and GameFontDisableSmall then
    btn:SetDisabledFontObject(GameFontDisableSmall)
  end
  local fs = btn.GetFontString and btn:GetFontString()
  if fs then
    if fs.SetWordWrap then fs:SetWordWrap(true) end
    if fs.SetMaxLines then fs:SetMaxLines(2) end
    if fs.SetJustifyH then fs:SetJustifyH("CENTER") end
    if fs.SetJustifyV then fs:SetJustifyV("MIDDLE") end
  end
  if onClick then
    btn:SetScript("OnClick", onClick)
  end
  return btn
end

local function createCheckbox(parent, label, yOffset, onClick)
  local check = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
  check:SetPoint("TOPLEFT", 0, yOffset)
  check.Text:SetText(label)
  if onClick then
    check:SetScript("OnClick", function(self) onClick(self:GetChecked()) end)
  end
  return check
end

function TriviaClassic_UI_Trim(text)
  return trim(text)
end

function TriviaClassic_UI_CreateButton(parent, label, width, height, onClick)
  return createButton(parent, label, width, height, onClick)
end

function TriviaClassic_UI_CreateCheckbox(parent, label, yOffset, onClick)
  return createCheckbox(parent, label, yOffset, onClick)
end
