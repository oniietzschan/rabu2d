local Mizu = {}

function Mizu:init()
  self.items = {}
  self._itemIndexes = {}
  self.count = 0
  return self
end

function Mizu:add(item)
  if self._itemIndexes[item] then
    error('Already added ' .. tostring(item) .. ' to this Mizu pool.')
  end
  self.count = self.count + 1
  self.items[self.count] = item
  self._itemIndexes[item] = self.count
end

function Mizu:remove(item)
  local id = self._itemIndexes[item]
  local replacement = self.items[self.count]
  self._itemIndexes[replacement] = id
  self.items[id] = replacement
  self._itemIndexes[item] = nil
  self.items[self.count] = nil
  self.count = self.count - 1
end

function Mizu:contains(item)
  return self._itemIndexes[item] ~= nil
end

local MizuMetatable = {__index = Mizu}

return function()
  return setmetatable({}, MizuMetatable)
    :init()
end
