rabu2d
======

Micro unfriendly love2d libraries and scripts mostly for personal use?

Sebu
----

Saves and loads serialized data to love filesystem.

```lua
local Sebu = require 'sebu'
Sebu.save('filepath.sav', {isCute = true}}
local data = Sebu.load('filepath.sav')
```
