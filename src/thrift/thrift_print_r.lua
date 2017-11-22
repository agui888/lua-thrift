local _M = {}

_M.thrift_print_r = function(t)
  local ret = ''
  local ltype = type(t)
  if (ltype == 'table') then
    ret = ret .. '{ '
    for key,value in pairs(t) do
      ret = ret .. tostring(key) .. '=' .. _M.thrift_print_r(value) .. ' '
    end
    ret = ret .. '}'
  elseif ltype == 'string' then
    ret = ret .. "'" .. tostring(t) .. "'"
  else
    ret = ret .. tostring(t)
  end
  return ret
end

return _M.thrift_print_r
