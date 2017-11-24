local Long = require 'thrift.liblualongnumber'

describe('liblualongnumber', function()

  it('numeric constructors', function()
    assert.equal('0', tostring(Long.new(0)))
    assert.equal('1', tostring(Long.new(1)))
    assert.equal('-1', tostring(Long.new(-1)))
  end)

  it('string constructors', function()
    assert.equal('0', tostring(Long.new('0')))
    assert.equal('1', tostring(Long.new('1')))
    assert.equal('-1', tostring(Long.new('-1')))
  end)

end)
