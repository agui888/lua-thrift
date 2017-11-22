local class = require 'middleclass'
local terror = require 'thrift.terror'
local TTransportException = require 'thrift.TTransportException'

local TTransport = class('TTransport')

function TTransport:isOpen() end
function TTransport:open() end
function TTransport:close() end
function TTransport:read() end

function TTransport:readAll(len)
  local buf, have, chunk = '', 0
  while have < len do
    chunk = self:read(len - have)
    have = have + string.len(chunk)
    buf = buf .. chunk

    if string.len(chunk) == 0 then
      terror(TTransportException:new{
        errorCode = TTransportException.END_OF_FILE
      })
    end
  end
  return buf
end

function TTransport:write() end
function TTransport:flush() end

return TTransport
