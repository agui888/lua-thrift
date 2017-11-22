local class = require 'middleclass'
local TBufferedTransport = require 'thrift.TBufferedTransport'
local terror = require 'thrift.terror'
local TTransportException = require 'thrift.TTransportException'
local TTransportFactory = require 'thrift.TTransportFactory'

local TBufferedTransportFactory = class('TBufferedTransportFactory', TTransportFactory)

function TBufferedTransportFactory:getTransport(trans)
  if not trans then
    terror(TTransportException:new('Must supply a transport to ' .. self.class))
  end
  return TBufferedTransport:new(trans)
end

return TBufferedTransportFactory
