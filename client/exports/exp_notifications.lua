--============================= NOTIFICATION EXPORTS ==========================================--

exports("DisplayTip", function(text, duration)
  VorpNotification:DisplayTip(tostring(text), tonumber(duration))
end)

exports("DisplayLeftNotification", function(title, subTitle, dict, icon, duration, color)
  VorpNotification:NotifyLeft(tostring(title), tostring(subTitle), tostring(dict), tostring(icon), tonumber(duration),
    (tostring(color) or "COLOR_WHITE"))
end)

exports("DisplayTopCenterNotification", function(text, location, duration)
  VorpNotification:DisplayTopCenter(tostring(text), tostring(location), tonumber(duration))
end)

exports("DisplayTipRight", function(text, duration)
  VorpNotification:DisplayTipRight(tostring(text), tonumber(duration))
end)

exports("DisplayObjective", function(text, duration)
  VorpNotification:DisplayObjective(tostring(text), tonumber(duration))
end)

exports("ShowTopNotification", function(title, subtext, duration)
  VorpNotification:ShowTopNotification(tostring(title), tostring(subtext), tonumber(duration))
end)

exports("ShowAdvancedRightNotification", function(_text, _dict, icon, text_color, duration, quality, showquality)
  VorpNotification:ShowAdvancedRightNotification(tostring(_text), tostring(_dict), tostring(icon), tostring(text_color),
    tonumber(duration), quality, showquality)
end)

exports("ShowBasicTopNotification", function(text, duration)
  VorpNotification:ShowBasicTopNotification(tostring(text), tonumber(duration))
end)

exports("ShowSimpleCenterText", function(text, duration, text_color)
  VorpNotification:ShowSimpleCenterText(tostring(text), tonumber(duration), tostring(text_color))
end)

exports("showBottomRight", function(text, duration)
  VorpNotification:ShowBottomRight(tostring(text), tonumber(duration))
end)

exports("failmissioNotifY", function(title, subTitle, duration)
  VorpNotification:ShowFailedMission(tostring(title), tostring(subTitle), tonumber(duration))
end)

exports("deadplayerNotifY", function(title, _audioRef, _audioName, duration)
  VorpNotification:ShowDeadPlayer(tostring(title), tostring(_audioRef), tostring(_audioName), tonumber(duration))
end)

exports("updatemissioNotify", function(utitle, umsg, duration)
  VorpNotification:ShowUpdateMission(tostring(utitle), tostring(umsg), tonumber(duration))
end)

exports("warningNotify", function(title, msg, _audioRef, _audioName, duration)
  VorpNotification:ShowWarning(tostring(title), tostring(msg), tostring(_audioRef), tostring(_audioName),
    tonumber(duration))
end)

exports("LeftRank", function(title, subTitle, dict, icon, duration, color)
  VorpNotification:LeftRank(tostring(title), tostring(subTitle), tostring(dict), tostring(icon), tonumber(duration),
    (tostring(color)))
end)