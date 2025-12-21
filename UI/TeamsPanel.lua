local UI = TriviaClassicUI
if not UI then
  UI = {}
  TriviaClassicUI = UI
end

local trim = TriviaClassic_UI_Trim

local function normalizeName(text)
  return trim(text or ""):gsub("%s+", " ")
end

function UI:SetSelectedTeam(teamKey)
  self.selectedTeamKey = teamKey
  self.selectedMembers = {}
  if self.teamTargetDropDown then
    UIDropDownMenu_SetSelectedValue(self.teamTargetDropDown, teamKey)
    UIDropDownMenu_SetText(self.teamTargetDropDown, self.teamNameByKey and self.teamNameByKey[teamKey] or (teamKey or "Select team"))
  end
  self:RefreshTeamMembers()
end

function UI:RefreshTeamDropdown()
  local teams = TriviaClassic:GetTeams() or {}
  self.teamNameByKey = {}
  self.teamDataByKey = {}
  for _, t in ipairs(teams) do
    self.teamNameByKey[t.key] = t.name
    self.teamDataByKey[t.key] = t
  end
  local current = self.selectedTeamKey
  if not current and teams[1] then
    current = teams[1].key
  end
  UIDropDownMenu_Initialize(self.teamTargetDropDown, function()
    for _, t in ipairs(teams) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = t.name
      info.value = t.key
      info.func = function()
        self:SetSelectedTeam(t.key)
      end
      info.checked = (self.selectedTeamKey == t.key)
      UIDropDownMenu_AddButton(info)
    end
  end)
  self:SetSelectedTeam(current)
end

function UI:RefreshTeamList()
  if not self.teamList then
    return
  end
  local teams = TriviaClassic:GetTeams() or {}
  local lines = {}
  for _, team in ipairs(teams) do
    local members = team.members or {}
    table.sort(members, function(a, b) return a:lower() < b:lower() end)
    local memberText = (#members > 0) and table.concat(members, ", ") or "No members yet"
    table.insert(lines, string.format("|cffffff00%s|r: %s", team.name, memberText))
  end
  if #lines == 0 then
    self.teamList:SetText("No teams yet. Add a team to get started.")
  else
    self.teamList:SetText(table.concat(lines, "\n"))
  end
end

function UI:RefreshWaitingList()
  if not self.waitingContent then
    return
  end
  local waiting = TriviaClassic:GetWaitingPlayers() or {}
  table.sort(waiting, function(a, b) return a:lower() < b:lower() end)
  self.waitingNames = waiting
  self.selectedWaiting = self.selectedWaiting or {}
  self.waitingRows = TriviaClassic_UI_RenderSelectableList(self.waitingContent, waiting, self.waitingRows or {}, self.selectedWaiting)
  if self.waitingStatus then
    if #waiting == 0 then
      self.waitingStatus:SetText("No registered players yet.")
    else
      self.waitingStatus:SetText("Select players to move to a team.")
    end
  end
end

function UI:RefreshTeamMembers()
  if not self.memberContent then
    return
  end
  local members = {}
  local teams = self.teamDataByKey or {}
  local team = self.selectedTeamKey and teams[self.selectedTeamKey] or nil
  if team and team.members then
    for _, m in ipairs(team.members) do
      table.insert(members, m)
    end
  end
  table.sort(members, function(a, b) return a:lower() < b:lower() end)
  self.selectedMembers = self.selectedMembers or {}
  self.memberRows = TriviaClassic_UI_RenderSelectableList(self.memberContent, members, self.memberRows or {}, self.selectedMembers)
  if self.memberStatus then
    if not self.selectedTeamKey then
      self.memberStatus:SetText("Select a team to manage members.")
    elseif #members == 0 then
      self.memberStatus:SetText("No members in this team.")
    else
      self.memberStatus:SetText("Select members to remove or reassign.")
    end
  end
end

function UI:UpdateTeamUI()
  if not self.teamTargetDropDown then
    return
  end
  self:RefreshTeamDropdown()
  self:RefreshTeamList()
  self:RefreshWaitingList()
  self:RefreshTeamMembers()
end

function UI:AddTeam()
  local name = normalizeName(self.teamNameInput and self.teamNameInput:GetText() or "")
  if name == "" then
    if self.teamStatus then self.teamStatus:SetText("|cffff5050Enter a team name.|r") end
    return
  end
  TriviaClassic:AddTeam(name)
  if self.teamNameInput then self.teamNameInput:SetText("") end
  if self.teamStatus then self.teamStatus:SetText("|cff20ff20Team added.|r") end
  self:UpdateTeamUI()
end

function UI:RemoveTeam()
  if not self.selectedTeamKey then
    if self.teamStatus then self.teamStatus:SetText("|cffff5050Select a team to remove.|r") end
    return
  end
  local teamName = self.teamNameByKey and self.teamNameByKey[self.selectedTeamKey] or self.selectedTeamKey
  TriviaClassic:RemoveTeam(teamName)
  self.selectedTeamKey = nil
  if self.teamStatus then self.teamStatus:SetText("|cff20ff20Team removed.|r") end
  self:UpdateTeamUI()
end

function UI:MoveWaitingToTeam()
  local selections = self.selectedWaiting or {}
  if not self.selectedTeamKey then
    if self.teamStatus then self.teamStatus:SetText("|cffff5050Select a team first.|r") end
    return
  end
  local hasSelection = false
  for _ in pairs(selections) do hasSelection = true break end
  if not hasSelection then
    if self.teamStatus then self.teamStatus:SetText("|cffff5050Select at least one registered player.|r") end
    return
  end
  local teamName = self.teamNameByKey and self.teamNameByKey[self.selectedTeamKey] or self.selectedTeamKey
  for name in pairs(selections) do
    TriviaClassic:AddPlayerToTeam(name, teamName)
    TriviaClassic:UnregisterPlayer(name)
  end
  if self.teamStatus then self.teamStatus:SetText("|cff20ff20Moved selected players to team.|r") end
  self.selectedWaiting = {}
  self:UpdateTeamUI()
end

function UI:RemoveWaiting()
  local selections = self.selectedWaiting or {}
  local hasSelection = false
  for _ in pairs(selections) do hasSelection = true break end
  if not hasSelection then
    if self.teamStatus then self.teamStatus:SetText("|cffff5050Select registered players to remove.|r") end
    return
  end
  for name in pairs(selections) do
    TriviaClassic:UnregisterPlayer(name)
  end
  if self.teamStatus then self.teamStatus:SetText("|cff20ff20Removed selected registrations.|r") end
  self.selectedWaiting = {}
  self:UpdateTeamUI()
end

function UI:RemoveMembersToWaiting()
  local selections = self.selectedMembers or {}
  if not self.selectedTeamKey then
    if self.teamStatus then self.teamStatus:SetText("|cffff5050Select a team first.|r") end
    return
  end
  local hasSelection = false
  for _ in pairs(selections) do hasSelection = true break end
  if not hasSelection then
    if self.teamStatus then self.teamStatus:SetText("|cffff5050Select team members to move.|r") end
    return
  end
  for name in pairs(selections) do
    TriviaClassic:RemovePlayerFromTeam(name)
    TriviaClassic:RegisterPlayer(name)
  end
  self.selectedMembers = {}
  if self.teamStatus then self.teamStatus:SetText("|cff20ff20Moved selected members back to registered list.|r") end
  self:UpdateTeamUI()
end
