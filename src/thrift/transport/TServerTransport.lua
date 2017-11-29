local class = require 'middleclass'
local TTransport = require 'thrift.transport.TTransport'

local TServerTransport = class('TServerTransport', TTransport)

function TServerTransport:listen() end
function TServerTransport:accept() end
function TServerTransport:close() end

return TServerTransport
