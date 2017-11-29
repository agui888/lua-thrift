## [Unreleased]
### Added:
- Implemented libluabpack `bunpack()`

### Changed:
- Remove Lua 5.3 support due to upstream long module limitation
- Organize files into `protocol` and `transport` subfolders, adopting organization inspired by Thrift's Java support

### Fixed:
- TBufferedTransport constructor was missing delegate arg
- `TSocket.lua` did not export a class

## [0.10.0-1] - 2017-11-24
### Added:
- Adopt new [long](https://luarocks.org/modules/drauschenbach/long) LuaRocks module, that was specifically ported for this project

## [0.10.0-0] - 2017-11-22
### Added:
- Initial decomposition of Apache Thrift Lua support into decomposed modules
- Resolve `luacheck` warnings and enforce via Travis CI
- LuaRocks packaging

<small>(formatted per [keepachangelog-1.1.0](http://keepachangelog.com/en/1.0.0/))</small>