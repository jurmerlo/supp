local Class = require 'supp.Class'

---@class supp.math.Rectangle: supp.Class
---@overload fun(x: number, y: number, width: number, height: number): supp.math.Rectangle
---@field x number
---@field y number
---@field width number
---@field height number
local Rectangle = Class:extend()

---Create a new rectangle instance.
---@param x number
---@param y number
---@param width number
---@param height number
function Rectangle:new(x, y, width, height)
  self.x = x or 0
  self.y = y or 0
  self.width = width or 0
  self.height = height or 0
end


---Check if this rectangle contains a point.
---@param px number
---@param py number
---@return boolean # true if the point is inside the rectangle.
function Rectangle:contains(px, py)
  return px >= self.x and px < self.x + self.width and py >= self.y and py < self.y + self.height
end


---Check if two rectangles intersect.
---@param other supp.math.Rectangle
---@return boolean # true if the rectangles intersect.
function Rectangle:intersects(other)
  return not (other.x > self.x + self.width or other.x + other.width < self.x or other.y > self.y + self.height or
             other.y + other.height < self.y)
end


return Rectangle
