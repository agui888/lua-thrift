local bit32 = require 'bit32'
local class = require 'middleclass'
local libluabpack = require 'thrift.libluabpack'
local libluabitwise = require 'thrift.libluabitwise'
local TCompactType = require 'thrift.protocol.TCompactProtocolType'
local terror = require 'thrift.terror'
local Long = require 'long'
local TProtocol = require 'thrift.protocol.TProtocol'
local TProtocolException = require 'thrift.protocol.TProtocolException'
local TProtocolExceptionType = require 'thrift.protocol.TProtocolExceptionType'
local TType = require 'thrift.protocol.TType'

local TCompactProtocol = class('TCompactProtocol', TProtocol)

TCompactProtocol.COMPACT_PROTOCOL_ID       = 0x82
TCompactProtocol.COMPACT_VERSION           = 1
TCompactProtocol.COMPACT_VERSION_MASK      = 0x1f
TCompactProtocol.COMPACT_TYPE_MASK         = 0xE0
TCompactProtocol.COMPACT_TYPE_BITS         = 0x07
TCompactProtocol.COMPACT_TYPE_SHIFT_AMOUNT = 5

function TCompactProtocol:initialize(trans)
  TProtocol.initialize(self, trans)
  
  -- Used to keep track of the last field for the current and previous structs,
  -- so we can do the delta stuff.
  self.lastField = {}
  self.lastFieldId = 0
  self.lastFieldIndex = 1

  -- If we encounter a boolean field begin, save the TField here so it can
  -- have the value incorporated.
  self.booleanFieldName    = ""
  self.booleanFieldId      = 0
  self.booleanFieldPending = false

  -- If we read a field header, and it's a boolean field, save the boolean
  -- value here so that readBool can use it.
  self.boolValue          = false
  self.boolValueIsNotNull = false
end

local TTypeToCompactType = {
  [TType.STOP]   = TType.STOP,
  [TType.BOOL]   = TCompactType.COMPACT_BOOLEAN_TRUE,
  [TType.BYTE]   = TCompactType.COMPACT_BYTE,
  [TType.I16]    = TCompactType.COMPACT_I16,
  [TType.I32]    = TCompactType.COMPACT_I32,
  [TType.I64]    = TCompactType.COMPACT_I64,
  [TType.DOUBLE] = TCompactType.COMPACT_DOUBLE,
  [TType.STRING] = TCompactType.COMPACT_BINARY,
  [TType.LIST]   = TCompactType.COMPACT_LIST,
  [TType.SET]    = TCompactType.COMPACT_SET,
  [TType.MAP]    = TCompactType.COMPACT_MAP,
  [TType.STRUCT] = TCompactType.COMPACT_STRUCT
}

local CompactTypeToTType = {
  [TType.STOP]                        = TType.STOP,
  [TCompactType.COMPACT_BOOLEAN_TRUE] = TType.BOOL,
  [TCompactType.COMPACT_BOOLEAN_FALSE]= TType.BOOL,
  [TCompactType.COMPACT_BYTE]         = TType.BYTE,
  [TCompactType.COMPACT_I16]          = TType.I16,
  [TCompactType.COMPACT_I32]          = TType.I32,
  [TCompactType.COMPACT_I64]          = TType.I64,
  [TCompactType.COMPACT_DOUBLE]       = TType.DOUBLE,
  [TCompactType.COMPACT_BINARY]       = TType.STRING,
  [TCompactType.COMPACT_LIST]         = TType.LIST,
  [TCompactType.COMPACT_SET]          = TType.SET,
  [TCompactType.COMPACT_MAP]          = TType.MAP,
  [TCompactType.COMPACT_STRUCT]       = TType.STRUCT
}

function TCompactProtocol:resetLastField()
  self.lastField = {}
  self.lastFieldId = 0
  self.lastFieldIndex = 1
end

function TCompactProtocol:packCompactType(ktype, vtype)
  return libluabitwise.bor(libluabitwise.shiftl(ktype, 4), vtype)
end

function TCompactProtocol:writeMessageBegin(name, ttype, seqid)
  self:writeByte(TCompactProtocol.COMPACT_PROTOCOL_ID)
  self:writeByte(libluabpack.packMesgType(
    TCompactProtocol.COMPACT_VERSION,
    TCompactProtocol.COMPACT_VERSION_MASK,
    ttype,
    TCompactProtocol.COMPACT_TYPE_SHIFT_AMOUNT,
    TCompactProtocol.COMPACT_TYPE_MASK))
  self:writeVarint32(seqid)
  self:writeString(name)
  self:resetLastField()
end

function TCompactProtocol:writeMessageEnd()
end

function TCompactProtocol:writeStructBegin()
  self.lastFieldIndex = self.lastFieldIndex + 1
  self.lastField[self.lastFieldIndex] = self.lastFieldId
  self.lastFieldId = 0
end

