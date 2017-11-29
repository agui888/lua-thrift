local TSocket = require 'thrift.transport.TSocket'

describe('TSocket', function()

  it('constructor', function()
    local socket = TSocket:new()
    assert.equal(false, socket:isOpen())
  end)
  
end)
