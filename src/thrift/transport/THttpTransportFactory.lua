local class = require 'middleclass'
local terror = require 'thrift.terror'
local THttpTransport = require 'thrift.transport.THttpTransport'
local TProtocolException = require 'thrift.protocol.TProtocolException'
local TTransportFactory = require 'thrift.transport.TTransportFactory'

local THttpTransportFactory = class('THttpTransportFactory', TTransportFactory)

function THttpTransportFactory:getTransport(trans)
  if not trans then
    terror(TProtocolException:new('Must supply a transport to ' .. self.class.name))
  end
  return THttpTransport:new(trans)
end

return THttpTransportFactory
