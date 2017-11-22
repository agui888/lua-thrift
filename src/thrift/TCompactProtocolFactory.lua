local class = require 'middleclass'
local TCompactProtocol = require 'thrift.TCompactProtocol'
local terror = require 'thrift.terror'
local TProtocolException = require 'thrift.TProtocolException'

local TCompactProtocolFactory = class('TCompactProtocolFactory')

function TCompactProtocolFactory:getProtocol(trans)
  -- TODO Enforce that this must be a transport class (ie not a bool)
  if not trans then
    terror(TProtocolException:new('Must supply a transport to ' .. self.class))
  end
  return TCompactProtocol:new(trans)
end

return TCompactProtocolFactory
