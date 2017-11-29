local TTransportException = require 'thrift.transport.TTransportException'
local TTransportExceptionType = require 'thrift.transport.TTransportExceptionType'

describe('TTransportException', function()

  it('constructs', function()
    local e = TTransportException:new(nil, TTransportExceptionType.ALREADY_OPEN)
    assert.equal(nil, e.message)
    assert.equal('TTransportException:2: Transport already open', tostring(e))
  end)
  
end)
