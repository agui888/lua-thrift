local M = {}

-- consts
M.version = 0.10
M.TApplicationExceptionType = require 'thrift.TApplicationExceptionType'
M.TCompactType = require 'thrift.TCompactType'
M.TMessageType = require 'thrift.TMessageType'
M.TProtocolExceptionType = require 'thrift.TProtocolExceptionType'
M.TTransportExceptionType = require 'thrift.TTransportExceptionType'
M.TType = require 'thrift.TType'

-- exceptions
M.TException = require 'thrift.TException'
M.TApplicationException = require 'thrift.TApplicationException'
M.TProtocolException = require 'thrift.TProtocolException'
M.TTransportException = require 'thrift.TTransportException'

-- classes
M.TBinaryProtocol = require 'thrift.TBinaryProtocol'
M.TBinaryProtocolFactory = require 'thrift.TBinaryProtocolFactory'
M.TBufferedTransport = require 'thrift.TBufferedTransport'
M.TBufferedTransportFactory = require 'thrift.TBufferedTransportFactory'
M.TCompactProtocol = require 'thrift.TCompactProtocol'
M.TCompactProtocolFactory = require 'thrift.TCompactProtocolFactory'
M.TFramedTransport = require 'thrift.TFramedTransport'
M.TFramedTransportFactory = require 'thrift.TFramedTransportFactory'
M.THttpTransport = require 'thrift.THttpTransport'
M.THttpTransportFactory = require 'thrift.THttpTransportFactory'
M.TJsonProtocol = require 'thrift.TJsonProtocol'
M.TJsonProtocolFactory = require 'thrift.TJsonProtocolFactory'
M.TMemoryBuffer = require 'thrift.TMemoryBuffer'
M.TProtocol = require 'thrift.TProtocol'
M.TProtocolFactory = require 'thrift.TProtocolFactory'
M.TServer = require 'thrift.TServer'
--M.TServerSocket = require 'thrift.TServerSocket'
M.TServerTransport = require 'thrift.TServerTransport'
M.TSimpleServer = require 'thrift.TSimpleServer'
M.TSocket = require 'thrift.TSocket'
M.TTransport = require 'thrift.TTransport'
M.TTransportFactory = require 'thrift.TTransportFactory'

return M
