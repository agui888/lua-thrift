local Long = require 'long'

local M = {}

M.new = function(n)
  local long = Long.fromInt(n)
  local mt = getmetatable(long)
  mt.__add = Long.add
  mt.__div = Long.divide
  mt.__eq = Long.eq
  mt.__lt = Long.lessThan
  --TODO __le
  --TODO __mod
  mt.__mul = Long.multiply
  --TODO __pow
  mt.__sub = Long.subtract
  mt.__tostring = Long.toString
  --TODO __unm
  return long
end

return M
