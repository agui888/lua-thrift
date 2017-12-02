local TCompactProtocol = require 'thrift.protocol.TCompactProtocol'
local TFramedTransport = require 'thrift.transport.TFramedTransport'
local TMemoryBuffer = require 'thrift.transport.TMemoryBuffer'

describe('TCompactProtocol', function()

  describe('model3.snappy.parquet', function()
  
    it('can read expected signed bytes', function()
      local file = assert(io.open('spec-fixtures/model3.snappy.parquet', 'r'))
      file:seek('set', 4)
      local buf = file:read(925)
      local transport = TFramedTransport:new(buf)
      local protocol = TCompactProtocol:new(transport)
      assert.equal(21, protocol:readSignByte())
      assert.equal(02, protocol:readSignByte())
      assert.equal(25, protocol:readSignByte())
      assert.equal(-68, protocol:readSignByte())
    end)
    
    it('can read a varint64', function()
      local protocol = TCompactProtocol:new(TMemoryBuffer:new())
      protocol:writeByte(-128)
      protocol:writeByte(-15)
      protocol:writeByte(4)
      assert.equal(80000, protocol:readVarint64():toInt())
    end)
    
  end)
  
end)
