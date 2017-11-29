local class = require 'middleclass'
local terror = require 'thrift.terror'
local TFramedTransport = require 'thrift.transport.TFramedTransport'
local TProtocolException = require 'thrift.protocol.TProtocolException'
local TTransportFactory = require 'thrift.transport.TTransportFactory'

local TFramedTransportFactory = class('TFramedTransportFactory', TTransportFactory)

function TFramedTransportFactory:getTransport(trans)
  if not trans then
    terror(TProtocolException:new('Must supply a transport to ' .. self.class.name))
  end
  return TFramedTransport:new(trans)
end

return TFramedTransport
