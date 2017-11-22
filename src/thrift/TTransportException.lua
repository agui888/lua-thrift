local class = require 'middleclass'
local TException = require 'thrift.TException'
local TTransportExceptionType = require 'thrift.TTransportExceptionType'

local TTransportException = class('TTransportException', TException)

function TTransportException:__errorCodeToString()
  if self.errorCode == TTransportExceptionType.NOT_OPEN then
    return 'Transport not open'
  elseif self.errorCode == TTransportExceptionType.ALREADY_OPEN then
    return 'Transport already open'
  elseif self.errorCode == TTransportExceptionType.TIMED_OUT then
    return 'Transport timed out'
  elseif self.errorCode == TTransportExceptionType.END_OF_FILE then
    return 'End of file'
  elseif self.errorCode == TTransportExceptionType.INVALID_FRAME_SIZE then
    return 'Invalid frame size'
  elseif self.errorCode == TTransportExceptionType.INVALID_TRANSFORM then
    return 'Invalid transform'
  elseif self.errorCode == TTransportExceptionType.INVALID_CLIENT_TYPE then
    return 'Invalid client type'
  else
    return 'Default (unknown)'
  end
end

return TTransportException
