local class = require 'middleclass'
local print_r = require 'thrift.print_r'

local TException = class('TException')

function TException:initialize(message, errorCode)
  self.message = message
  self.errorCode = errorCode
end

function TException:__tostring()
  if self.message then
    return string.format('%s: %s', self.class.name, self.message)
  else
    local message
    if self.errorCode and self.__errorCodeToString then
      message = string.format('%d: %s', self.errorCode, self:__errorCodeToString())
    else
      message = print_r(self)
    end
    return string.format('%s:%s', self.class.name, message)
  end
end

return TException
