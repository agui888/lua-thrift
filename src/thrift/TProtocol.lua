local class = require 'middleclass'
local TType = require 'thrift.TType'

local TProtocol = class('TProtocol')

function TProtocol:initialize(trans)
  -- Ensure a transport is provided
  if not trans then
    error('You must provide ' .. self.class .. ' with a trans')
  end
  self.trans = trans
end

function TProtocol:writeMessageBegin() end
function TProtocol:writeMessageEnd() end
function TProtocol:writeStructBegin() end
function TProtocol:writeStructEnd() end
function TProtocol:writeFieldBegin() end
function TProtocol:writeFieldEnd() end
function TProtocol:writeFieldStop() end
function TProtocol:writeMapBegin() end
function TProtocol:writeMapEnd() end
function TProtocol:writeListBegin() end
function TProtocol:writeListEnd() end
function TProtocol:writeSetBegin() end
function TProtocol:writeSetEnd() end
function TProtocol:writeBool() end
function TProtocol:writeByte() end
function TProtocol:writeI16() end
function TProtocol:writeI32() end
function TProtocol:writeI64() end
function TProtocol:writeDouble() end
function TProtocol:writeString() end
function TProtocol:readMessageBegin() end
function TProtocol:readMessageEnd() end
function TProtocol:readStructBegin() end
function TProtocol:readStructEnd() end
function TProtocol:readFieldBegin() end
function TProtocol:readFieldEnd() end
function TProtocol:readMapBegin() end
function TProtocol:readMapEnd() end
function TProtocol:readListBegin() end
function TProtocol:readListEnd() end
function TProtocol:readSetBegin() end
function TProtocol:readSetEnd() end
function TProtocol:readBool() end
function TProtocol:readByte() end
function TProtocol:readI16() end
function TProtocol:readI32() end
function TProtocol:readI64() end
function TProtocol:readDouble() end
function TProtocol:readString() end

function TProtocol:skip(ttype)
  if type == TType.STOP then
    return
  elseif ttype == TType.BOOL then
    self:readBool()
  elseif ttype == TType.BYTE then
    self:readByte()
  elseif ttype == TType.I16 then
    self:readI16()
  elseif ttype == TType.I32 then
    self:readI32()
  elseif ttype == TType.I64 then
    self:readI64()
  elseif ttype == TType.DOUBLE then
    self:readDouble()
  elseif ttype == TType.STRING then
    self:readString()
  elseif ttype == TType.STRUCT then
    self:readStructBegin()
    while true do
      local _, ttype2, _ = self:readFieldBegin()
      if ttype2 == TType.STOP then
        break
      end
      self:skip(ttype)
      self:readFieldEnd()
    end
    self:readStructEnd()
  elseif ttype == TType.MAP then
    local kttype, vttype, size = self:readMapBegin()
    for i = 1, size, 1 do
      self:skip(kttype)
      self:skip(vttype)
    end
    self:readMapEnd()
  elseif ttype == TType.SET then
    local ettype, size = self:readSetBegin()
    for i = 1, size, 1 do
      self:skip(ettype)
    end
    self:readSetEnd()
  elseif ttype == TType.LIST then
    local ettype, size = self:readListBegin()
    for i = 1, size, 1 do
      self:skip(ettype)
    end
    self:readListEnd()
  end
end

return TProtocol
