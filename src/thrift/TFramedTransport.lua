local class = require 'middleclass'
local libluabpack = require 'thrift.libluabpack'
local TTransport = require 'thrift.TTransport'

local TFramedTransport = class('TFramedTransport', TTransport)

function TFramedTransport:initialize()
  TTransport.initialize(self)
  self.doRead = true
  self.doWrite = true
  self.wBuf = ''
  self.rBuf = ''
end

function TFramedTransport:isOpen()
  return self.trans:isOpen()
end

function TFramedTransport:open()
  return self.trans:open()
end

function TFramedTransport:close()
  return self.trans:close()
end

function TFramedTransport:read(len)
  if string.len(self.rBuf) == 0 then
    self:__readFrame()
  end

  if self.doRead == false then
    return self.trans:read(len)
  end

  if len > string.len(self.rBuf) then
    local val = self.rBuf
    self.rBuf = ''
    return val
  end

  local val = string.sub(self.rBuf, 0, len)
  self.rBuf = string.sub(self.rBuf, len+1)
  return val
end

function TFramedTransport:__readFrame()
  local buf = self.trans:readAll(4)
  local frame_len = libluabpack.bunpack('i', buf)
  self.rBuf = self.trans:readAll(frame_len)
end


function TFramedTransport:write(buf, len)
  if self.doWrite == false then
    return self.trans:write(buf, len)
  end

  if len and len < string.len(buf) then
    buf = string.sub(buf, 0, len)
  end
  self.wBuf = self.wBuf .. buf
end

function TFramedTransport:flush()
  if self.doWrite == false then
    return self.trans:flush()
  end

  -- If the write fails we still want wBuf to be clear
  local tmp = self.wBuf
  self.wBuf = ''
  local frame_len_buf = libluabpack.bpack("i", string.len(tmp))
  self.trans:write(frame_len_buf)
  self.trans:write(tmp)
  self.trans:flush()
end

return TFramedTransport
