local class = require 'middleclass'

local TProtocolFactory = class('TProtocolFactory')

function TProtocolFactory:getProtocol(trans) end

return TProtocolFactory

