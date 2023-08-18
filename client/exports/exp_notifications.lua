--============================= NOTIFICATION EXPORTS ==========================================--

exports("DisplayTip", function(text, duration)
  VorpNotification:NotifyTip(tostring(text), tonumber(duration))
end)

exports("DisplayLeftNotification", function(title, subTitle, dict, icon, duration, color)
  VorpNotification:NotifyLeft(tostring(title), tostring(subTitle), tostring(dict), tostring(icon), tonumber(duration),
    (tostring(color) or "COLOR_WHITE"))
end) 

exports("DisplayTopCenterNotification", function(text, location, duration)
  VorpNotification:NotifyTop(tostring(text), tostring(location), tonumber(duration))
end)

exports("DisplayTipRight", function(text, duration)
  VorpNotification:NotifyRightTip(tostring(text), tonumber(duration))
end)

exports("DisplayObjective", function(text, duration)
  VorpNotification:NotifyObjective(tostring(text), tonumber(duration))
end)

exports("ShowTopNotification", function(title, subtext, duration)
  VorpNotification:NotifySimpleTop(tostring(title), tostring(subtext), tonumber(duration))
end)

exports("ShowAdvancedRightNotification", function(_text, _dict, icon, text_color, duration, quality, showquality)
  VorpNotification:NotifyAvanced(tostring(_text), tostring(_dict), tostring(icon), tostring(text_color),
    tonumber(duration), quality, showquality)
end)

exports("ShowBasicTopNotification", function(text, duration)
  VorpNotification:NotifyBasicTop(tostring(text), tonumber(duration))
end)
 
exports("ShowSimpleCenterText", function(text, duration, text_color)
  VorpNotification:NotifyCenter(tostring(text), tonumber(duration), tostring(text_color))
end)

exports("showBottomRight", function(text, duration)
  VorpNotification:NotifyBottomRight(tostring(text), tonumber(duration))
end)

exports("failmissioNotifY", function(title, subTitle, duration)
  VorpNotification:NotifyFail(tostring(title), tostring(subTitle), tonumber(duration))
end)

exports("deadplayerNotifY", function(title, _audioRef, _audioName, duration)
  VorpNotification:NotifyDead(tostring(title), tostring(_audioRef), tostring(_audioName), tonumber(duration))
end)

exports("updatemissioNotify", function(utitle, umsg, duration)
  VorpNotification:NotifyUpdate(tostring(utitle), tostring(umsg), tonumber(duration))
end)

exports("warningNotify", function(title, msg, _audioRef, _audioName, duration)
  VorpNotification:NotifyWarning(tostring(title), tostring(msg), tostring(_audioRef), tostring(_audioName),
    tonumber(duration))
end)

exports("LeftRank", function(title, subTitle, dict, icon, duration, color)
  VorpNotification:NotifyLeftRank(tostring(title), tostring(subTitle), tostring(dict), tostring(icon), tonumber(duration),
    (tostring(color)))
end)