function TCompactProtocol:writeStructEnd()
  self.lastFieldIndex = self.lastFieldIndex - 1
  self.lastFieldId = self.lastField[self.lastFieldIndex]
end

function TCompactProtocol:writeFieldBegin(name, ttype, id)
  if ttype == TType.BOOL then
    self.booleanFieldName = name
    self.booleanFieldId   = id
    self.booleanFieldPending = true
  else
    self:writeFieldBeginInternal(name, ttype, id, -1)
  end
end

function TCompactProtocol:writeFieldEnd()
end

function TCompactProtocol:writeFieldStop()
  self:writeByte(TType.STOP);
end

function TCompactProtocol:writeMapBegin(ktype, vtype, size)
  if size == 0 then
    self:writeByte(0)
  else
    self:writeVarint32(size)
    self:writeByte(self:packCompactType(TTypeToCompactType[ktype], TTypeToCompactType[vtype]))
  end
end

function TCompactProtocol:writeMapEnd()
end

function TCompactProtocol:writeListBegin(etype, size)
  self:writeCollectionBegin(etype, size)
end

function TCompactProtocol:writeListEnd()
end

function TCompactProtocol:writeSetBegin(etype, size)
  self:writeCollectionBegin(etype, size)
end

function TCompactProtocol:writeSetEnd()
end

function TCompactProtocol:writeBool(bool)
  local value = TCompactType.COMPACT_BOOLEAN_FALSE
  if bool then
    value = TCompactType.COMPACT_BOOLEAN_TRUE
  end
  if self.booleanFieldPending then
    self:writeFieldBeginInternal(self.booleanFieldName, TType.BOOL, self.booleanFieldId, value)
    self.booleanFieldPending = false
  else
    self:writeByte(value)
  end
end

function TCompactProtocol:writeByte(byte)
  local buff = libluabpack.bpack('c', byte)
  self.trans:write(buff)
end

function TCompactProtocol:writeI16(i16)
  self:writeVarint32(libluabpack.i32ToZigzag(i16))
end

function TCompactProtocol:writeI32(i32)
  self:writeVarint32(libluabpack.i32ToZigzag(i32))
end

function TCompactProtocol:writeI64(i64)
  self:writeVarint64(libluabpack.i64ToZigzag(i64))
end

function TCompactProtocol:writeDouble(dub)
  local buff = libluabpack.bpack('d', dub)
  self.trans:write(buff)
end

function TCompactProtocol:writeString(str)
  -- Should be utf-8
  self:writeBinary(str)
end

function TCompactProtocol:writeBinary(str)
  -- Should be utf-8
  self:writeVarint32(string.len(str))
  self.trans:write(str)
end

function TCompactProtocol:writeFieldBeginInternal(_, ttype, id, typeOverride)
  if typeOverride == -1 then
    typeOverride = TTypeToCompactType[ttype]
  end
  local offset = id - self.lastFieldId
  if id > self.lastFieldId and offset <= 15 then
    self:writeByte(libluabitwise.bor(libluabitwise.shiftl(offset, 4), typeOverride))
  else
    self:writeByte(typeOverride)
    self:writeI16(id)
  end
  self.lastFieldId = id
end

function TCompactProtocol:writeCollectionBegin(etype, size)
  if size <= 14 then
    self:writeByte(libluabitwise.bor(libluabitwise.shiftl(size, 4), TTypeToCompactType[etype]))
  else
    self:writeByte(libluabitwise.bor(0xf0, TTypeToCompactType[etype]))
    self:writeVarint32(size)
  end
end

function TCompactProtocol:writeVarint32(i32)
  -- Should be utf-8
  local str = libluabpack.toVarint32(i32)
  self.trans:write(str)
end

function TCompactProtocol:writeVarint64(i64)
  -- Should be utf-8
  local str = libluabpack.toVarint64(i64)
  self.trans:write(str)
end

function TCompactProtocol:readMessageBegin()
  local protocolId = self:readSignByte()
  if protocolId ~= self.COMPACT_PROTOCOL_ID then
    terror(TProtocolException:new(
      "Expected protocol id " .. self.COMPACT_PROTOCOL_ID .. " but got " .. protocolId))
  end
  local versionAndType = self:readSignByte()
  local version = libluabitwise.band(versionAndType, self.COMPACT_VERSION_MASK)
  local ttype = libluabitwise.band(libluabitwise.shiftr(versionAndType,
    self.COMPACT_TYPE_SHIFT_AMOUNT), self.COMPACT_TYPE_BITS)
  if version ~= self.COMPACT_VERSION then
    terror(TProtocolException:new(
      "Expected version " .. self.COMPACT_VERSION .. " but got " .. version))
  end
  local seqid = self:readVarint32()
  local name = self:readString()
  return name, ttype, seqid
end

function TCompactProtocol:readMessageEnd()
end

function TCompactProtocol:readStructBegin()
  self.lastField[self.lastFieldIndex] = self.lastFieldId
  self.lastFieldIndex = self.lastFieldIndex + 1
  self.lastFieldId = 0
  return nil
