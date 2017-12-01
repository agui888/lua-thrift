local liblualongnumber = require 'thrift.liblualongnumber'
local print_r = require 'thrift.print_r'
local TApplicationException = require 'thrift.TApplicationException'
local TBinaryProtocol = require 'thrift.protocol.TBinaryProtocol'
local TBufferedTransport = require 'thrift.transport.TBufferedTransport'
local TCompactProtocol = require 'thrift.protocol.TCompactProtocol'
local TFramedTransport = require 'thrift.transport.TFramedTransport'
local THttpTransport = require 'thrift.transport.THttpTransport'
local TJsonProtocol = require 'thrift.protocol.TJsonProtocol'
local TMemoryBuffer = require 'thrift.transport.TMemoryBuffer'
local TProtocolException = require 'thrift.protocol.TProtocolException'
local TServerSocket = require 'thrift.transport.TServerSocket'
local TServerTransport = require 'thrift.transport.TServerTransport'
local TSocket = require 'thrift.transport.TSocket'
local TTransportException = require 'thrift.transport.TTransportException'

describe('print_r', function()

  it('liblualongnumber', function()
    print_r(liblualongnumber.new(23))
  end)
  
  it('TApplicationException', function()
    print_r(TApplicationException:new('msg'))
  end)
  
  it('TBinaryProtocol', function()
    print_r(TBinaryProtocol:new(TMemoryBuffer:new()))
  end)
  
  it('TBufferedTransport', function()
    print_r(TBufferedTransport:new(TMemoryBuffer:new()))
  end)
  
  it('TCompactProtocol', function()
    print_r(TCompactProtocol:new(TMemoryBuffer:new()))
  end)
  
  it('TFramedTransport', function()
    print_r(TFramedTransport:new())
  end)
  
  it('THttpTransport', function()
    print_r(THttpTransport:new())
  end)
  
  it('TJsonProtocol', function()
    print_r(TJsonProtocol:new(TMemoryBuffer:new()))
  end)
  
  it('TMemoryBuffer', function()
    print_r(TMemoryBuffer:new())
  end)
  
  it('TProtocolException', function()
    print_r(TProtocolException:new('msg'))
  end)
  
  it('TServerSocket', function()
    print_r(TServerSocket:new())
  end)
  
  it('TServerTransport', function()
    print_r(TServerTransport:new())
  end)
  
  it('TSocket', function()
    print_r(TSocket:new())
  end)
  
  it('TTransportException', function()
    print_r(TTransportException:new('msg'))
  end)
  
end)
