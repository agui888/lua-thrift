local TBufferedTransport = require 'thrift.transport.TBufferedTransport'
local TMemoryBuffer = require 'thrift.transport.TMemoryBuffer'

describe('TBufferedTransport', function()

  it('buffers writes', function()
    local memoryBuffer = TMemoryBuffer:new()
    local transport = TBufferedTransport:new(memoryBuffer)
    
    assert.equal(0, memoryBuffer:available())
    
    transport:write('abc')
    assert.equal(0, memoryBuffer:available())
    
    transport:write('123')
    assert.equal(0, memoryBuffer:available())
    
    transport:flush()
    assert.equal(6, memoryBuffer:available())
  end)
  
end)
