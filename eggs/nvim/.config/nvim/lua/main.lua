-- [nfnl] Compiled from fnl/main.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local a = autoload("nfnl.core")
local str = autoload("nfnl.string")
local utils = autoload("dots.utils")
local lazy = require("lazy")
if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
else
end
vim.cmd("let mapleader=\"\\<Space>\"")
vim.cmd("let maplocalleader=\",\"")
lazy.setup({import = "dots.plugins", install = {colorscheme = "gruvbox8"}})
require("dots.keybinds")
do
  local added_paths = {}
  vim.opt.runtimepath = (vim.o.runtimepath .. str.join(",", added_paths))
end
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")
vim.opt.foldmethod = "marker"
vim.opt.scrolloff = 5
vim.opt.showmode = false
vim.opt.undodir = (vim.env.HOME .. "/.vim/undo-dir")
vim.opt.undofile = true
vim.opt.shortmess = (vim.o.shortmess .. "c")
vim.opt.hidden = true
vim.opt.encoding = "utf-8"
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.compatible = false
vim.opt.cursorline = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.inccommand = "nosplit"
vim.opt.signcolumn = "yes"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.backspace = "indent,eol,start"
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.completeopt = "menuone,noselect"
vim.opt.laststatus = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = "a"
vim.opt.shell = "bash"
vim.opt.background = "dark"
vim.opt.swapfile = false
vim.opt.undolevels = 10000
vim.opt.keywordprg = "rusty-man"
vim.g.AutoPairsMultilineClose = 0
vim.cmd("let &t_ut=\"\"")
vim.opt.title = true
vim.opt.titlelen = 0
vim.opt.titlestring = "%{expand(\"%:p\")} [%{mode()}]"
local function _3_()
  vim.opt.shiftwidth = 2
  return nil
end
vim.api.nvim_create_autocmd("BufWritePost", {pattern = "*.hs", callback = _3_})
local function _4_()
  vim.opt_local.foldmethod = "marker"
  return nil
end
vim.api.nvim_create_autocmd("FileType", {pattern = "vim", callback = _4_})
local function _5_()
  vim.opt_local.formatoptions = vim.o.formatoptions:gsub("[cor]", "")
  return nil
end
vim.api.nvim_create_autocmd("FileType", {pattern = "*", callback = _5_})
local function _6_()
  return vim.cmd("nnoremap <buffer> <CR> <CR>:cclose<CR>")
end
vim.api.nvim_create_autocmd("FileType", {pattern = "qf", callback = _6_})
local function _7_()
  return vim.highlight.on_yank({higroup = "IncSearch", timeout = 300})
end
vim.api.nvim_create_autocmd("TextYankPost", {pattern = "*", callback = _7_})
vim.g.copilot_filetypes = {TelescopePrompt = false}
vim.diagnostic.config({float = {border = "single", style = "minimal"}})
vim.g.VM_leader = "m"
vim.g.rust_clip_command = "xclip -selection clipboard"
vim.g["conjure#client#fennel#aniseed#aniseed_module_prefix"] = "aniseed."
vim.g.vim_parinfer_filetypes = {"carp", "fennel", "clojure"}
vim.g.parinfer_additional_filetypes = {"yuck"}
_G.clean_no_name_empty_buffers = function()
  local bufs
  local function _8_(_241)
    return (a["empty?"](vim.fn.bufname(_241)) and (vim.fn.bufwinnr(_241) < 0) and vim.api.nvim_buf_is_loaded(_241) and ("" == str.join(utils["buffer-content"](_241))) and vim.api.nvim_buf_get_option(_241, "buflisted"))
  end
  bufs = a.filter(_8_, vim.fn.range(1, vim.fn.bufnr("$")))
  if not a["empty?"](bufs) then
    return vim.cmd(("bdelete " .. str.join(" ", bufs)))
  else
    return nil
  end
end
vim.cmd("autocmd! BufCreate * :call v:lua.clean_no_name_empty_buffers()")
return vim.cmd("command! -nargs=1 L :lua print(vim.inspect(<args>))")
