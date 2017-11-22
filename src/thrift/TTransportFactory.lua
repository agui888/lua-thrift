local class = require 'middleclass'

local TTransportFactory = class('TTransportFactory')

function TTransportFactory:getTransport(trans)
  return trans
end

return TTransportFactory
