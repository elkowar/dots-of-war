local _0_0 = nil
do
  local name_0_ = "init"
  local module_0_ = nil
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("aniseed.core"), require("aniseed.fennel"), require("keybinds"), require("aniseed.nvim"), require("utils")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {macros = true}, require = {a = "aniseed.core", fennel = "aniseed.fennel", kb = "keybinds", nvim = "aniseed.nvim", utils = "utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local fennel = _local_0_[2]
local kb = _local_0_[3]
local nvim = _local_0_[4]
local utils = _local_0_[5]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "init"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
require("plugins.telescope")
require("plugins.lsp")
require("plugins.galaxyline")
require("plugins.bufferline")
local remapped_space = nil
_G.RebindShit = function(newKey)
  remapped_space = {cur = newKey, old = vim.fn.maparg("<Space>", "i")}
  return utils.keymap("i", "<Space>", newKey, {buffer = true})
end
_G.UnbindSpaceStuff = function()
  if (remapped_space and (remapped_space ~= {})) then
    utils["del-keymap"]("i", "<Space>", true)
    if (remapped_space.old ~= "") then
      utils.keymap("i", "<Space>", remapped_space.old, {buffer = true})
    end
    remapped_space = nil
    return nil
  end
end
nvim.command("autocmd! InsertLeave * :call v:lua.UnbindSpaceStuff()")
utils.keymap("n", "<Tab>j", ":call v:lua.RebindShit('_')<CR>")
utils.keymap("n", "<Tab>k", ":call v:lua.RebindShit('::')<CR>")
utils.keymap("i", "<Tab>j", "<space><C-o>:call v:lua.RebindShit('_')<CR>")
utils.keymap("i", "<Tab>k", "<space><C-o>:call v:lua.RebindShit('::')<CR>")
return utils.keymap("n", "\195\182", "a")