local Long = require 'long'

local M = {}

M.new = function(n)
  local long = Long.fromInt(n)
  local mt = getmetatable(long)
  mt.__tostring = Long.toString
  return long
end

return M
