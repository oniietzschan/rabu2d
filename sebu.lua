local bitser = require 'lib.bitser'

local Sebu = {}

-- https://www.lua.org/manual/5.1/manual.html#5.7
-- w+: Update mode, all previous data is erased;
-- b:  Binary mode, forces Windows to save with Unix endings.
IO_MODE_WRITE_ERASE_EXISTING = 'w+b'

function Sebu.save(filepath, data)
  assert(type(filepath) == 'string')
  assert(type(data) == 'table')
  local serialized = bitser.dumps(data)
  local file, err = love.filesystem.newFile(filepath)
  assert(err == nil, err)
  file:open(IO_MODE_WRITE_ERASE_EXISTING)
  file:write(serialized)
  file:close()
end

function Sebu.load(filepath)
  assert(type(filepath) == 'string')
  local file, err = love.filesystem.newFile(filepath)
  assert(err == nil, err)
  file:open("r")
  local serialized = file:read()
  file:close()
  local data
  if serialized ~= nil then
    data = bitser.loads(serialized)
  end
  return data
end

return Sebu
