local class = require 'middleclass'
local TBufferedTransport = require 'thrift.transport.TBufferedTransport'
local terror = require 'thrift.terror'
local TTransportException = require 'thrift.transport.TTransportException'
local TTransportFactory = require 'thrift.transport.TTransportFactory'

local TBufferedTransportFactory = class('TBufferedTransportFactory', TTransportFactory)

function TBufferedTransportFactory:getTransport(trans)
  if not trans then
    terror(TTransportException:new('Must supply a transport to ' .. self.class.name))
  end
  return TBufferedTransport:new(trans)
end

return TBufferedTransportFactory
