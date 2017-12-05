## [0.10.0-4] - 2017-12-05
### Fixed:
- `TCompactProtocol` `readI64()` returns wrong results due to missing zigzag decoding

## [0.10.0-3] - 2017-12-02
### Fixed:
- `TCompactProtocol` `readVarint64()` doesn't work with many numbers due to use of `readByte()` instead of `readSignByte()`

## [0.10.0-2] - 2017-12-01
### Added:
- Implemented libluabpack `bunpack()`

### Changed:
- Remove Lua 5.3 support due to upstream long module limitation
- Organize files into `protocol` and `transport` subfolders, adopting organization inspired by Thrift's Java support

### Fixed:
- `TBufferedTransport` constructor was missing delegate arg
- `TSocket.lua` did not export a class
- `TFramedTransport` did not work; replaced with a port of NodeJS module, which sacrificed streaming while gaining a working implementation
- `TCompactProtocol` could not read a signed byte due to use of wrong `bunpack()` type arg
- `print_r` stack overflow when attempting to print middleclass instances

## [0.10.0-1] - 2017-11-24
### Added:
- Adopt new [long](https://luarocks.org/modules/drauschenbach/long) LuaRocks module, that was specifically ported for this project

## [0.10.0-0] - 2017-11-22
### Added:
- Initial decomposition of Apache Thrift Lua support into decomposed modules
- Resolve `luacheck` warnings and enforce via Travis CI
- LuaRocks packaging

<small>(formatted per [keepachangelog-1.1.0](http://keepachangelog.com/en/1.0.0/))</small>
