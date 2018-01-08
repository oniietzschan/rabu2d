local bitser = require 'lib.bitser'

local Sebu = {}

function Sebu.save(filepath, data)
  assert(type(filepath) == 'string')
  assert(type(data) == 'table')
  local serialized = bitser.dumps(data)
  local file, err = love.filesystem.newFile(filepath)
  assert(err == nil, err)
  file:open("w")
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
