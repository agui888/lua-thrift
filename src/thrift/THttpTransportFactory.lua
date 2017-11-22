local class = require 'middleclass'
local terror = require 'thrift.terror'
local THttpTransport = require 'thrift.THttpTransport'
local TProtocolException = require 'thrift.TProtocolException'
local TTransportFactory = require 'thrift.TTransportFactory'

local THttpTransportFactory = class('THttpTransportFactory', TTransportFactory)

function THttpTransportFactory:getTransport(trans)
  if not trans then
    terror(TProtocolException:new('Must supply a transport to ' .. self.class))
  end
  return THttpTransport:new(trans)
end

return THttpTransportFactory
