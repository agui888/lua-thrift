local class = require 'middleclass'
local TServer = require 'thrift.TServer'

local TSimpleServer = class('TSimpleServer', TServer)

function TSimpleServer:initialize(...)
  TServer.initialize(self, ...)
  self.__stop = false
end

function TSimpleServer:serve()
  self.serverTransport:listen()
  self:_preServe()
  while not self.__stop do
    local client = self.serverTransport:accept()
    self:handle(client)
  end
  self:close()
end

function TSimpleServer:stop()
  self.__stop = true
end

return TSimpleServer
