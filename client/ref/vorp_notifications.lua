VorpNotification = setmetatable({}, VorpNotification)
VorpNotification.__index = VorpNotification
VorpNotification.__call = function()
  return 'VorpNotifications'
end

---VorpNotifications can be used to display notifications on the screen. You can reference this file in your resource manifest to ensure the VorpNotifications API resource is started before your own resource.
---VorpNotifications is a singleton class that should be accessed using the global variable VorpNotifications.
---You can reference this in your fxmanifest.lua using the following code: client_script '@vorp-core/client/ref/vorp_notifications.lua'

---@class VorpNotifications
---@field public NotifyLeft fun(title: string, subTitle: string, dict: string, icon: string, duration?: string, color?: string): nil
---@field public DisplayTip fun(tipMessage: string, duration?: string): nil
---@field public DisplayTopCenter fun(message: string, location: string, duration?: string): nil
---@field public DisplayTipRight fun(tipMessage: string, duration?: string): nil
---@field public DisplayObjective fun(message: string, duration?: string): nil
---@field public ShowTopNotification fun(title: string, subtext: string, duration?: string): nil
---@field public ShowAdvancedRightNotification fun(text: string, dict: string, icon: string, text_color: string, duration?: string, quality?: string, showquality?: string): nil
---@field public ShowBasicTopNotification fun(text: string, duration?: string): nil
---@field public ShowSimpleCenterText fun(text: string, duration?: string, text_color?: string): nil
---@field public ShowBottomRight fun(text: string, duration?: string): nil
---@field public ShowFailedMission fun(title: string, subTitle: string, duration?: string): nil
---@field public ShowDeadPlayer fun(title: string, _audioRef: string, _audioName: string, duration?: string): nil
---@field public ShowUpdateMission fun(utitle: string, umsg: string, duration?: string): nil
---@field public ShowWarning fun(title: string, msg: string, _audioRef: string, _audioName: string, duration?: string): nil

---NotifyLeft
---@param title string
---@param subtitle string
---@param dict string
---@param icon string
---@param duration? number -- default 3000
---@param color? string -- default COLOR_WHITE
function VorpNotification:NotifyLeft(title, subtitle, dict, icon, duration, color)
  LoadTexture(dict)

  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

  local structData = DataView.ArrayBuffer(8 * 8)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", title)))
  structData:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", subtitle)))
  structData:SetInt32(8 * 3, 0)
  structData:SetInt64(8 * 4, bigInt(joaat(dict)))
  structData:SetInt64(8 * 5, bigInt(joaat(icon)))
  structData:SetInt64(8 * 6, bigInt(joaat(color or "COLOR_WHITE")))

  Citizen.InvokeNative(0x26E87218390E6729, structConfig:Buffer(), structData:Buffer(), 1, 1)
end

---DisplayTip
---@param tipMessage string
---@param duration? number -- default 3000
function VorpNotification:DisplayTip(tipMessage, duration)
  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  structConfig:SetInt32(8 * 1, 0)
  structConfig:SetInt32(8 * 2, 0)
  structConfig:SetInt32(8 * 3, 0)

  local structData = DataView.ArrayBuffer(8 * 3)
  structData:SetUint64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", tipMessage)))

  Citizen.InvokeNative(0x049D5C615BD38BAD, structConfig:Buffer(), structData:Buffer(), 1)
end

---DisplayTopCenter
---@param message string
---@param location string
---@param duration? number -- default 3000
function VorpNotification:DisplayTopCenter(message, location, duration)
  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

  local structData = DataView.ArrayBuffer(8 * 5)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", location)))
  structData:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", message)))

  Citizen.InvokeNative(0xD05590C1AB38F068, structConfig:Buffer(), structData:Buffer(), 0, 1)
end

---DisplayTipRight
---@param tipMessage string
---@param duration? number -- default 3000
function VorpNotification:DisplayTipRight(tipMessage, duration)
  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

  local structData = DataView.ArrayBuffer(8 * 3)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", tipMessage)))

  Citizen.InvokeNative(0xB2920B9760F0F36B, structConfig:Buffer(), structData:Buffer(), 1)
