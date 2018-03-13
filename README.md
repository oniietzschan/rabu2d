rabu2d
======

Micro unfriendly love2d libraries and scripts mostly for personal use?

Dontsuu
-------

Utility for gameplay physics calculations, especially relating to player movement.


```lua
local Dontsuu = require 'dontsuu'
FRICTION = Dontsuu.calculateFriction(maxSpeed, timeToStop, cutoffSpeed)

function player:update(dt)
  local moveX, moveY = self.controller:get(MOVE)
  self.velocityX = Dontsuu.getVelocity(dt, self.acceleration, self.maxSpeed, self.velocityX, moveX)
  self.velocityY = Dontsuu.getVelocity(dt, self.acceleration, self.maxSpeed, self.velocityY, moveY)
end
```

Kyuu
----

9-patches with support for non-equilateral quads.

```lua
local Kyuu = require 'kyuu'
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
local spriteBatch = patch:getSpriteBatch(
  48, -- width
  36  -- height
)
love.graphics.draw(spriteBatch, 0, 0)
```

Sebu
----

Saves and loads serialized data to love filesystem.

```lua
local Sebu = require 'sebu'
Sebu.save('filepath.sav', {isCute = true})
local data = Sebu.load('filepath.sav')
```
