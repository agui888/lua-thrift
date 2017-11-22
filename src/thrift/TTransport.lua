local class = require 'middleclass'

local TTransport = class('TTransport')

function TTransport:isOpen() end
function TTransport:open() end
function TTransport:close() end
function TTransport:read(len) end

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

function TTransport:write(buf) end
function TTransport:flush() end

return TTransport
