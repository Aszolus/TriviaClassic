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
  }
end
