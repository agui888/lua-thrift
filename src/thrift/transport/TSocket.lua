local class = require 'middleclass'
local luasocket = require 'socket'
local terror = require 'thrift.terror'
local TTransport = require 'thrift.transport.TTransport'
local TTransportException = require 'thrift.transport.TTransportException'

local TSocket = class('TSocket', TTransport)

function TSocket:initialize(handle)
  self.timeout = 1000
  self.host = 'localhost'
  self.port = 9090
  self.handle = handle
end

function TSocket:close()
  if self.handle then
    self.handle:destroy()
    self.handle = nil
  end
end

-- Returns a table with the fields host and port
function TSocket:getSocketInfo()
  if self.handle then
    return self.handle:getsockinfo()
  end
  terror(TTransportException:new(nil, TTransportException.NOT_OPEN))
end

function TSocket:setTimeout(timeout)
  if timeout and type(timeout) == 'number' then
    if self.handle then
      self.handle:settimeout(timeout)
    end
    self.timeout = timeout
  end
end

function TSocket:isOpen()
  if self.handle then
    return true
  end
  return false
end

function TSocket:open()
  if self.handle then
    self:close()
  end

  -- Create local handle
  local sock, err = luasocket.create_and_connect(
    self.host, self.port, self.timeout)
  if err == nil then
    self.handle = sock
  end

  if err then
    terror(TTransportException:new(
      'Could not connect to ' .. self.host .. ':' .. self.port .. ' (' .. err .. ')'))
  end
end

function TSocket:read(len)
  local buf = self.handle:receive(self.handle, len)
  if not buf or string.len(buf) ~= len then
    terror(TTransportException:new(nil, TTransportException.UNKNOWN))
  end
  return buf
end

function TSocket:write(buf)
  self.handle:send(self.handle, buf)
end

function TSocket:flush()
end

return TSocket
