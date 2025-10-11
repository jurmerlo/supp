local Class = require 'supp.Class'

---@class supp.math.Point: supp.Class
---@field x number
---@field y number
---@overload fun(x: number, y: number): supp.math.Point
local Point = Class:extend()

---@type supp.math.Point[]
local pool = {}

---Get a point from the object pool.
---@param x number?
---@param y number?
---@return supp.math.Point
function Point.get(x, y)
  x = x or 0
  y = y or 0

  ---@type supp.math.Point?
  local p = table.remove(pool)

  if p then
    p.x = x
    p.y = y
    return p
  else
    return Point(x, y)
  end
end


---Put a point back into the object pool.
---@param p supp.math.Point
function Point.put(p)
  table.insert(pool, p)
end


---Create a new Point instance.
---@param x number?
---@param y number?
function Point:new(x, y)
  self.x = x or 0
  self.y = y or 0
end


---Check if two points are the same.
---@param other supp.math.Point
---@return boolean
function Point:equals(other)
  return self.x == other.x and self.y == other.y
end


---Clone this point.
---@param out supp.math.Point? Optional point to copy into.
---@return supp.math.Point
function Point:clone(out)
  if out == nil then
    out = Point.get()
  end
  out.x = self.x
  out.y = self.y

  return out
end


return Point
