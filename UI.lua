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
local gameModes = TriviaClassic_GetGameModes()
local modeLabels = {}
for _, mode in ipairs(gameModes) do
  modeLabels[mode.key] = mode.label
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
local function normalizeName(text)
  return trim(text or ""):gsub("%s+", " ")
end

function UI:RefreshPrimaryButton()
  if not self.nextButton then
    return
  end
  local action = TriviaClassic:GetPrimaryAction()
  local label = (action and action.label) or "Next"
  self.nextButton:SetText(label)
  if action and action.enabled == false then
    self.nextButton:Disable()
  else
    self.nextButton:Enable()
  end
end

function UI:OnPendingSteal(event)
  if not event then
    return
  end
  local teamName = event.teamName or "the next team"
  self.frame.statusText:SetText(string.format("%s can steal. Click the button to offer the steal.", teamName))
  self:RefreshPrimaryButton()
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

function UI:SetGameMode(key)
  local modeKey = modeLabels[key] and key or TriviaClassic_GetDefaultMode()
  self.gameModeKey = modeKey
  if self.modeDropDown then
    UIDropDownMenu_SetSelectedValue(self.modeDropDown, modeKey)
    UIDropDownMenu_SetText(self.modeDropDown, modeLabels[modeKey] or modeKey)
  end
  TriviaClassic:SetGameMode(modeKey)
end

function UI:GetTimerSeconds()
  return TriviaClassic:GetTimer()
end

function UI:GetStealTimerSeconds()
  return TriviaClassic:GetStealTimer()
end

function UI:SetStealTimerSeconds(seconds)
  TriviaClassic:SetStealTimer(seconds)
  self:SyncTimerInput()
end

function UI:SetTimerSeconds(seconds)
  TriviaClassic:SetTimer(seconds)
  self:SyncTimerInput()
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

function UI:ResetTimerDisplay(seconds)
  local secs = tonumber(seconds) or self:GetTimerSeconds()
  self.timerRemaining = secs
  self.timerRunning = false
  if self.timerBar then
    self.timerBar:SetMinMaxValues(0, secs)
    self.timerBar:SetValue(secs)
    self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  end
  if self.timerText then
    self.timerText:SetText(string.format("Time: %ds", secs))
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
  local rows, fastestName, fastestTime = TriviaClassic:GetLeaderboard(5)
  local chat = TriviaClassic.chat
  chat:Send("[Trivia] All-time scores:")
  if not rows or #rows == 0 then
    chat:Send("[Trivia] No scores recorded.")
    return
  end
  for i, entry in ipairs(rows) do
    chat:Send(string.format("[Trivia] %d) %s - %d pts (%d correct)", i, entry.name, entry.points or 0, entry.correct or 0))
  end
  if fastestName and fastestTime then
    chat:Send(string.format("[Trivia] All-time fastest: %s (%.2fs)", fastestName, fastestTime))
  end
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
  local selectedIds = {}
  for _, set in ipairs(TriviaClassic:GetAllSets()) do
    table.insert(selectedIds, set.id)
  end

  local desiredCount = tonumber(self.questionCountInput and self.questionCountInput:GetText() or "")
  self:ApplyTimerInput()
  -- Persist selected mode before starting
  self:SetGameMode(self.gameModeKey or TriviaClassic:GetGameMode())
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

  self:RefreshPrimaryButton()
  if self.skipButton then
    self.skipButton:Enable()
  end
  self.warningButton:Disable()
  self.frame.statusText:SetText(string.format("Game started (%s). %d questions ready.", meta.modeLabel or TriviaClassic:GetGameModeLabel(), meta.total))
  self.questionLabel:SetText("Press Next to announce Question 1.")
  self.categoryLabel:SetText("")
  local timerSeconds = self:GetTimerSeconds()
  self:ResetTimerDisplay(timerSeconds)
  self.timerRunning = false
  self.questionNumber = 0
  self:UpdateSessionBoard()

  TriviaClassic.chat:SendStart(meta)
  if self.endButton then
    self.endButton:Enable()
  end
end

