local bit32 = require 'bit32'

local M = {}

M.band = function(a,b)
  return bit32.band(a, b)
end

M.bnot = function(a)
  return bit32.bnot(a)
end

M.bor = function(a, b)
  return bit32.bor(a, b)
end

M.bxor = function(a, b)
  return bit32.bxor(a, b)
end

M.shiftl = function(a, b)
  return bit32.lshift(a, b)
end

M.shiftr = function(a, b)
  return bit32.rshift(a, b)
end

return M
