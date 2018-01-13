rabu2d
======

Micro unfriendly love2d libraries and scripts mostly for personal use?

Kyuu
----

9-patches with support for non-equilateral quads.

```lua
local Kyuu = require 'kyuu'
local image
local widthColLeft  =  8
local widthColMid   = 16
local widthColRight =  8
local heightRowTop =  8
local heightRowMid = 16
local heightRowBot = 12
local patch = Kyuu(
  love.graphics.newImage('9patch.png'), -- Path to asset is also supported
  8,  -- left column width
  16, -- middle column width
  8,  -- right column width
  8,  -- top row height
  16, -- middle row height
  12, -- bottom row height
  0, -- image X offset, for sprite atlases and such
  0, -- image Y offset
)
local spriteBatch = patch:getSpriteBatch() -- Literally just a love2d SpriteBatch.
love.graphics.draw(spriteBatch, 0, 0)
```

Sebu
----

Saves and loads serialized data to love filesystem.

```lua
local Sebu = require 'sebu'
Sebu.save('filepath.sav', {isCute = true}}
local data = Sebu.load('filepath.sav')
```