function UI:AnnounceQuestion()
  local result = TriviaClassic:PerformPrimaryAction("announce_question")
  local q = result and result.question
  local index = result and result.index
  local total = result and result.total
  local activeTeamName = nil
  if TriviaClassic:GetGameMode() == "TEAM_STEAL" then
    activeTeamName = select(1, TriviaClassic:GetActiveTeam())
  end
  if not q then
    self.frame.statusText:SetText("No more questions. End the game.")
    self:RefreshPrimaryButton()
    return
  end

  self.questionNumber = index
  self.currentQuestion = q
  self.questionLabel:SetText(string.format("Q%d/%d: %s", index, total, q.question))
  self.categoryLabel:SetText(string.format("Category: %s  |  Points: %s", q.category or "General", tostring(q.points or 1)))
  if activeTeamName then
    self.frame.statusText:SetText(string.format("Question announced. Active team: %s. Listening for answers... (%s)", activeTeamName, TriviaClassic:GetGameModeLabel()))
    self.timerText:SetText(string.format("Time: %ds (Team: %s)", self:GetTimerSeconds(), activeTeamName))
  else
    self.frame.statusText:SetText(string.format("Question announced. Listening for answers... (%s)", TriviaClassic:GetGameModeLabel()))
  end

  local timerSeconds = self:GetTimerSeconds()
  -- Initialize timer service (UI still controls side-effects on expiration)
  self.timerService = TriviaClassic_CreateTimer(timerSeconds)
  self.timerRunning = true
  self.timerBar:SetMinMaxValues(0, timerSeconds)
  self.timerBar:SetValue(timerSeconds)
  self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  self.timerText:SetText(string.format("Time: %ds", timerSeconds))
  self.warningButton:Enable()
  if self.hintButton then
    -- Enable hint button only if this question actually has a hint
    local hint = q.hint or (q.hints and q.hints[1])
    if hint and hint ~= "" then
      self.hintButton:Enable()
    else
      self.hintButton:Disable()
    end
  end
  if self.skipButton then
    self.skipButton:Enable()
  end

  TriviaClassic.chat:SendQuestion(index, total, q, activeTeamName)
  self:RefreshPrimaryButton()
end

function UI:StartSteal()
  local result = TriviaClassic:PerformPrimaryAction("start_steal")
  local teamName = result and result.teamName
  local q = result and result.question or TriviaClassic:GetCurrentQuestion()
  local activeLabel = teamName or "Next team"
  if not q then
    self.frame.statusText:SetText("No question available to steal.")
    self:RefreshPrimaryButton()
    return
  end
  self.currentQuestion = q
  self.frame.statusText:SetText(string.format("%s can steal. Listening for answers...", activeLabel))
  local timerSeconds = self:GetTimerSeconds()
  if TriviaClassic:GetGameMode() == "TEAM_STEAL" then
    timerSeconds = TriviaClassic:GetStealTimer()
  end
  self.timerRemaining = timerSeconds
  self.timerRunning = true
  self.timerBar:SetMinMaxValues(0, timerSeconds)
  self.timerBar:SetValue(timerSeconds)
  self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  self.timerText:SetText(string.format("Time: %ds (Steal)", timerSeconds))
  self.warningButton:Enable()
  if self.hintButton then
    local hint = q.hint or (q.hints and q.hints[1])
    if hint and hint ~= "" then
      self.hintButton:Enable()
    else
      self.hintButton:Disable()
    end
  end
  if self.skipButton then
    self.skipButton:Enable()
  end
  TriviaClassic.chat:SendSteal(teamName, q, timerSeconds)
  -- Provide a reminder in chat for clarity
  TriviaClassic.chat:SendActiveTeamReminder(activeLabel)
  self:RefreshPrimaryButton()
end

