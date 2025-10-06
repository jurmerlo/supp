-- Supp version: 0.1.0
-- luacheck: ignore
-- cSpell:ignore luabundle supp
-- Bundled by luabundle {"luaVersion":"LuaJIT","version":"1.7.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
---supp.tweening files
local Tween = require("supp.tweening.tween")
local Easing = require("supp.tweening.easing")

---@class supp.tweening
---@field Tween supp.tweening.Tween
---@field Easing supp.tweening.Easing

---supp.graphics files
local Color = require("supp.graphics.color")
local Atlas = require("supp.graphics.atlas")
local Animation = require("supp.graphics.animation")

---@class supp.graphics
---@field Color supp.graphics.Color
---@field Atlas supp.graphics.Atlas
---@field Animation supp.graphics.Animation

---supp files
local Class = require("supp.class")

---@class supp.Supp
---@field VERSION string
---@field tweening supp.tweening
---@field graphics supp.graphics
---@field Class supp.Class

return {
  VERSION = '0.1.0',
  tweening = {
    Tween = Tween,
    Easing = Easing,
  },
  graphics = {
    Color = Color,
    Atlas = Atlas,
    Animation = Animation,
  },
  Class = Class,
}

end)
__bundle_register("supp.class", function(require, _LOADED, __bundle_register, __bundle_modules)
-- luacheck: ignore
--
-- Based on the classic.lua library by rxi
-- https://github.com/rxi/classic
--
-- Copyright (c) 2014, rxi
-- Copyright (c) 2025, Jurmerlo
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-- 
---@class supp.Class
---@field super any
local Class = {}
Class.__index = Class

---Creates a new instance of the class.
---@param ... unknown Arguments to pass to the constructor.
function Class:new(...)
end


---Extends this class.
---@return any The new class.
function Class:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find('__') == 1 then
      cls[k] = v
    end
  end

  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end


---Implement part of another class.
---@param ... unknown Classes to implement.
function Class:implement(...)
  for _, cls in pairs({ ... }) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == 'function' then
        self[k] = v
      end
    end
  end
end


---Check if this class is of type.
---@param T supp.Class The class to check against.
---@return boolean True if this class is of type T.
function Class:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end


---Returns a string representation of the class.
---@return string The string representation of the class.
function Class:__tostring()
  return 'Class'
end


---Creates a new instance of the class.
---@param ... unknown Arguments to pass to the constructor.
---@return supp.Class The new instance of the class.
function Class:__call(...)
  local obj = setmetatable({}, self)
  ---@diagnostic disable-next-line: redundant-parameter
  obj:new(...)
  return obj
end


return Class

end)
__bundle_register("supp.graphics.animation", function(require, _LOADED, __bundle_register, __bundle_modules)
local Class = require("supp.class")

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

end)
__bundle_register("supp.graphics.atlas", function(require, _LOADED, __bundle_register, __bundle_modules)
local Class = require("supp.class")

---@class supp.graphics.Atlas: supp.Class
---@overload fun(image: love.Image, frameData: any): supp.graphics.Atlas
---@field frames table<string, supp.graphics.AtlasFrame> A table of frames, indexed by name.
---@field image love.Image The image containing the atlas.
local Atlas = Class:extend()

---@class supp.graphics.AtlasFrame A frame in an atlas.
---@field name string The name of the frame.
---@field quad love.Quad The quad representing the frame.
---@field trimmed boolean Whether the frame is trimmed.
---@field sourceSize {x: number, y: number, width: number, height: number} The source size of the frame.

---Load an atlas from a path.
---@param path string The path to the atlas (without extension).
---@return supp.graphics.Atlas The loaded atlas.
function Atlas.load(path)
  local data = love.filesystem.load(path .. '.lua')()
  local image = love.graphics.newImage(path .. '.png')

  return Atlas(image, data)
end


---Create a new Atlas. Use Atlas.load to load from a file.
---@param image love.Image The image containing the atlas.
---@param frameData any The frame data for the atlas.
function Atlas:new(image, frameData)
  self.frames = {}
  self.image = image

  for _, data in pairs(frameData.frames) do
    local quad = love.graphics.newQuad(data.rect.x, data.rect.y, data.rect.width, data.rect.height,
        image:getDimensions())
    self.frames[data.filename] = {
      name = data.filename,
      quad = quad,
      trimmed = data.trimmed,
      sourceSize = data.sourceSize
    }
  end
end


---Get a frame by name.
---@param name string The name of the frame.
---@return supp.graphics.AtlasFrame? The frame, or nil if not found.
function Atlas:getFrame(name)
  return self.frames[name]
end


---Draw a frame from the atlas.
---@param name string The name of the frame.
---@param x number The x position to draw the frame.
---@param y number The y position to draw the frame.
---@param r number The rotation to draw the frame in radians.
---@param sx number The scale factor in the x direction.
---@param sy number The scale factor in the y direction.
---@param ox number The x offset for the frame.
---@param oy number The y offset for the frame.
function Atlas:drawFrame(name, x, y, r, sx, sy, ox, oy)
  local frame = self:getFrame(name)
  if frame then
    local offsetX = frame.sourceSize.width * (ox or 0.5) - frame.sourceSize.x
    local offsetY = frame.sourceSize.height * (oy or 0.5) - frame.sourceSize.y
    local rotation = r or 0
    local scaleX = sx or 1
    local scaleY = sy or 1
    love.graphics.draw(self.image, frame.quad, x, y, rotation, scaleX, scaleY, offsetX, offsetY)
  end
end


return Atlas

end)
__bundle_register("supp.graphics.color", function(require, _LOADED, __bundle_register, __bundle_modules)
local Class = require("supp.class")

---@class supp.graphics.Color: supp.Class
---@overload fun(red: number, green: number, blue: number, alpha?: number): supp.graphics.Color
---@field red number The red channel (0 - 1).
---@field green number The green channel (0 - 1).
---@field blue number The blue channel (0 - 1).
---@field alpha number The alpha channel (0 - 1).
local Color = Class:extend()

---Create a new color from bytes (0 - 255).
---@param red number number The red channel (0 - 1).
---@param green number The red channel (0 - 255).
---@param blue number The red channel (0 - 255).
---@param alpha number The red channel (0 - 255).
---@return supp.graphics.Color
function Color.fromBytes(red, green, blue, alpha)
  alpha = alpha or 255

  return Color(red / 255.0, green / 255.0, blue / 255.0, alpha / 255.0)
end


---Interpolate between two colors.
---@param color1 supp.graphics.Color
---@param color2 supp.graphics.Color
---@param factor number
---@param out? supp.graphics.Color
---@return supp.graphics.Color
function Color.interpolate(color1, color2, factor, out)
  local red = (color2.red - color1.red) * factor + color1.red
  local green = (color2.green - color1.green) * factor + color1.green
  local blue = (color2.blue - color1.blue) * factor + color1.blue
  local alpha = (color2.alpha - color1.alpha) * factor + color1.alpha;

  if out then
    out:set(red, green, blue, alpha)

    return out
  end

  return Color(red, green, blue, alpha);
end


---Create a new color.
---@param red number The red value (0 - 1).
---@param green number The green value (0 - 1).
---@param blue number The blue value (0 - 1).
---@param alpha? number The optional alpha value (0 - 1).
function Color:new(red, green, blue, alpha)
  self.red = red
  self.green = green
  self.blue = blue
  self.alpha = alpha or 1.0
end


---Copy the values from another color.
---@param other supp.graphics.Color
function Color:copyFrom(other)
  self:set(other.red, other.green, other.blue, other.alpha)
end


---Set new color values.
---@param red number
---@param green number
---@param blue number
---@param alpha number
function Color:set(red, green, blue, alpha)
  self.red = red
  self.green = green
  self.blue = blue
  self.alpha = alpha
end


---Return the separate channels.
---@return number red - The red channel (0 - 1).
---@return number green - The green channel (0 - 1).
---@return number blue - The blue channel (0 - 1).
---@return number alpha - The alpha channel (0 - 1).
function Color:parts()
  return self.red, self.green, self.blue, self.alpha
end


return Color

end)
__bundle_register("supp.tweening.easing", function(require, _LOADED, __bundle_register, __bundle_modules)
---All easing functions.
---@class supp.tweening.Easing
local Easing = {}

---@alias supp.tweening.EasingFunction fun(time: number, begin: number, change: number, duration: number): number

local EASE_BACK_CONST = 1.70158

local pi = math.pi
local cos = math.cos
local sin = math.sin
local pow = math.pow
local sqrt = math.sqrt

local PI_M2 = pi * 2

local PI_D2 = pi / 2

---Linear easing
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.linear(time, begin, change, duration)
  return change * time / duration + begin
end


--- Sine in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInSine(time, begin, change, duration)
  return -change * cos(time / duration * PI_D2) + change + begin
end


---Sine out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutSine(time, begin, change, duration)
  return change * sin(time / duration * PI_D2) + begin
end


---Sine in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutSine(time, begin, change, duration)
  return -change / 2 * (cos(pi * time / duration) - 1) + begin
end


---Quint in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInQuint(time, begin, change, duration)
  time = time / duration
  return change * time * time * time * time * time + begin
end


---Quint out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutQuint(time, begin, change, duration)
  time = time / duration - 1
  return change * (time * time * time * time * time + 1) + begin;
end


---Quint in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutQuint(time, begin, change, duration)
  time = time / (duration / 2)
  if time < 1 then
    return (change / 2) * time * time * time * time * time + begin;
  end
  time = time - 2
  return (change / 2) * (time * time * time * time * time + 2) + begin;
end


---Quart in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInQuart(time, begin, change, duration)
  time = time / duration
  return change * time * time * time * time + begin;
end


---Quart out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutQuart(time, begin, change, duration)
  time = time / duration - 1
  return -change * (time * time * time * time - 1) + begin;
end


---Quart in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutQuart(time, begin, change, duration)
  time = time / (duration / 2)
  if time < 1 then
    return change / 2 * time * time * time * time + begin;
  end

  time = time - 2
  return -change / 2 * (time * time * time * time - 2) + begin;
end


---Quad in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInQuad(time, begin, change, duration)
  time = time / duration
  return change * time * time + begin;
end


---Quad out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutQuad(time, begin, change, duration)
  time = time / duration
  return -change * time * (time - 2) + begin;
end


---Quad in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutQuad(time, begin, change, duration)
  time = time / (duration / 2)
  if time < 1 then
    return change / 2 * time * time + begin;
  end

  return -change / 2 * ((time - 1) * (time - 3) - 1) + begin;
end


---Expo in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInExpo(time, begin, change, duration)
  if time == 0 then
    return begin
  end

  return change * pow(2, 10 * (time / duration - 1)) + begin;
end


---Expo out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutExpo(time, begin, change, duration)
  if time == duration then
    return begin + change
  end
  return change * (-pow(2, -10 * time / duration) + 1) + begin;
end


---Expo in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutExpo(time, begin, change, duration)
  if time == 0 then
    return begin;
  end

  if time == duration then
    return begin + change;
  end

  time = time / (duration / 2)
  if (time) < 1 then
    return change / 2 * pow(2, 10 * (time - 1)) + begin;
  end

  return change / 2 * (-pow(2, -10 * (time - 1)) + 2) + begin;
end


---Elastic in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInElastic(time, begin, change, duration)
  local p = duration * 0.3;
  local a = change;
  local s = p / 4.0;

  if time == 0 then
    return begin;
  end

  time = time / duration
  if time == 1 then
    return begin + change;
  end

  return -(a * pow(2, 10 * (time - 1)) * sin(((time - 1) * duration - s) * PI_M2 / p)) + begin;
end


-- Elastic out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutElastic(time, begin, change, duration)
  local p = duration * 0.3;

  local a = change;
  local s = p / 4.0;

  if time == 0 then
    return begin;
  end
  time = time / duration
  if time == 1 then
    return begin + change;
  end

  return (a * pow(2, -10 * time) * sin((time * duration - s) * PI_M2 / p) + change + begin);
end


---Elastic in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutElastic(time, begin, change, duration)
  local p = duration * (0.3 * 1.5);
  local a = change;
  local s = p / 4.0;

  if time == 0 then
    return begin;
  end
  time = time / (duration / 2)
  if time == 2 then
    return begin + change;
  end

  if time < 1 then
    return -0.5 * (a * pow(2, 10 * (time - 1)) * sin((((time - 1) * duration - s) * PI_M2) / p)) + begin;
  end

  return a * pow(2, -10 * (time - 1)) * sin(((time - 1) * duration - s) * PI_M2 / p) * 0.5 + change + begin;
end


---Circular in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInCircular(time, begin, change, duration)
  time = time / duration
  return -change * (sqrt(1 - time * time) - 1) + begin;
end


---Circular out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutCircular(time, begin, change, duration)
  time = time / duration - 1
  return change * sqrt(1 - time * time) + begin;
end


---Circular in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutCircular(time, begin, change, duration)
  time = time / (duration / 2)
  if time < 1 then
    return -change / 2 * (sqrt(1 - time * time) - 1) + begin;
  end

  return change / 2 * (sqrt(1 - (time - 2) * (time - 2)) + 1) + begin;
end


---Back in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInBack(time, begin, change, duration)
  time = time / duration
  return change * time * time * ((EASE_BACK_CONST + 1) * time - EASE_BACK_CONST) + begin;
end


---Back out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutBack(time, begin, change, duration)
  time = time / duration - 1
  return change * (time * time * ((EASE_BACK_CONST + 1) * time + EASE_BACK_CONST) + 1) + begin;
end


---Back in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutBack(time, begin, change, duration)
  local s = 1.70158 * 1.525;
  time = time / (duration / 2)

  if time < 1 then
    return change / 2 * (time * time * ((s + 1) * time - s)) + begin;
  end

  return change / 2 * ((time - 2) * (time - 2) * ((s + 1) * (time - 2) + s) + 2) + begin;
end


---Bounce in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInBounce(time, begin, change, duration)
  return change - Easing.easeOutBounce(duration - time, 0, change, duration) + begin;
end


---Bounce out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutBounce(time, begin, change, duration)
  time = time / duration
  if time < (1 / 2.75) then
    return change * (7.5625 * time * time) + begin;
  elseif time < (2 / 2.75) then
    time = time - (1.5 / 2.75)
    return change * (7.5625 * time * time + 0.75) + begin;
  elseif time < (2.5 / 2.75) then
    time = time - (2.25 / 2.75)
    return change * (7.5625 * time * time + 0.9375) + begin;
  else
    time = time - (2.625 / 2.75)
    return change * (7.5625 * time * time + 0.984375) + begin;
  end
end


---Bounce in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutBounce(time, begin, change, duration)
  if time < duration / 2 then
    return Easing.easeInBounce(time * 2, 0, change, duration) * 0.5 + begin;
  else
    return Easing.easeOutBounce(time * 2 - duration, 0, change, duration) * 0.5 + change * 0.5 + begin;
  end
end


---Cubic in easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInCubic(time, begin, change, duration)
  time = time / duration
  return change * time * time * time + begin;
end


---Cubic out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeOutCubic(time, begin, change, duration)
  time = time / duration - 1
  return change * (time * time * time + 1) + begin;
end


---Cubic in out easing.
---@param time number The time since the tween started in seconds.
---@param begin number he start value of the property.
---@param change number he amount of change from start to end.
---@param duration number The total duration of the tween in seconds.
---@return number # The updated property value.
function Easing.easeInOutCubic(time, begin, change, duration)
  time = time / (duration / 2)
  if time < 1 then
    return change / 2 * time * time * time + begin;
  end

  time = time - 2
  return change / 2 * (time * time * time + 2) + begin;
end


return Easing

end)
__bundle_register("supp.tweening.tween", function(require, _LOADED, __bundle_register, __bundle_modules)
local Class = require("supp.class")
local Easing = require("supp.tweening.easing")

---@class supp.tweening.Tween: supp.Class
---@overload fun(target: table, duration: number, from: table, to: table): supp.tweening.Tween
---@field target table
---@field time number
---@field duration number
---@field delay number
---@field delayTime number
---@field finished boolean
---@field ease supp.tweening.EasingFunction
---@field dataList table
---@field onComplete? fun()
---@field onUpdate? fun(target: table)
local Tween = Class:extend()

---Create a data list with the changes for each property.
---@param self supp.tweening.Tween
---@param target table
---@param from table
---@param to table
local function createDataList(self, target, from, to)
  for key, fromValue in pairs(from) do
    if target[key] ~= nil then
      local toValue = to[key]

      if type(target[key] == 'number') then
        local change = toValue - fromValue
        table.insert(self.dataList, { start = fromValue, ending = toValue, change = change, propertyName = key })
      end
    end
  end
end


---comment
---@param self supp.tweening.Tween
---@param property table
local function updateProperty(self, property)
  local value = self.ease(self.time, property.start, property.change, self.duration)
  if self.finished then
    value = property.ending
  end

  self.target[property.propertyName] = value
end


function Tween:new(target, duration, from, to)
  self.target = target
  self.time = 0
  self.duration = duration
  self.finished = false
  self.ease = Easing.linear
  self.dataList = {}
  self.delay = 0
  self.delayTime = 0

  createDataList(self, target, from, to)
end


function Tween:update(dt)
  if self.finished then
    return
  end

  if self.delayTime < self.delay then
    self.delayTime = self.delayTime + dt
    return
  end

  self.time = self.time + dt
  if self.time >= self.duration then
    self.finished = true
    if self.onComplete then
      self.onComplete()
    end
  end

  for _, property in ipairs(self.dataList) do
    updateProperty(self, property)
  end

  if self.onUpdate then
    self.onUpdate(self.target)
  end
end


---Set the easing function to be used.
---@param ease supp.tweening.EasingFunction
function Tween:setEase(ease)
  self.ease = ease
end


---Set a function to be called when the tween is completed.
---@param onComplete fun()
function Tween:setOnComplete(onComplete)
  self.onComplete = onComplete
end


---Set a function to be called when the tween is updated.
---@param onUpdate fun(target: table)
function Tween:setOnUpdate(onUpdate)
  self.onUpdate = onUpdate
end


---Reset the tween to its initial state.
function Tween:reset()
  self.delayTime = 0
  self.time = 0
  self.finished = false
end


---Set the delay time before the tween starts.
---@param delay number
function Tween:setDelay(delay)
  self.delay = delay
end


return Tween

end)

local bundle = __bundle_require("__root")
---@cast bundle supp.Supp

return bundle