end

---DisplayObjective
---@param message string
---@param duration? number -- default 3000
function VorpNotification:DisplayObjective(message, duration)
  Citizen.InvokeNative("0xDD1232B332CBB9E7", 3, 1, 0)

  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

  local structData = DataView.ArrayBuffer(8 * 3)
  local strMessage = CreateVarString(10, "LITERAL_STRING", message)
  structData:SetInt64(8 * 1, bigInt(strMessage))

  Citizen.InvokeNative(0xCEDBF17EFCC0E4A4, structConfig:Buffer(), structData:Buffer(), 1)
end

---ShowTopNotification
---@param title string
---@param subtitle string
---@param duration? number -- default 3000
function VorpNotification:ShowTopNotification(title, subtitle, duration)
  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

  local structData = DataView.ArrayBuffer(8 * 7)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", title)))
  structData:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", subtitle)))

  Citizen.InvokeNative(0xA6F4216AB10EB08E, structConfig:Buffer(), structData:Buffer(), 1, 1)
end

---ShowAdvancedRightNotification
---@param text string
---@param dict string
---@param icon string
---@param text_color string
---@param duration? number -- default 3000
---@param quality? number -- default 1
---@param showquality? boolean -- default false
function VorpNotification:ShowAdvancedRightNotification(text, dict, icon, text_color, duration, quality, showquality)
  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  structConfig:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", "Transaction_Feed_Sounds")))
  structConfig:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", "Transaction_Positive")))

  local structData = DataView.ArrayBuffer(8 * 10)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", text)))
  structData:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", dict)))
  structData:SetInt64(8 * 3, bigInt(joaat(CreateVarString(10, "LITERAL_STRING", icon))))
  structData:SetInt64(8 * 5, bigInt(joaat(CreateVarString(10, "LITERAL_STRING", text_color))))
  if showquality then
    structData:SetInt32(8 * 6, quality or 1)
  end

  Citizen.InvokeNative(0xB249EBCB30DD88E0, structConfig:Buffer(), structData:Buffer(), 1)
end

---ShowBasicTopNotification
---@param text string
---@param duration? number -- default 3000
function VorpNotification:ShowBasicTopNotification(text, duration)
  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

  local structData = DataView.ArrayBuffer(8 * 7)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", text)))

  Citizen.InvokeNative(0x7AE0589093A2E088, structConfig:Buffer(), structData:Buffer(), 1)
end

---ShowSimpleCenterText
---@param text string
---@param duration? number -- default 3000
---@param text_color? string -- default COLOR_PURE_WHITE
function VorpNotification:ShowSimpleCenterText(text, duration, text_color)
  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

  local structData = DataView.ArrayBuffer(8 * 4)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", text)))
  structData:SetInt64(8 * 2, bigInt(joaat(text_color or "COLOR_PURE_WHITE")))

  Citizen.InvokeNative(0x893128CDB4B81FBB, structConfig:Buffer(), structData:Buffer(), 1)
end

---ShowBottomRight
---@param text string
---@param duration? number -- default 3000
function VorpNotification:ShowBottomRight(text, duration)
  local structConfig = DataView.ArrayBuffer(8 * 7)
  structConfig:SetInt32(8 * 0, tonumber(duration or 3000))

  local structData = DataView.ArrayBuffer(8 * 5)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", text)))

  Citizen.InvokeNative(0x2024F4F333095FB1, structConfig:Buffer(), structData:Buffer(), 1)
end

---ShowFailedMission
---@param title string
---@param subtitle string
---@param duration? number -- default 3000
function VorpNotification:ShowFailedMission(title, subtitle, duration)
  local structConfig = DataView.ArrayBuffer(8 * 5)

  local structData = DataView.ArrayBuffer(8 * 9)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", title)))
  structData:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", subtitle)))

  local result = Citizen.InvokeNative(0x9F2CC2439A04E7BA, structConfig:Buffer(), structData:Buffer(), 1)

  Wait(duration or 3000)

  Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
end

