local Class = require 'supp.Class'

---@class supp.Node: supp.Class
---@field active boolean
---@overload fun(): supp.Node
local Node = Class:extend()

---Creates a new Node instance.
function Node:new()
  self.active = true
end


---Updates the Node instance.
---@param dt number Delta time in seconds since the last update.
function Node:update(dt)
end


---Draws the Node instance.
function Node:draw()
end


---Destroys the Node instance.
function Node:destroy()
end


return Node
