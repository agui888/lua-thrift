local class = require 'middleclass'
local TBinaryProtocolFactory = require 'thrift.TBinaryProtocolFactory'
local terror = require 'thrift.terror'
local TFramedTransportFactory = require 'thrift.TFramedTransportFactory'

local TServer = class('TServer')

-- 2 possible constructors
--   1. {processor, serverTransport}
--   2. {processor, serverTransport, transportFactory, protocolFactory}
function TServer:initialize(processor, serverTransport, transportFactory, protocolFactory)
  if processor == nil then
    terror('You must provide ' .. self.class .. ' with a processor')
  end
  if serverTransport == nil then
    terror('You must provide ' .. self.class .. ' with a serverTransport')
  end

  self.processor = processor
  self.serverTransport = serverTransport
  self.transportFactory = transportFactory
  self.protocolFactory = protocolFactory

  if transportFactory then
    self.inputTransportFactory = transportFactory
    self.outputTransportFactory = transportFactory
    self.transportFactory = nil
  else
    self.inputTransportFactory = TFramedTransportFactory:new()
    self.outputTransportFactory = self.inputTransportFactory
  end

  if protocolFactory then
    self.inputProtocolFactory = protocolFactory
    self.outputProtocolFactory = protocolFactory
    self.protocolFactory = nil
  else
    self.inputProtocolFactory = TBinaryProtocolFactory:new()
    self.outputProtocolFactory = self.inputProtocolFactory
  end

  -- Set the __server variable in the handler so we can stop the server
  self.processor.handler.__server = self
end

function TServer:setServerEventHandler(handler)
  self.serverEventHandler = handler
end

function TServer:_clientBegin(_, iprot, oprot)
  if self.serverEventHandler and
    type(self.serverEventHandler.clientBegin) == 'function' then
    self.serverEventHandler:clientBegin(iprot, oprot)
  end
end

function TServer:_preServe()
  if self.serverEventHandler and
    type(self.serverEventHandler.preServe) == 'function' then
    self.serverEventHandler:preServe(self.serverTransport:getSocketInfo())
  end
end

function TServer:_handleException(err)
  if string.find(err, 'TTransportException') == nil then
    print(err)
  end
end

function TServer:serve() end
function TServer:handle(client)
  local itrans, otrans =
    self.inputTransportFactory:getTransport(client),
    self.outputTransportFactory:getTransport(client)
  local iprot, oprot =
    self.inputProtocolFactory:getProtocol(itrans),
    self.outputProtocolFactory:getProtocol(otrans)

  self:_clientBegin(iprot, oprot)
  while true do
    local ret, err = pcall(self.processor.process, self.processor, iprot, oprot)
    if ret == false and err then
      if not string.find(err, "TTransportException") then
        self:_handleException(err)
      end
      break
    end
  end
  itrans:close()
  otrans:close()
end

function TServer:close()
  self.serverTransport:close()
end

return TServer
