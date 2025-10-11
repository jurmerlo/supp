local Class = require('supp.class')

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
---@param r? number The rotation to draw the frame in radians.
---@param sx? number The scale factor in the x direction.
---@param sy? number The scale factor in the y direction.
---@param ox? number The x offset for the frame.
---@param oy? number The y offset for the frame.
function Atlas:drawFrame(name, x, y, r, sx, sy, ox, oy)
  local frame = self:getFrame(name)
  if frame then
    local rotation = r or 0
    local scaleX = sx or 1
    local scaleY = sy or 1
    local offsetX = frame.sourceSize.width * (ox or 0.5) - frame.sourceSize.x
    local offsetY = frame.sourceSize.height * (oy or 0.5) - frame.sourceSize.y
    love.graphics.draw(self.image, frame.quad, x, y, rotation, scaleX, scaleY, offsetX, offsetY)
  end
end


return Atlas
