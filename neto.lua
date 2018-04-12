local M = {}

local imgui

function M.setImgui(_imgui)
  imgui = _imgui
end

function M.list(label, selected, options, maxHeightInItems)
  local len = #options
  local index = 0
  if selected ~= nil then
    for i = 1, len do
      if options[i] == selected then
        index = i
        break
      end
    end
  end
  local heightInItems = math.min(len, maxHeightInItems)

  local changed, selectionIndex = imgui.ListBox(label, index, options, len, heightInItems)

  return (changed == true) and options[selectionIndex] or nil
end

local TREE_LEAF = {'Bullet', 'NoTreePushOnOpen'}

function M.tree(data, expandedMap)
  local result = nil

  local folders = {}
  local len = 0
  for k, v in pairs(data) do
    if type(k) == 'string' then
      len = len + 1
      folders[len] = k
    end
  end
  table.sort(folders)

  for i = 1, len do
    local folder = folders[i]
    if expandedMap and expandedMap[folder] == true then
      imgui.SetNextTreeNodeOpen(true)
    end
    if imgui.TreeNode(folder) then
      local recursiveResult = M.tree(data[folder], expandedMap)
      if recursiveResult then
        result = recursiveResult
      end
      imgui.TreePop()
    elseif expandedMap and expandedMap[folder] == true then
      expandedMap[folder] = nil
    end
  end

  for i, v in ipairs(data) do
    -- Forces node to be closed, meaning that this condition will only trigger once after click.
    imgui.SetNextTreeNodeOpen(false)
    local wasLeafClicked = imgui.TreeNodeEx(v, TREE_LEAF)
    if wasLeafClicked then
      result = v
    end
  end

  return result
end

return M
