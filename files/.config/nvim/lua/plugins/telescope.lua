local _0_0 = nil
do
  local name_0_ = "plugins.telescope"
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
    return {require("aniseed.core"), require("telescope.actions"), require("aniseed.fennel"), require("aniseed.nvim"), require("telescope"), require("utils")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {a = "aniseed.core", actions = "telescope.actions", fennel = "aniseed.fennel", nvim = "aniseed.nvim", telescope = "telescope", utils = "utils"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local actions = _local_0_[2]
local fennel = _local_0_[3]
local nvim = _local_0_[4]
local telescope = _local_0_[5]
local utils = _local_0_[6]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "plugins.telescope"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
telescope.setup({defaults = {i = {["<esc>"] = actions.close}}})
telescope.load_extension("media_files")
return utils.noremap("n", "<C-p>", ":Telescope find_files<CR>")