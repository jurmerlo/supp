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
