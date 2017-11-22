local bit32 = require 'bit32'
local vstruct = require 'vstruct'

-- Contains excerpts from https://github.com/Neopallium/lua-pb/blob/master/pb/standard/zigzag.lua
-- (MIT License)

local M = {}

--[[
 * bpack(type, data)
 *  c - Signed Byte
 *  s - Signed Short
 *  i - Signed Int
 *  l - Signed Long
 *  d - Double
--]]
M.bpack = function(type, data)
  if type == 'c' then
    return vstruct.write('< i1', {data})
  elseif type == 's' then
    return vstruct.write('< i2', {data})
  elseif type == 'i' then
    return vstruct.write('< i4', {data})
  elseif type == 'l' then
    return vstruct.write('< i8', {data})
  elseif type == 'd' then
    return vstruct.write('< f8', {data})
  end
  error('unsupported type: '.. tostring(type))
end

--[[
 * bunpack(type, data)
 *  c - Signed Byte
 *  C - Unsigned Byte
 *  s - Signed Short
 *  i - Signed Int
 *  l - Signed Long
 *  d - Double
--]]
M.bunpack = function(type, data)
  error('not impl yet', type, data)
end

M.fromVariant64 = function()
  error('not implemented yet')
end

M.i32ToZigzag = function(num)
  return bit32.bxor(bit32.lshift(num, 1), bit32.arshift(num, 31))
end

M.i64ToZigzag = function(num)
  num = num * 2
  if num < 0 then
    num = (-num) - 1
  end
  return num
end

M.packMesgType = function()
  error('not implemented yet')
end

M.toVarint32 = function()
  error('not implemented yet')
end

M.toVarint64 = function(num)
  local data = ''
  local n = num
  
  while true do
    if bit32.band(n, 127) == 0 then
      data = data .. string.char(n)
      break
    else
      data = data .. string.char(bit32.bor(bit32.band(n, 127), 128))
      n = bit32.rshift(n, 7)
    end
  end
  
  data = data .. vstruct.write('< u4', {#data})
  return data
end

M.zigzagToI32 = function(num)
  return bit32.bxor(bit32.arshift(num, 1), -bit32.band(num, 1))
end

M.zigzagToI64 = function()
  error('not implemented yet')
end

return M
