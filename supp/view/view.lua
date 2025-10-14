local Scaling = require 'supp.view.scaling'

--- A module for managing the game view, including scaling and rendering to a canvas.
---@class supp.view.View
local View = {}

---The width the game is designed for.
---@type number
local designWidth = 0

---The height the game is designed for.
---@type number
local designHeight = 0

---The actual view width after scaling.
---@type number
local viewWidth = 0

---The actual view height after scaling.
---@type number
local viewHeight = 0

---The scale factor in the horizontal direction.
---@type number
local viewScaleX = 1

---The scale factor in the vertical direction.
---@type number
local viewScaleY = 1

---The horizontal offset to center the view.
---@type number
local viewOffsetX = 0

---The vertical offset to center the view.
---@type number
local viewOffsetY = 0

---The canvas used for rendering the view.
---@type love.Canvas
local canvas = nil

---Initialize the view with a design width and height.
---@param width number The design width in pixels.
---@param height number The design height in pixels.
function View.init(width, height)
  designWidth = width
  designHeight = height
  View.scaleToWindow()
end


---Scale the view to fit the window.
function View.scaleToWindow()
  local w, h, sx, sy, ox, oy = Scaling.scaleToFit(designWidth, designHeight)
  viewWidth, viewHeight, viewScaleX, viewScaleY, viewOffsetX, viewOffsetY = w, h, sx, sy, ox, oy

  if canvas then
    canvas:release()
  end
  canvas = love.graphics.newCanvas(viewWidth, viewHeight)
end


---Set the active canvas to the view canvas.
---@param clear? boolean If true, clear the canvas.
function View.setCanvas(clear)
  love.graphics.setCanvas(canvas)

  if clear then
    love.graphics.clear(0, 0, 0, 1)
  end
end


---Draw the view canvas to the screen.
function View.drawCanvas()
  love.graphics.setCanvas()
  love.graphics.clear()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(canvas, viewOffsetX, viewOffsetY, 0, viewScaleX, viewScaleY)
end


---Get the view width and height.
---@return number width The view width in pixels.
---@return number height The view height in pixels.
function View.getViewSize()
  return viewWidth, viewHeight
end


return View