function UI:AnnounceWinner()
  if not TriviaClassic:IsPendingWinner() then
    return
  end
  local mode = TriviaClassic:GetGameMode()
  if mode == "ALL_CORRECT" then
    self.timerRunning = false
    local winners = TriviaClassic:GetPendingWinners()
    local q = TriviaClassic:GetCurrentQuestion()
    if winners and #winners > 0 then
      TriviaClassic.chat:SendWinners(winners, q, mode)
      self.frame.statusText:SetText("Results announced. Click Next for the next question.")
    else
      self:AnnounceNoWinner()
      return
    end
    local result = TriviaClassic:PerformPrimaryAction("announce_winner")
    local finished = result and result.finished
    if finished then
      self.frame.statusText:SetText("Results announced. Click End to finish.")
    end
    self.nextButton:Enable()
    if self.skipButton then
      self.skipButton:Disable()
    end
    self:UpdateSessionBoard()
    self:RefreshPrimaryButton()
    return
  end

  local winnerName, elapsed, teamName, teamMembers = TriviaClassic:GetLastWinner()
  if not winnerName then
    return
  end
  local q = TriviaClassic:GetCurrentQuestion()
  TriviaClassic.chat:SendWinner(winnerName, elapsed or 0, q and q.points, teamName, teamMembers)
  if teamName then
    local memberText = (teamMembers and #teamMembers > 0) and (" (" .. table.concat(teamMembers, ", ") .. ")") or ""
    self.frame.statusText:SetText(string.format("%s answered correctly in %.2fs. Click Next for the next question.", teamName .. memberText, elapsed or 0))
  else
    self.frame.statusText:SetText("Winner announced. Click Next for the next question.")
  end
  TriviaClassic:PerformPrimaryAction("announce_winner")
  self.nextButton:Enable()
  if self.skipButton then
    self.skipButton:Disable()
  end
  self:RefreshPrimaryButton()
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
  TriviaClassic:PerformPrimaryAction("announce_no_winner")
  self.nextButton:Enable()
  if self.skipButton then
    self.skipButton:Disable()
  end
  self:RefreshPrimaryButton()
end

function UI:EndGame()
  local rows, fastestName, fastestTime = TriviaClassic:GetSessionScoreboard()
  TriviaClassic.chat:SendEnd(rows, fastestName, fastestTime)
  TriviaClassic:EndGame()
  self.frame.statusText:SetText("Game ended. Press Start to begin a new game.")
  self:RefreshPrimaryButton()
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

  local action = TriviaClassic:GetPrimaryAction()
  if not action or action.command == "waiting" or action.command == "wait" or action.enabled == false then
    self.frame.statusText:SetText("A question is already active.")
    return
  end

  if action.command == "announce_question" then
    self:AnnounceQuestion()
  elseif action.command == "announce_winner" then
    self:AnnounceWinner()
    self:UpdateSessionBoard()
  elseif action.command == "announce_no_winner" then
    self:AnnounceNoWinner()
  elseif action.command == "end_game" then
    self:EndGame()
  elseif action.command == "start_steal" then
    self:StartSteal()
  end
  self:RefreshPrimaryButton()
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
    self:RefreshPrimaryButton()
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

function UI:OnWinnerFound(result)
  if not result then
    return
  end
  local winnerName = result.winner
  local elapsed = result.elapsed
  local mode = result.mode or TriviaClassic:GetGameMode()
  local teamName = result.teamName
  local teamMembers = result.teamMembers
  if mode == "ALL_CORRECT" then
    local total = result.totalWinners or 1
    local suffix = (total == 1) and "" or "s"
    self.frame.statusText:SetText(string.format("%s answered correctly in %.2fs. %d player%s credited so far; waiting until time expires.", winnerName or "Someone", elapsed or 0, total, suffix))
    self:UpdateSessionBoard()
    return
  end

  self.timerRunning = false
  self.warningButton:Disable()
  if self.hintButton then
    self.hintButton:Disable()
  end
  if teamName then
    local memberText = (teamMembers and #teamMembers > 0) and (" (" .. table.concat(teamMembers, ", ") .. ")") or ""
    self.frame.statusText:SetText(string.format("%s answered correctly in %.2fs. Click 'Announce Winner' to broadcast.", teamName .. memberText, elapsed or 0))
  else
    self.frame.statusText:SetText(string.format("%s answered correctly in %.2fs. Click 'Announce Winner' to broadcast.", winnerName, elapsed or 0))
  end
  self:RefreshPrimaryButton()
  if self.skipButton then
    self.skipButton:Disable()
  end
  self:UpdateSessionBoard()
end

function UI:UpdateTimer(elapsed)
  if not self.timerRunning then
    return
  end
  local snap = self.timerService and self.timerService:Tick(elapsed) or { remaining = 0, expired = true, color = "red" }
  if snap.expired then
    self.timerRunning = false
    TriviaClassic:MarkTimeout()
    self.timerBar:SetValue(0)
    self.timerText:SetText("Time: 0s")
    self.timerBar:SetStatusBarColor(0.7, 0.1, 0.1)
    self.warningButton:Disable()
    if self.hintButton then self.hintButton:Disable() end
    if self.skipButton then self.skipButton:Disable() end
    local action = TriviaClassic:GetPrimaryAction()
    if action and action.command == "start_steal" then
      self.frame.statusText:SetText("Time expired. Offer a steal to the next team.")
    elseif TriviaClassic:IsPendingWinner() then
      self.frame.statusText:SetText("Time expired. Announce results for this question.")
    else
      self.frame.statusText:SetText("Time expired. Click 'Announce No Winner' to continue.")
    end
    self:RefreshPrimaryButton()
    return
  end
  self.timerBar:SetValue(snap.remaining)
  if snap.color == "red" then
    self.timerBar:SetStatusBarColor(0.9, 0.2, 0.2)
  elseif snap.color == "orange" then
    self.timerBar:SetStatusBarColor(0.95, 0.7, 0.2)
  else
    self.timerBar:SetStatusBarColor(0.2, 0.8, 0.2)
  end
  self.timerText:SetText(string.format("Time: %ds", math.ceil(snap.remaining)))
end

function UI:BuildUI()
  if self.frame then
    self.gameModeKey = TriviaClassic:GetGameMode()
    if self.modeDropDown then
      UIDropDownMenu_SetSelectedValue(self.modeDropDown, self.gameModeKey)
      UIDropDownMenu_SetText(self.modeDropDown, modeLabels[self.gameModeKey] or self.gameModeKey)
    end
    self:SyncTimerInput()
    self:ResetTimerDisplay(self:GetTimerSeconds())
    self:RefreshSetList()
    self:UpdateSessionBoard()
    self:UpdateTeamUI()
    self:RefreshPrimaryButton()
    return
  end

  self.channelKey = TriviaClassic_GetDefaultChannel()
  self.gameModeKey = TriviaClassic:GetGameMode()
  self.selectedWaiting = {}
  self.selectedMembers = {}

  local frame = TriviaClassic_UI_BuildLayout(self)
  self:SetChannel(self.channelKey)

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
    self.teamsPage:Hide()
    if which == "options" then
      self.optionsPage:Show()
      PanelTemplates_SetTab(self.frame, 2)
    elseif which == "teams" then
      self.teamsPage:Show()
      PanelTemplates_SetTab(self.frame, 3)
    else
      self.gamePage:Show()
      PanelTemplates_SetTab(self.frame, 1)
    end
  end
  self.tabGame:SetScript("OnClick", function() showPage("game") end)
  self.tabOptions:SetScript("OnClick", function() showPage("options") end)
  self.tabTeams:SetScript("OnClick", function() showPage("teams") end)
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

  UIDropDownMenu_SetSelectedValue(self.modeDropDown, self.gameModeKey)
  UIDropDownMenu_SetText(self.modeDropDown, modeLabels[self.gameModeKey] or self.gameModeKey)
  UIDropDownMenu_Initialize(self.modeDropDown, function(_, _, _)
    for _, mode in ipairs(gameModes) do
      local info = UIDropDownMenu_CreateInfo()
      info.text = mode.label
      info.value = mode.key
      info.func = function()
        UIDropDownMenu_SetSelectedValue(self.modeDropDown, mode.key)
        self:SetGameMode(mode.key)
      end
      info.checked = (self.gameModeKey == mode.key)
      UIDropDownMenu_AddButton(info)
    end
  end)

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
