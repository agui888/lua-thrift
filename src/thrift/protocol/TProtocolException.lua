local class = require 'middleclass'
local TException = require 'thrift.TException'
local TProtocolExceptionType = require 'thrift.protocol.TProtocolExceptionType'

local TProtocolException = class('TProtocolException', TException)

function TProtocolException:initialize(message, code)
  TException.initialize(self, message)
  self.errorCode = code or 0
end

function TProtocolException:__errorCodeToString()
  if self.errorCode == TProtocolExceptionType.INVALID_DATA then
    return 'Invalid data'
  elseif self.errorCode == TProtocolExceptionType.NEGATIVE_SIZE then
    return 'Negative size'
  elseif self.errorCode == TProtocolExceptionType.SIZE_LIMIT then
    return 'Size limit'
  elseif self.errorCode == TProtocolExceptionType.BAD_VERSION then
    return 'Bad version'
  elseif self.errorCode == TProtocolExceptionType.INVALID_PROTOCOL then
    return 'Invalid protocol'
  elseif self.errorCode == TProtocolExceptionType.DEPTH_LIMIT then
    return 'Exceeded size limit'
  else
    return 'Default (unknown)'
  end
end

return TProtocolException
