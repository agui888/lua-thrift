local TException = require 'thrift.TException'

describe('TException', function()

  it('constructs', function()
    local e = TException:new('abc')
    assert.equal('abc', e.message)
    assert.equal('TException: abc', tostring(e))
  end)
  
end)
