-- Platform chat transport implementation for live WoW.
-- Used by chat module to send questions/announcements and to read timers.
-- Encapsulates SendChatMessage and channel lookups so the rest of the addon
-- can remain UI-agnostic and easier to test.
function TriviaClassic_CreateWowChatTransport()
  return {
    -- Send to the selected channel entry (custom channels need a channel id).
    send = function(msg, entry, customId)
      if entry and entry.key == "CUSTOM" then
        SendChatMessage(msg, "CHANNEL", nil, customId)
      else
        SendChatMessage(msg, entry and (entry.sendKey or entry.key) or "GUILD")
      end
    end,
    -- Prints a local-only system line (no network send).
    system = function(msg)
      if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage(msg)
      end
    end,
    -- Joins a custom channel by name (required before sending to it).
    joinChannel = function(name)
      JoinChannelByName(name)
    end,
    -- Resolves a channel name to an id (nil if not joined).
    getChannelId = function(name)
      local id = GetChannelName(name)
      return id ~= 0 and id or nil
    end,
    -- Group helpers used to gate channel defaults in UI.
    isInRaid = function()
      return IsInRaid()
    end,
    isInGroup = function()
      return IsInGroup()
    end,
    -- Timer getters proxy to the addon settings so chat logic stays stateless.
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
    -- Simple logger hook (used by tests/debug).
    log = function(msg)
      print(msg)
    end,
  }
end
