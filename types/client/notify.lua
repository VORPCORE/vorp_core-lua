---@meta

--- CLIENT SIDE NOTIFICATION
---@param text string text
---@param duration number duration
function exports.vorp_core:DisplayTip(text, duration) end

--- CLIENT SIDE NOTIFICATION
---@param title string title
---@param subTitle string subTitle
---@param dict string dictionary
---@param icon string icon
---@param duration number duration
---@param color string color
function exports.vorp_core:DisplayLeftNotification(title, subTitle, dict, icon, duration, color) end

--- CLIENT SIDE NOTIFICATION
---@param text string text
---@param location string location
---@param duration number duration
function exports.vorp_core:DisplayTopCenterNotification(text, location, duration) end

--- CLIENT SIDE NOTIFICATION
---@param text string text
---@param duration number duration
function exports.vorp_core:DisplayTipRight(text, duration) end

--- CLIENT SIDE NOTIFICATION
---@param text string text
---@param duration number duration
function exports.vorp_core:DisplayObjective(text, duration) end

--- CLIENT SIDE NOTIFICATION
---@param title string text
---@param subtext string subtext
---@param duration number duration
function exports.vorp_core:ShowTopNotification(title, subtext, duration) end

--- CLIENT SIDE NOTIFICATION
---@param _text string text
---@param _dict string dict
---@param icon string icon
---@param text_color string text_color
---@param duration number duration
---@param quality number quality
function exports.vorp_core:ShowAdvancedRightNotification(_text, _dict, icon, text_color, duration, quality, showquality) end

--- CLIENT SIDE NOTIFICATION
---@param title string text
---@param duration number duration
function exports.vorp_core:ShowBasicTopNotification(title, duration) end

--- CLIENT SIDE NOTIFICATION
---@param text string text
---@param duration number duration
---@param text_color string text_color
function exports.vorp_core:ShowSimpleCenterText(text, duration, text_color) end

--- CLIENT SIDE NOTIFICATION
---@param text string text
---@param duration number duration
function exports.vorp_core:showBottomRight(text, duration) end

--- CLIENT SIDE NOTIFICATION
---@param title string title
---@param subTitle string subTitle
---@param duration number duration
function exports.vorp_core:failmissioNotifY(title, subTitle, duration) end

--- CLIENT SIDE NOTIFICATION
---@param title string title
---@param _audioRef string audio reference
---@param _audioName string audio name
---@param duration number duration
function exports.vorp_core:deadplayerNotifY(title, _audioRef, _audioName, duration) end

--- CLIENT SIDE NOTIFICATION
---@param utitle string title
---@param umsg string message
---@param duration number duration
function exports.vorp_core:updateMission(utitle, umsg, duration) end

--- CLIENT SIDE NOTIFICATION
---@param title string title
---@param msg string message
---@param _audioRef string audio reference
---@param _audioName string audio name
---@param duration number duration
function exports.vorp_core:warningNotify(title, msg, _audioRef, _audioName, duration) end

--- CLIENT SIDE NOTIFICATION
---@param title string title
---@param subTitle string subTitle
---@param dict string dictionary
---@param icon string icon
---@param duration number duration
---@param color string color
function exports.vorp_core:LeftRank(title, subTitle, dict, icon, duration, color) end
