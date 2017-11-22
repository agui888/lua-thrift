local class = require 'middleclass'
local libluabpack = require 'thrift.libluabpack'
local libluabitwise = require 'thrift.libluabitwise'
local terror = require 'thrift.terror'
local TProtocol = require 'thrift.TProtocol'
local TProtocolException = require 'thrift.TProtocolException'
local TType = require 'thrift.TType'

local TBinaryProtocol = class('TBinaryProtocol', TProtocol)

TBinaryProtocol.VERSION_MASK = -65536 -- 0xffff0000
TBinaryProtocol.VERSION_1    = -2147418112 -- 0x80010000
TBinaryProtocol.TYPE_MASK    = 0x000000ff

function TBinaryProtocol:initialize(trans, strictRead, strictWrite)
  TProtocol.initialize(self, trans)
  self.strictRead  = strictRead or false
  self.strictWrite = strictWrite or true
end

function TBinaryProtocol:writeMessageBegin(name, ttype, seqid)
  if self.strictWrite then
    self:writeI32(libluabitwise.bor(TBinaryProtocol.VERSION_1, ttype))
    self:writeString(name)
    self:writeI32(seqid)
  else
    self:writeString(name)
    self:writeByte(ttype)
    self:writeI32(seqid)
  end
end

function TBinaryProtocol:writeMessageEnd()
end

function TBinaryProtocol:writeStructBegin()
end

function TBinaryProtocol:writeStructEnd()
end

function TBinaryProtocol:writeFieldBegin(_, ttype, id)
  self:writeByte(ttype)
  self:writeI16(id)
end

function TBinaryProtocol:writeFieldEnd()
end

function TBinaryProtocol:writeFieldStop()
  self:writeByte(TType.STOP);
end

function TBinaryProtocol:writeMapBegin(ktype, vtype, size)
  self:writeByte(ktype)
  self:writeByte(vtype)
  self:writeI32(size)
end

function TBinaryProtocol:writeMapEnd()
end

function TBinaryProtocol:writeListBegin(etype, size)
  self:writeByte(etype)
  self:writeI32(size)
end

function TBinaryProtocol:writeListEnd()
end

function TBinaryProtocol:writeSetBegin(etype, size)
  self:writeByte(etype)
  self:writeI32(size)
end

function TBinaryProtocol:writeSetEnd()
end

function TBinaryProtocol:writeBool(bool)
  if bool then
    self:writeByte(1)
  else
    self:writeByte(0)
  end
end

function TBinaryProtocol:writeByte(byte)
  local buff = libluabpack.bpack('c', byte)
  self.trans:write(buff)
end

function TBinaryProtocol:writeI16(i16)
  local buff = libluabpack.bpack('s', i16)
  self.trans:write(buff)
end

function TBinaryProtocol:writeI32(i32)
  local buff = libluabpack.bpack('i', i32)
  self.trans:write(buff)
end

function TBinaryProtocol:writeI64(i64)
  local buff = libluabpack.bpack('l', i64)
  self.trans:write(buff)
end

function TBinaryProtocol:writeDouble(dub)
  local buff = libluabpack.bpack('d', dub)
  self.trans:write(buff)
end

function TBinaryProtocol:writeString(str)
  -- Should be utf-8
  self:writeI32(string.len(str))
  self.trans:write(str)
end

function TBinaryProtocol:readMessageBegin()
  local sz, ttype, name, seqid = self:readI32()
  if sz < 0 then
    local version = libluabitwise.band(sz, TBinaryProtocol.VERSION_MASK)
    if version ~= TBinaryProtocol.VERSION_1 then
      terror(TProtocolException:new{
        message = 'Bad version in readMessageBegin: ' .. sz
      })
    end
    ttype = libluabitwise.band(sz, TBinaryProtocol.TYPE_MASK)
    name = self:readString()
    seqid = self:readI32()
  else
    if self.strictRead then
      terror(TProtocolException:new{message = 'No protocol version header'})
    end
    name = self.trans:readAll(sz)
    ttype = self:readByte()
    seqid = self:readI32()
  end
  return name, ttype, seqid
end

function TBinaryProtocol:readMessageEnd()
end

function TBinaryProtocol:readStructBegin()
  return nil
end

function TBinaryProtocol:readStructEnd()
end

function TBinaryProtocol:readFieldBegin()
  local ttype = self:readByte()
  if ttype == TType.STOP then
    return nil, ttype, 0
  end
  local id = self:readI16()
  return nil, ttype, id
end

function TBinaryProtocol:readFieldEnd()
end

function TBinaryProtocol:readMapBegin()
  local ktype = self:readByte()
  local vtype = self:readByte()
  local size = self:readI32()
  return ktype, vtype, size
end

function TBinaryProtocol:readMapEnd()
end

function TBinaryProtocol:readListBegin()
  local etype = self:readByte()
  local size = self:readI32()
  return etype, size
end

function TBinaryProtocol:readListEnd()
end

function TBinaryProtocol:readSetBegin()
  local etype = self:readByte()
  local size = self:readI32()
  return etype, size
end

function TBinaryProtocol:readSetEnd()
end

function TBinaryProtocol:readBool()
  local byte = self:readByte()
  if byte == 0 then
    return false
  end
  return true
end

function TBinaryProtocol:readByte()
  local buff = self.trans:readAll(1)
  local val = libluabpack.bunpack('c', buff)
  return val
end

function TBinaryProtocol:readI16()
  local buff = self.trans:readAll(2)
  local val = libluabpack.bunpack('s', buff)
  return val
end

function TBinaryProtocol:readI32()
  local buff = self.trans:readAll(4)
  local val = libluabpack.bunpack('i', buff)
  return val
end

function TBinaryProtocol:readI64()
  local buff = self.trans:readAll(8)
  local val = libluabpack.bunpack('l', buff)
  return val
end

function TBinaryProtocol:readDouble()
  local buff = self.trans:readAll(8)
  local val = libluabpack.bunpack('d', buff)
  return val
end

function TBinaryProtocol:readString()
  local len = self:readI32()
  local str = self.trans:readAll(len)
  return str
end

return TBinaryProtocol
