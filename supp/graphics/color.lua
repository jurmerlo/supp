local Class = require('supp.class')

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
