# lua-thrift

LuaRocks packaging of [Apache Thrift](https://thrift.apache.org).

## Changes

This line within `src/Thrift.lua` has been disabled:

```lua
package.cpath = package.cpath .. ';bin/?.so' -- TODO FIX
```