end

function TCompactProtocol:readStructEnd()
  self.lastFieldIndex = self.lastFieldIndex - 1
  self.lastFieldId = self.lastField[self.lastFieldIndex]
end

function TCompactProtocol:readFieldBegin()
  local field_and_ttype = self:readSignByte()
  local ttype = self:getTType(field_and_ttype)
  if ttype == TType.STOP then
    return nil, ttype, 0
  end
  -- mask off the 4 MSB of the type header. it could contain a field id delta.
  local modifier = libluabitwise.shiftr(libluabitwise.band(field_and_ttype, 0xf0), 4)
  local id = 0
  if modifier == 0 then
    id = self:readI16()
  else
    id = self.lastFieldId + modifier
  end
  if ttype == TType.BOOL then
    self.boolValue = libluabitwise.band(field_and_ttype, 0x0f) == TCompactType.COMPACT_BOOLEAN_TRUE
    self.boolValueIsNotNull = true
  end
  self.lastFieldId = id
  return nil, ttype, id
end

function TCompactProtocol:readFieldEnd()
end

function TCompactProtocol:readMapBegin()
  local size = self:readVarint32()
  if size < 0 then
    return nil,nil,nil
  end
  local kvtype = self:readSignByte()
  local ktype = self:getTType(libluabitwise.shiftr(kvtype, 4))
  local vtype = self:getTType(kvtype)
  return ktype, vtype, size
end

function TCompactProtocol:readMapEnd()
end

function TCompactProtocol:readListBegin()
  local size_and_type = self:readSignByte()
  local size = libluabitwise.band(libluabitwise.shiftr(size_and_type, 4), 0x0f)
  if size == 15 then
    size = self:readVarint32()
  end
  if size < 0 then
    return nil,nil
  end
  local etype = self:getTType(libluabitwise.band(size_and_type, 0x0f))
  return etype, size
end

function TCompactProtocol:readListEnd()
end

function TCompactProtocol:readSetBegin()
  return self:readListBegin()
end

function TCompactProtocol:readSetEnd()
end

function TCompactProtocol:readBool()
  if self.boolValueIsNotNull then
    self.boolValueIsNotNull = true
    return self.boolValue
  end
  local val = self:readSignByte()
  if val == TCompactType.COMPACT_BOOLEAN_TRUE then
    return true
  end
  return false
end

function TCompactProtocol:readByte()
  local buff = self.trans:readAll(1)
  local val = libluabpack.bunpack('C', buff)
  return val
end

function TCompactProtocol:readSignByte()
  local buff = self.trans:readAll(1)
  local val = libluabpack.bunpack('c', buff)
  return val
end

function TCompactProtocol:readI16()
  return self:readI32()
end

function TCompactProtocol:readI32()
  local v = self:readVarint32()
  local value = libluabpack.zigzagToI32(v)
  return value
end

function TCompactProtocol:readI64()
  local v = self:readVarint64()
  local value = libluabpack.zigzagToI64(v)
  return value
end

function TCompactProtocol:readDouble()
  local buff = self.trans:readAll(8)
  local val = libluabpack.bunpack('d', buff)
  return val
end

function TCompactProtocol:readString()
  return self:readBinary()
end

function TCompactProtocol:readBinary()
  local size = self:readVarint32()
  if size <= 0 then
    return ""
  end
  return self.trans:readAll(size)
end

function TCompactProtocol:readVarint32()
  local shiftl = 0
  local result = 0
  while true do
    local b = self:readByte()
    result = libluabitwise.bor(result,
             libluabitwise.shiftl(libluabitwise.band(b, 0x7f), shiftl))
    if libluabitwise.band(b, 0x80) ~= 0x80 then
      break
    end
    shiftl = shiftl + 7
  end
  return result
end

function TCompactProtocol:readVarint64()
  local rsize, lo, hi, shift = 0, 0, 0, 0
  while true do
    local b = self:readSignByte()
    rsize = rsize + 1
    if shift <= 25 then
      lo = bit32.bor(lo, bit32.lshift(bit32.band(b, 0x7f), shift))
    elseif 25 < shift and shift < 32 then
      lo = bit32.bor(lo, bit32.lshift(bit32.band(b, 0x7f), shift))
      hi = bit32.bor(hi, bit32.rshift(bit32.band(b, 0x7f), 32 - shift))
    else
      hi = bit32.bor(hi, bit32.lshift(bit32.band(b, 0x7f), shift - 32))
    end
    shift = shift + 7
    if bit32.band(b, 0x80) == 0 then break end
    if rsize >= 10 then
      terror(TProtocolException:new("Variable-length int over 10 bytes", TProtocolExceptionType.INVALID_DATA))
    end
  end
  return Long.fromBits(lo, hi, true)
end

function TCompactProtocol:getTType(ctype)
  return CompactTypeToTType[libluabitwise.band(ctype, 0x0f)]
end

return TCompactProtocol
