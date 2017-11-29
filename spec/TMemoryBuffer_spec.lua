local TCompactProtocol = require 'thrift.protocol.TCompactProtocol'
local TMemoryBuffer = require 'thrift.transport.TMemoryBuffer'

describe('TMemoryBuffer', function()

  it('constructor', function()
    local transport = TMemoryBuffer:new()
    assert(true, transport:isOpen())
  end)
  
  it('writes', function()
    local transport = TMemoryBuffer:new()
    transport:write('abc')
    transport:write('123')
    assert.equal('abc123', transport:getBuffer())
  end)
  
  it('reads', function()
    local transport = TMemoryBuffer:new()
    transport:write('abc')
    assert.equal(3, transport:available())
    
    transport:write('123')
    assert.equal(6, transport:available())
    
    assert.equal('ab', transport:read(2))
    assert.equal(4, transport:available())
    
    assert.equal('c1', transport:read(2))
    assert.equal(2, transport:available())
    
    assert.equal('23', transport:read(2))
    assert.equal(0, transport:available())
    
    assert.equal('', transport:read(1))
    assert.equal(0, transport:available())
  end)
  
  it('double', function()
    local transport = TMemoryBuffer:new(1000)
    local proto = TCompactProtocol:new(transport)
    proto:writeDouble(123.456)
    assert.equal(123.456, proto:readDouble())
  end)
  
end)
