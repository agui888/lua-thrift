local TSocket = require 'thrift.TSocket'

describe('TMemoryBuffer', function()

  it('constructor', function()
    local socket = TSocket:new()
    assert.equal(false, socket:isOpen())
  end)
  
end)
