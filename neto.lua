local M = {}

local imgui

function M.setImgui(_imgui)
  imgui = _imgui
end

function M.button(label)
  return imgui.Button(label)
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

function M.slider(label, value, min, max)
  local newValue, changed = imgui.SliderFloat(label, value, min, max)
  return newValue, changed
end

local TREE_LEAF          = {'Bullet', 'NoTreePushOnOpen'}
local TREE_LEAF_SELECTED = {'Bullet', 'NoTreePushOnOpen', 'Selected'}

function M.tree(data, expandedMap, selected)
  local result = nil

  local folders = {}
  for k, v in pairs(data) do
    if type(k) == 'string' then
      table.insert(folders, k)
    end
  end
  table.sort(folders)

  for _, folder in ipairs(folders) do
    if expandedMap and expandedMap[folder] == true then
      imgui.SetNextTreeNodeOpen(true)
    end
    if imgui.TreeNode(folder) then
      local recursiveResult = M.tree(data[folder], expandedMap, selected)
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
    local nodeOptions = (v == selected) and TREE_LEAF_SELECTED or TREE_LEAF
    local wasLeafClicked = imgui.TreeNodeEx(v, nodeOptions)
    if wasLeafClicked then
      result = v
    end
  end

  return result
end

return M
