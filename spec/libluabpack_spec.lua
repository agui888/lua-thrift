local libluabpack = require 'thrift.libluabpack'

describe('libluabpack', function()

  -- Expected values from https://developers.google.com/protocol-buffers/docs/encoding
  it('ZigZag encodes 32-bit signed integers', function()
    assert.equal(0, libluabpack.i32ToZigzag(0))
    assert.equal(1, libluabpack.i32ToZigzag(-1))
    assert.equal(2, libluabpack.i32ToZigzag(1))
    assert.equal(3, libluabpack.i32ToZigzag(-2))
    assert.equal(4294967294, libluabpack.i32ToZigzag(2147483647))
    assert.equal(4294967295, libluabpack.i32ToZigzag(-2147483648))
  end)
  
  it('ZigZag encodes 33+ bit signed integers', function()
    assert.equal(0, libluabpack.i64ToZigzag(0))
    assert.equal(1, libluabpack.i64ToZigzag(-1))
    assert.equal(2, libluabpack.i64ToZigzag(1))
    assert.equal(3, libluabpack.i64ToZigzag(-2))
    assert.equal(4294967294, libluabpack.i64ToZigzag(2147483647))
    assert.equal(4294967295, libluabpack.i64ToZigzag(-2147483648))
    
    assert.equal(4294967296, libluabpack.i64ToZigzag(2147483648))
    assert.equal(4294967297, libluabpack.i64ToZigzag(-2147483649))
    assert.equal(4294967298, libluabpack.i64ToZigzag(2147483649))
    assert.equal(4294967299, libluabpack.i64ToZigzag(-2147483650))
    assert.equal(4294967300, libluabpack.i64ToZigzag(2147483650))
  end)
  
end)
