-- [nfnl] Compiled from fnl/dots/plugins/treesitter.fnl by https://github.com/Olical/nfnl, do not edit.
local utils = require("dots.utils")
local function setup()
  local configs = require("nvim-treesitter.configs")
  vim.g.skip_ts_context_commentstring_module = true
  return configs.setup({ensure_installed = {"rust", "fennel", "commonlisp", "vim", "regex", "lua", "bash", "markdown", "markdown_inline"}, highlight = {disable = {"fennel", "rust", "haskell"}, enable = false}, incremental_selection = {keymaps = {init_selection = "gss", node_incremental = "gsl", node_decremental = "gsh", scope_incremental = "gsj", scope_decremental = "gsk"}, enable = false}, textsubjects = {enable = true, disable = {"noice"}, prev_selection = ",", keymaps = {["."] = "textsubjects-smart"}}, playground = {disable = {"fennel"}, updatetime = 25, keybindings = {toggle_query_editor = "o", toggle_hl_groups = "i", toggle_injected_languages = "t", toggle_anonymous_nodes = "a", toggle_language_display = "I", focus_language = "f", unfocus_language = "F", update = "R", goto_node = "<cr>", show_help = "?"}, enable = false, persist_queries = false}})
end
return {}
