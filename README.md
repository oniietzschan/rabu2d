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



Neto
----

Imgui helper.

```lua
-- Setup
imgui = require 'imgui'
Neto = require 'neto'
Neto:setImgui(imgui)

-- List
local label = 'Best Girl'
local options = {'Konata', 'Kagami', 'Tsukasa', 'Miyuki'}
local selected = 'Tsukasa'
local maxHeightInItems = 4
local newValue = Neto.list(label, selected, options, maxHeightInItems)
if newValue then
  -- Do something with newValue.
end

-- Tree
local data = {
  ['Folder One'] = {
    ['Subfolder One'] = {
      'Item 1',
      'Item 2',
    },
    ['Subfolder Two'] = {
      'Item 3',
      'Item 4',
    },
    'Item 5',
    'Item 6',
  },
  ['Folder Two'] = {
    'Item 7',
    'Item 8',
  },
  'Item 9',
  'Item 10',
  'Item 11',
}
local expanded = {
  ['Folder One'] = true,
  ['Subfolder Two'] = true,
}
local selected = Neto.tree(data, expanded)
if selected then
  -- Do something with selected.
end
```



Sebu
----

Saves and loads serialized data to love filesystem.

```lua
local Sebu = require 'sebu'
Sebu.save('filepath.sav', {isCute = true})
local data = Sebu.load('filepath.sav')
```
