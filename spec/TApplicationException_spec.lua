local TApplicationException = require 'thrift.TApplicationException'
local TApplicationExceptionType = require 'thrift.TApplicationExceptionType'

describe('TApplicationException', function()

  it('constructs', function()
    local e = TApplicationException:new(nil, TApplicationExceptionType.BAD_SEQUENCE_ID)
    assert.equal(nil, e.message)
    assert.equal('TApplicationException:4: Bad sequence ID', tostring(e))
  end)
  
end)
