local Kyuu = {}

local function assertType(obj, expectedType, name)
  assert(type(expectedType) == 'string' and type(name) == 'string')
  if type(obj) ~= expectedType then
    error(name .. ' must be a ' .. expectedType .. ', got: ' .. tostring(obj), 2)
  end
end

local Patch = {}
local PatchMt = {
  __index = Patch,
}

function Kyuu:newPatch(...)
  return setmetatable({}, PatchMt)
    :init(...)
end

function Patch:init(image, colLft, colMid, colRgt, rowTop, rowMid, rowBot, left, top)
  top = top or 0
  left = left or 0
  return self
    :setImage(image)
    :setDimensions(colLft, colMid, colRgt, rowTop, rowMid, rowBot)
    :setOffset(left, top)
end

function Patch:setImage(image)
  if type(image) == 'string' then
    image = love.graphics.newImage(image)
  end
  self._image = image
  return self
end

function Patch:setDimensions(colLft, colMid, colRgt, rowTop, rowMid, rowBot)
  assertType(colLft, 'number', 'column left width')
  assertType(colMid, 'number', 'column middle width')
  assertType(colRgt, 'number', 'column right width')
  assertType(rowTop, 'number', 'row left height')
  assertType(rowMid, 'number', 'row middle height')
  assertType(rowBot, 'number', 'row right height')
  self._colLft = colLft
  self._colMid = colMid
  self._colRgt = colRgt
  self._rowTop = rowTop
  self._rowMid = rowMid
  self._rowBot = rowBot
  self._quads = nil
  return self
end

function Patch:setOffset(left, top)
  assertType(top, 'number', 'top')
  assertType(left, 'number', 'left')
  self._top = top
  self._left = left
  self._quads = nil
  return self
end

local TOP_LFT = 'TOP_LFT'
local TOP_MID = 'TOP_MID'
local TOP_RGT = 'TOP_RGT'
local MID_LFT = 'MID_LFT'
local MID_MID = 'MID_MID'
local MID_RGT = 'MID_RGT'
local BOT_LFT = 'BOT_LFT'
local BOT_MID = 'BOT_MID'
local BOT_RGT = 'BOT_RGT'

function Patch:getSpriteBatch(w, h)
  self:_validateSpriteBatchDimensions(w, h)
  self:_tryGenerateQuads()
  local draws, len = {}, 0

  local x, y, qw, qh, _ = 0, 0, 0, 0, nil
  while y < h do
    local rowName, quadName

    if y == 0 and self._rowTop ~= 0 then
      rowName = 'TOP_'
    elseif (h - y) == self._rowBot and self._rowBot ~= 0 then
      rowName = 'BOT_'
    else
      rowName = 'MID_'
    end

    while x < w do
      if x == 0 and self._colLft ~= 0 then
        quadName = rowName .. 'LFT'
      elseif (w - x) == self._colRgt and self._colRgt ~= 0 then
        quadName = rowName .. 'RGT'
      else
        quadName = rowName .. 'MID'
      end

      local quad = self._quads[quadName]
      _, _, qw, qh = quad:getViewport()

      len = len + 1
      draws[len] = {quad, x, y}

      x = x + qw
    end
    x = 0
    y = y + qh
  end

  local batch = love.graphics.newSpriteBatch(self._image, len, 'static')
  for _, draw in ipairs(draws) do
    batch:add(unpack(draw))
  end
  batch:flush()

  return batch
end

function Patch:_validateSpriteBatchDimensions(w, h)
  local xRemainder = (w - self._colLft - self._colRgt) % self._colMid
  local yRemainder = (h - self._rowTop - self._rowBot) % self._rowMid
  if xRemainder ~= 0 or yRemainder ~= 0 then
    error(('Invalid dimensions: %d, %d Remainder of %d, %d'):format(w, h, xRemainder, yRemainder), 3)
  end
end

local mapQuadToComponents = {
  {TOP_LFT, '_colLft', '_rowTop'},
  {TOP_MID, '_colMid', '_rowTop'},
  {TOP_RGT, '_colRgt', '_rowTop'},
  {MID_LFT, '_colLft', '_rowMid'},
  {MID_MID, '_colMid', '_rowMid'},
  {MID_RGT, '_colRgt', '_rowMid'},
  {BOT_LFT, '_colLft', '_rowBot'},
  {BOT_MID, '_colMid', '_rowBot'},
  {BOT_RGT, '_colRgt', '_rowBot'},
}

function Patch:_tryGenerateQuads()
  if self._quads then
    return
  end
  self._quads = {}
  local x, y = 0, 0
  for i, components in ipairs(mapQuadToComponents) do
    local quadName = components[1]
    local w = self[components[2]]
    local h = self[components[3]]
    if w > 0 and h > 0 then
      self._quads[quadName] = love.graphics.newQuad(
        x + self._left,
        y + self._top,
        w,
        h,
        self._image:getDimensions()
      )
    end
    if i % 3 ~= 0 then
      x = x + w
    else
      x = 0
      y = y + h
    end
  end
end

function Patch:drawDebug(x, y)
  for quadName, quad in pairs(self._quads) do
    love.graphics.draw(self._image, quad, x, y)
    love.graphics.print(quadName, x + 20, y)
    y = y + 21
  end
end

local KyuuMt = {
  __index = Kyuu,
  __call = Kyuu.newPatch,
}

return setmetatable({}, KyuuMt)
