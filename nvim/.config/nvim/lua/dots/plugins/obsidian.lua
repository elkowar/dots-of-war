-- [nfnl] Compiled from fnl/dots/plugins/obsidian.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local utils = _local_1_["utils"]
local vault_path = (vim.fn.expand("~") .. "/Documents/obsidian-vault")
return {utils.plugin("epwalsh/obsidian.nvim", {lazy = true, version = "*", ft = "markdown", event = {("BufReadPre " .. vault_path .. "/**.md"), ("BufNewFile " .. vault_path .. "/**.md")}, dependencies = {"nvim-lua/plenary.nvim"}, opts = {workspaces = {{name = "Vault", path = vault_path}}, completion = {nvim_cmp = true}}})}
