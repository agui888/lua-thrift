local class = require 'middleclass'
local terror = require 'thrift.terror'
local TFramedTransport = require 'thrift.TFramedTransport'
local TProtocolException = require 'thrift.TProtocolException'
local TTransportFactory = require 'thrift.TTransportFactory'

local TFramedTransportFactory = class('TFramedTransportFactory', TTransportFactory)

function TFramedTransportFactory:getTransport(trans)
  if not trans then
    terror(TProtocolException:new('Must supply a transport to ' .. self.class))
  end
  return TFramedTransport:new(trans)
end

return TFramedTransport
