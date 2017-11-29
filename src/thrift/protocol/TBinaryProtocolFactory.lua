local class = require 'middleclass'
local TBinaryProtocol = require 'thrift.protocol.TBinaryProtocol'
local terror = require 'thrift.terror'
local TProtocolException = require 'thrift.protocol.TProtocolException'
local TProtocolFactory = require 'thrift.protocol.TProtocolFactory'

local TBinaryProtocolFactory = class('TBinaryProtocolFactory', TProtocolFactory)

function TBinaryProtocolFactory:initialize()
  TProtocolFactory.initialize(self)
  self.strictRead = false
end

function TBinaryProtocolFactory:getProtocol(trans)
  -- TODO Enforce that this must be a transport class (ie not a bool)
  if not trans then
    terror(TProtocolException:new('Must supply a transport to ' .. self.class.name))
  end
  return TBinaryProtocol:new(trans, self.strictRead, true)
end

return TBinaryProtocolFactory
