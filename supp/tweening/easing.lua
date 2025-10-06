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
