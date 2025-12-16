--- Renders a simple checkbox list into a frame, reusing row frames.
---@param listFrame Frame
---@param items string[]
---@param pool table|nil Existing row frame pool (reused if provided)
---@param selectedMap table<string, boolean>|nil Map of item -> checked
---@return table pool Updated pool to keep around for reuse
function TriviaClassic_UI_RenderSelectableList(listFrame, items, pool, selectedMap)
  pool = pool or {}
  selectedMap = selectedMap or {}
  local y = 0
  for i, name in ipairs(items) do
    local row = pool[i]
    if not row then
      row = CreateFrame("CheckButton", nil, listFrame, "ChatConfigCheckButtonTemplate")
      pool[i] = row
    end
    row:Show()
    row:SetPoint("TOPLEFT", 0, -y)
    row.Text:SetText(name)
    row:SetChecked(selectedMap[name] or false)
    row:SetScript("OnClick", function(selfBtn)
      if selfBtn:GetChecked() then
        selectedMap[name] = true
      else
        selectedMap[name] = nil
      end
    end)
    y = y + 20
  end
  for i = #items + 1, #pool do
    if pool[i] then pool[i]:Hide() end
  end
  if listFrame.SetHeight then
    listFrame:SetHeight(math.max(1, y))
  end
  return pool
end

