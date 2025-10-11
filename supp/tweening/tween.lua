local Class = require('supp.class')
local Easing = require('supp.tweening.easing')

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
    if target[key] then
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
