local class = require 'middleclass'
local terror = require 'thrift.terror'
local TJSONProtocol = require 'thrift.TJSONProtocol'
local TProtocolException = require 'thrift.TProtocolException'

local TJSONProtocolFactory = class('TJSONProtocolFactory')

function TJSONProtocolFactory:getProtocol(trans)
  -- TODO Enforce that this must be a transport class (ie not a bool)
  if not trans then
    terror(TProtocolException:new('Must supply a transport to ' .. self.class))
  end
  return TJSONProtocol:new(trans)
end

return TJSONProtocol
