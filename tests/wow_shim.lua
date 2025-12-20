-- Minimal WoW API shim for Lua unit tests

if not _G.GetTime then
  local now = 1000
  function GetTime()
    return now
  end
  function __TC_ADVANCE_TIME(seconds)
    now = now + (seconds or 0)
  end
end

if not _G.date then
  function date(fmt)
    return os.date(fmt)
  end
end

if not _G.__TC_SENT_MESSAGES then
  __TC_SENT_MESSAGES = {}
end

if not _G.SendChatMessage then
  function SendChatMessage(msg, channel, _, target)
    table.insert(__TC_SENT_MESSAGES, { msg = msg, channel = channel, target = target })
  end
end

if not _G.DEFAULT_CHAT_FRAME then
  DEFAULT_CHAT_FRAME = {
    messages = {},
    AddMessage = function(self, msg)
      table.insert(self.messages, msg)
    end,
  }
end

if not _G.JoinChannelByName then
  function JoinChannelByName(_)
    return nil
  end
end

if not _G.GetChannelName then
  function GetChannelName(_)
    return 1
  end
end

if not _G.IsInRaid then
  function IsInRaid()
    return true
  end
end

if not _G.IsInGroup then
  function IsInGroup()
    return true
  end
end

if not _G.CreateFrame then
  function CreateFrame(_)
    local frame = {}
    function frame:RegisterEvent(_) end
    function frame:SetScript(_, _) end
    return frame
  end
end