---ShowDeadPlayer
---@param title string
---@param audioRef string
---@param audioName string
---@param duration? number -- default 3000
function VorpNotification:ShowDeadPlayer(title, audioRef, audioName, duration)
  local structConfig = DataView.ArrayBuffer(8 * 5)

  local structData = DataView.ArrayBuffer(8 * 9)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", title)))
  structData:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", audioRef)))
  structData:SetInt64(8 * 3, bigInt(CreateVarString(10, "LITERAL_STRING", audioName)))

  local result = Citizen.InvokeNative(0x815C4065AE6E6071, structConfig:Buffer(), structData:Buffer(), 1)

  Wait(duration or 3000)

  Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
end

---ShowUpdateMission
---@param title string
---@param message string
---@param duration? number -- default 3000
function VorpNotification:ShowUpdateMission(title, message, duration)
  local structConfig = DataView.ArrayBuffer(8 * 5)

  local structData = DataView.ArrayBuffer(8 * 9)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", title)))
  structData:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", message)))

  local result = Citizen.InvokeNative(0x339E16B41780FC35, structConfig:Buffer(), structData:Buffer(), 1)

  Wait(duration or 3000)

  Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
end

---ShowWarning
---@param title string
---@param message string
---@param audioRef string
---@param audioName string
---@param duration? number -- default 3000
function VorpNotification:ShowWarning(title, message, audioRef, audioName, duration)
  local structConfig = DataView.ArrayBuffer(8 * 5)

  local structData = DataView.ArrayBuffer(8 * 9)
  structData:SetInt64(8 * 1, bigInt(CreateVarString(10, "LITERAL_STRING", title)))
  structData:SetInt64(8 * 2, bigInt(CreateVarString(10, "LITERAL_STRING", message)))
  structData:SetInt64(8 * 3, bigInt(CreateVarString(10, "LITERAL_STRING", audioRef)))
  structData:SetInt64(8 * 4, bigInt(CreateVarString(10, "LITERAL_STRING", audioName)))

  local result = Citizen.InvokeNative(0x339E16B41780FC35, structConfig:Buffer(), structData:Buffer(), 1)

  Wait(duration or 3000)

  Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
end

---Test function to test all notifications
---@return nil
function VorpNotification:Test()
  local testText = "This is a test notification"
  local testDuration = 3000
  local testWaitDuration = 4000
  local testDict = "generic_textures"
  local testIcon = "tick"
  local testColor = "COLOR_WHITE"
  local testLocation = "top_center"

  VorpNotification:NotifyLeft(testText, testText, testDict, testIcon, testDuration, testColor)
  Wait(testWaitDuration)
  VorpNotification:DisplayTip(testText, testDuration)
  Wait(testWaitDuration)
  VorpNotification:DisplayTopCenter(testText, testLocation, testDuration)
  Wait(testWaitDuration)
  VorpNotification:DisplayTipRight(testText, testDuration)
  Wait(testWaitDuration)
  VorpNotification:DisplayObjective(testText, testDuration)
  Wait(testWaitDuration)
  VorpNotification:ShowTopNotification(testText, testText, testDuration)
  Wait(testWaitDuration)
  VorpNotification:ShowAdvancedRightNotification(testText, testDict, testIcon, testColor, testDuration)
  Wait(testWaitDuration)
  VorpNotification:ShowBasicTopNotification(testText, testDuration)
  Wait(testWaitDuration)
  VorpNotification:ShowSimpleCenterText(testText, testDuration, testColor)
  Wait(testWaitDuration)
  VorpNotification:ShowBottomRight(testText, testDuration)
  Wait(testWaitDuration)
  VorpNotification:ShowFailedMission(testText, testText, testDuration)
  Wait(testWaitDuration)
  VorpNotification:ShowDeadPlayer(testText, testDict, testIcon, testDuration)
  Wait(testWaitDuration)
  VorpNotification:ShowUpdateMission(testText, testText, testDuration)
  Wait(testWaitDuration)
  VorpNotification:ShowWarning(testText, testText, testDict, testIcon, testDuration)
  Wait(testWaitDuration)
  VorpNotification:NotifyLeft("Testing Completed", "All notifications tested", testDict, testIcon, testDuration,
    testColor)
end
