local class = require 'middleclass'
local TBinaryProtocol = require 'thrift.TBinaryProtocol'
local terror = require 'thrift.terror'
local TProtocolException = require 'thrift.TProtocolException'
local TProtocolFactory = require 'thrift.TProtocolFactory'

local TBinaryProtocolFactory = class('TBinaryProtocolFactory', TProtocolFactory)

function TBinaryProtocolFactory:initialize()
  TProtocolFactory.initialize(self)
  self.strictRead = false
end

function TBinaryProtocolFactory:getProtocol(trans)
  -- TODO Enforce that this must be a transport class (ie not a bool)
  if not trans then
    terror(TProtocolException:new('Must supply a transport to ' .. self.class))
  end
  return TBinaryProtocol:new(trans, self.strictRead, true)
end

return TBinaryProtocolFactory
