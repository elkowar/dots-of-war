-- [nfnl] Compiled from fnl/dots/plugins/emmet.fnl by https://github.com/Olical/nfnl, do not edit.
local utils = require("dots.utils")
local function setup()
  vim.g.user_emmet_mode = "n"
  vim.g.user_emmet_leader_key = "<leader>e"
  vim.g.user_emmet_settings = {["javascript.jsx"] = {extends = "jsx"}, ["typescript.jsx"] = {extends = "jsx"}}
  return nil
end
return {utils.plugin("mattn/emmet-vim", {lazy = true, config = setup})}
