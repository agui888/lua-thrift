local TProtocolException = require 'thrift.protocol.TProtocolException'
local TProtocolExceptionType = require 'thrift.protocol.TProtocolExceptionType'

describe('TProtocolException', function()

  it('constructs', function()
    local e = TProtocolException:new(nil, TProtocolExceptionType.NEGATIVE_SIZE)
    assert.equal(nil, e.message)
    assert.equal('TProtocolException:2: Negative size', tostring(e))
  end)
  
end)
