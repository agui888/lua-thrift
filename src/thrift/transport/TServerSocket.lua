local class = require 'middleclass'
local luasocket = require 'socket'
local terror = require 'thrift.terror'
local TSocket = require 'thrift.transport.TSocket'

local TServerSocket = class('TServerSocket', TSocket)

function TServerSocket:initialize(handle)
  TSocket.initialize(self, handle)
  self.host = 'localhost'
  self.port = 9090
end

function TServerSocket:listen()
  if self.handle then
    self:close()
  end

  local master = luasocket.tcp()
  local _, err = master:bind(self.host, self.port)
  if not err then
    self.handle = master
  else
    terror(err)
  end
  self.handle:settimeout(self.timeout)
  self.handle:listen()
end

function TServerSocket:accept()
  local client, err = self.handle:accept()
  if err then
    terror(err)
  end
  return TSocket:new(client)
end

return TServerSocket
