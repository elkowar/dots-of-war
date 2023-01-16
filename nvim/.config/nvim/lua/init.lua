local _2afile_2a = "/home/leon/.config/nvim/fnl/init.fnl"
local _2amodule_name_2a = "init"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local a, colors, nvim, str, utils, _ = autoload("aniseed.core"), autoload("dots.colors"), autoload("aniseed.nvim"), autoload("aniseed.string"), autoload("dots.utils"), nil
_2amodule_locals_2a["a"] = a
_2amodule_locals_2a["colors"] = colors
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["str"] = str
_2amodule_locals_2a["utils"] = utils
_2amodule_locals_2a["_"] = _
utils["clear-deferred"]()
if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
else
end
local function _2_()
  return require("dots.plugins")
end
local function _3_(_241)
  local fennel_2_auto = require("aniseed.fennel")
  return a.println(fennel_2_auto.traceback(_241))
end
xpcall(_2_, _3_)
local function _4_()
  return require("dots.plugins.lsp")
end
local function _5_(_241)
  local fennel_2_auto = require("aniseed.fennel")
  return a.println(fennel_2_auto.traceback(_241))
end
xpcall(_4_, _5_)
local function _6_()
  return require("dots.keybinds")
end
local function _7_(_241)
  local fennel_2_auto = require("aniseed.fennel")
  return a.println(fennel_2_auto.traceback(_241))
end
xpcall(_6_, _7_)
do
  local added_paths = {}
  vim.opt.runtimepath = (vim.o.runtimepath .. str.join(",", added_paths))
end
vim.cmd("let mapleader=\"\\<Space>\"")
vim.cmd("let maplocalleader=\",\"")
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
local function _8_()
  vim.opt.shiftwidth = 2
  return nil
end
vim.api.nvim_create_autocmd("BufWritePost", {pattern = "*.hs", callback = _8_})
local function _9_()
  vim.opt_local.foldmethod = "marker"
  return nil
end
vim.api.nvim_create_autocmd("FileType", {pattern = "vim", callback = _9_})
local function _10_()
  vim.opt_local.formatoptions = (vim.o.formatoptions):gsub("[cor]", "")
  return nil
end
vim.api.nvim_create_autocmd("FileType", {pattern = "*", callback = _10_})
local function _11_()
  return vim.cmd("nnoremap <buffer> <CR> <CR>:cclose<CR>")
end
vim.api.nvim_create_autocmd("FileType", {pattern = "qf", callback = _11_})
local function _12_()
  return vim.highlight.on_yank({higroup = "IncSearch", timeout = 300})
end
vim.api.nvim_create_autocmd("TextYankPost", {pattern = "*", callback = _12_})
vim.g.copilot_filetypes = {TelescopePrompt = false}
vim.diagnostic.config({float = {border = "single", style = "minimal"}})
vim.g.VM_leader = "m"
vim.g.rust_clip_command = "xclip -selection clipboard"
vim.g["conjure#client#fennel#aniseed#aniseed_module_prefix"] = "aniseed."
vim.g.vim_parinfer_filetypes = {"carp", "fennel", "clojure"}
vim.g.parinfer_additional_filetypes = {"yuck"}
_G.clean_no_name_empty_buffers = function()
  local bufs
  local function _13_(_241)
    return (a["empty?"](vim.fn.bufname(_241)) and (vim.fn.bufwinnr(_241) < 0) and vim.api.nvim_buf_is_loaded(_241) and ("" == str.join(utils["buffer-content"](_241))) and vim.api.nvim_buf_get_option(_241, "buflisted"))
  end
  bufs = a.filter(_13_, vim.fn.range(1, vim.fn.bufnr("$")))
  if not a["empty?"](bufs) then
    return vim.cmd(("bdelete " .. str.join(" ", bufs)))
  else
    return nil
  end
end
vim.cmd("autocmd! BufCreate * :call v:lua.clean_no_name_empty_buffers()")
vim.cmd("command! -nargs=1 L :lua print(vim.inspect(<args>))")
vim.cmd("Copilot enable")
utils["run-deferred"]()
return _2amodule_2a