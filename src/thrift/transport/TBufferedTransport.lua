local class = require 'middleclass'
local TTransport = require 'thrift.transport.TTransport'

local TBufferedTransport = class('TBufferedTransport', TTransport)

function TBufferedTransport:initialize(trans)
  TTransport.initialize(self)
  assert(trans)
  self.trans = trans
  self.rBufSize = 2048
  self.wBufSize = 2048
  self.wBuf = ''
  self.rBuf = ''
end

function TBufferedTransport:isOpen()
  return self.trans:isOpen()
end

function TBufferedTransport:open()
  return self.trans:open()
end

function TBufferedTransport:close()
  return self.trans:close()
end

function TBufferedTransport:read(len)
  return self.trans:read(len)
end

function TBufferedTransport:readAll(len)
  return self.trans:readAll(len)
end

function TBufferedTransport:write(buf)
  self.wBuf = self.wBuf .. buf
  if string.len(self.wBuf) >= self.wBufSize then
    self.trans:write(self.wBuf)
    self.wBuf = ''
  end
end

function TBufferedTransport:flush()
  if string.len(self.wBuf) > 0 then
    self.trans:write(self.wBuf)
    self.wBuf = ''
  end
end

return TBufferedTransport
