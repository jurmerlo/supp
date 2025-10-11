-- A module for handling view scaling in a game.
---@class supp.view.Scaling
local Scaling = {}

---Scale the view to fit the window.
---@param designWidth number The width the game is designed for.
---@param designHeight number The height the game is designed for.
---@return number width The scaled width.
---@return number height The scaled height.
---@return number scaleX The scale factor in the horizontal direction.
---@return number scaleY The scale factor in the vertical direction.
---@return number offsetX The horizontal offset to center the view.
---@return number offsetY The vertical offset to center the view.
function Scaling.scaleToFit(designWidth, designHeight)
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  local designRatio = designWidth / designHeight
  local windowRatio = windowWidth / windowHeight

  ---@type number
  local width
  ---@type number
  local height

  if windowRatio < designRatio then
    width = designWidth
    height = math.ceil(width / windowRatio)
  else
    height = designHeight
    width = math.ceil(height * windowRatio)
  end

  local scaleFactor = windowWidth / width

  local xOffset = (windowWidth - designWidth * scaleFactor) * 0.5
  local yOffset = (windowHeight - designHeight * scaleFactor) * 0.5

  return width, height, scaleFactor, scaleFactor, xOffset, yOffset
end


return Scaling
