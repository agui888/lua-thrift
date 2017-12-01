local class = require 'middleclass'
local TTransport = require 'thrift.transport.TTransport'

local TFramedTransport = class('TFramedTransport', TTransport)

function TFramedTransport:initialize(buffer, callback)
  TTransport.initialize(self)
  self.inBuf = buffer or ''
  self.outBuffers = {}
  self.outCount = 0
  self.readPos = 1
  self.onFlush = callback
end

function TFramedTransport:close() end

function TFramedTransport:ensureAvailable(len)
  assert(self.readPos + len - 1 <= #self.inBuf, 'Input buffer underrun')
end

function TFramedTransport:isOpen()
  return true
end

function TFramedTransport:open() end

function TFramedTransport:read(len)
  self:ensureAvailable(len)
  local endInclusive = self.readPos + len
  local buf = string.sub(self.inBuf, self.readPos, endInclusive - 1)
  self.readPos = endInclusive
  return buf
end

--TFramedTransport.prototype.borrow = function() {
--  return {
--    buf: this.inBuf,
--    readIndex: this.readPos,
--    writeIndex: this.inBuf.length
--  };
--};

function TFramedTransport:consume(bytesConsumed)
  self.readPos = self.readPos + bytesConsumed
end

--TFramedTransport.prototype.write = function(buf, encoding) {
--  if (typeof(buf) === "string") {
--    buf = new Buffer(buf, encoding || 'utf8');
--  }
--  this.outBuffers.push(buf);
--  this.outCount += buf.length;
--};
--
--TFramedTransport.prototype.flush = function() {
--  // If the seqid of the callback is available pass it to the onFlush
--  // Then remove the current seqid
--  var seqid = this._seqid;
--  this._seqid = null;
--
--  var out = new Buffer(this.outCount),
--      pos = 0;
--  this.outBuffers.forEach(function(buf) {
--    buf.copy(out, pos, 0);
--    pos += buf.length;
--  });
--
--  if (this.onFlush) {
--    // TODO: optimize this better, allocate one buffer instead of both:
--    var msg = new Buffer(out.length + 4);
--    binary.writeI32(msg, out.length);
--    out.copy(msg, 4, 0, out.length);
--    if (this.onFlush) {
--      // Passing seqid through this call to get it to the connection
--      this.onFlush(msg, seqid);
--    }
--  }
--
--  this.outBuffers = [];
--  this.outCount = 0;
--};

return TFramedTransport
