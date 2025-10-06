local Class = require('supp.class')

---@class supp.graphics.Animation: supp.Class
---@overload fun(name: string, frameNames: string[], frameDuration: number, playMode?: supp.graphics.AnimationMode): supp.graphics.Animation
---@field name string The name of the animation.
---@field frameNames string[] An array of frame names.
---@field frameDuration number The duration of each frame in seconds.
---@field playMode supp.graphics.AnimationMode The play mode of the animation.
local Animation = Class:extend()

---@alias supp.graphics.AnimationMode 'normal' | 'loop' | 'reversed' | 'loop_reversed' | 'loop_ping_pong'

---Get the frame index for a time.
---@param self supp.graphics.Animation The animation.
---@param time number The time in seconds.
---@return number The frame index (1-based).
local function getFrameIndex(self, time)
  if #self.frameNames == 1 then
    return 1
  end

  local frameNumber = math.floor(time / self.frameDuration)
  if self.playMode == 'normal' then
    frameNumber = math.floor(math.min(#self.frameNames, frameNumber))
  elseif self.playMode == 'loop' then
    frameNumber = frameNumber % #self.frameNames
  elseif self.playMode == 'reversed' then
    frameNumber = math.floor(math.max(#self.frameNames - frameNumber - 1, 0))
  elseif self.playMode == 'loop_reversed' then
    frameNumber = frameNumber % #self.frameNames;
    frameNumber = #self.frameNames - frameNumber - 1;
  elseif self.playMode == 'loop_ping_pong' then
    frameNumber = frameNumber % ((#self.frameNames * 2) - 2)
    if (frameNumber >= #self.frameNames) then
      frameNumber = #self.frameNames - 2 - (frameNumber - #self.frameNames)
    end
  end

  return frameNumber + 1
end


---Create a new animation.
---@param name string The name of the animation.
---@param frameNames string[] An array of frame names.
---@param frameDuration number The duration of each frame in seconds.
---@param playMode? supp.graphics.AnimationMode The play mode of the animation. Defaults to 'normal'.
function Animation:new(name, frameNames, frameDuration, playMode)
  self.name = name
  self.frameNames = frameNames
  self.frameDuration = frameDuration
  self.playMode = playMode or 'normal'
end


---Get a frame for a time.
---@param time number The time in seconds.
---@return string The frame name.
function Animation:getFrame(time)
  return self.frameNames[getFrameIndex(self, time)]
end


---Check if this animation is finished.
---@param time number The time in seconds.
---@return boolean True if the animation is finished.
function Animation:isFinished(time)
  if self.playMode == 'normal' or self.playMode == 'reversed' then
    return math.floor(time / self.frameDuration) + 1 > #self.frameNames
  end

  return false
end


return Animation
