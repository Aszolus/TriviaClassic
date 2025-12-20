function TriviaClassic_CreateWowChatTransport()
  return {
    send = function(msg, entry, customId)
      if entry and entry.key == "CUSTOM" then
        SendChatMessage(msg, "CHANNEL", nil, customId)
      else
        SendChatMessage(msg, entry and (entry.sendKey or entry.key) or "GUILD")
      end
    end,
    system = function(msg)
      if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage(msg)
      end
    end,
    joinChannel = function(name)
      JoinChannelByName(name)
    end,
    getChannelId = function(name)
      local id = GetChannelName(name)
      return id ~= 0 and id or nil
    end,
    isInRaid = function()
      return IsInRaid()
    end,
    isInGroup = function()
      return IsInGroup()
    end,
    getTimer = function()
      if TriviaClassic and TriviaClassic.GetTimer then
        return TriviaClassic:GetTimer()
      end
      return 20
    end,
    getStealTimer = function()
      if TriviaClassic and TriviaClassic.GetStealTimer then
        return TriviaClassic:GetStealTimer()
      end
      return 20
    end,
    log = function(msg)
      print(msg)
    end,
  }
end
