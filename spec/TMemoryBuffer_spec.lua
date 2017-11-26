local TMemoryBuffer = require 'thrift.TMemoryBuffer'

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
  
end)
