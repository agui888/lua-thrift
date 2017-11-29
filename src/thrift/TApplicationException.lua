local class = require 'middleclass'
local TApplicationExceptionType = require 'thrift.TApplicationExceptionType'
local TException = require 'thrift.TException'
local TType = require 'thrift.protocol.TType'

local TApplicationException = class('TApplicationException', TException)

function TApplicationException:__errorCodeToString()
  if self.errorCode == TApplicationExceptionType.UNKNOWN_METHOD then
    return 'Unknown method'
  elseif self.errorCode == TApplicationExceptionType.INVALID_MESSAGE_TYPE then
    return 'Invalid message type'
  elseif self.errorCode == TApplicationExceptionType.WRONG_METHOD_NAME then
    return 'Wrong method name'
  elseif self.errorCode == TApplicationExceptionType.BAD_SEQUENCE_ID then
    return 'Bad sequence ID'
  elseif self.errorCode == TApplicationExceptionType.MISSING_RESULT then
    return 'Missing result'
  elseif self.errorCode == TApplicationExceptionType.INTERNAL_ERROR then
    return 'Internal error'
  elseif self.errorCode == TApplicationExceptionType.PROTOCOL_ERROR then
    return 'Protocol error'
  elseif self.errorCode == TApplicationExceptionType.INVALID_TRANSFORM then
    return 'Invalid transform'
  elseif self.errorCode == TApplicationExceptionType.INVALID_PROTOCOL then
    return 'Invalid protocol'
  elseif self.errorCode == TApplicationExceptionType.UNSUPPORTED_CLIENT_TYPE then
    return 'Unsupported client type'
  else
    return 'Default (unknown)'
  end
end

function TApplicationException:read(iprot)
  iprot:readStructBegin()
  while true do
    local _, ftype, fid = iprot:readFieldBegin()
    if ftype == TType.STOP then
      break
    elseif fid == 1 then
      if ftype == TType.STRING then
        self.message = iprot:readString()
      else
        iprot:skip(ftype)
      end
    elseif fid == 2 then
      if ftype == TType.I32 then
        self.errorCode = iprot:readI32()
      else
        iprot:skip(ftype)
      end
    else
      iprot:skip(ftype)
    end
    iprot:readFieldEnd()
  end
  iprot:readStructEnd()
end

function TApplicationException:write(oprot)
  oprot:writeStructBegin('TApplicationException')
  if self.message then
    oprot:writeFieldBegin('message', TType.STRING, 1)
    oprot:writeString(self.message)
    oprot:writeFieldEnd()
  end
  if self.errorCode then
    oprot:writeFieldBegin('type', TType.I32, 2)
    oprot:writeI32(self.errorCode)
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end

return TApplicationException
