local _2afile_2a = "/home/leon/.config/nvim/fnl/dots/plugins.fnl"
local _2amodule_name_2a = "dots.plugins"
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
local a, lazy, _ = autoload("aniseed.core"), autoload("lazy"), nil
_2amodule_locals_2a["a"] = a
_2amodule_locals_2a["lazy"] = lazy
_2amodule_locals_2a["_"] = _
local function safe_req_conf(name)
  local ok_3f, val_or_err = pcall(require, ("dots.plugins." .. name))
  if not ok_3f then
    return print(("Plugin config error: " .. val_or_err))
  else
    return nil
  end
end
_2amodule_locals_2a["safe-req-conf"] = safe_req_conf
local function setup_lazy(...)
  local pkgs = {...}
  local args = {}
  for i = 1, a.count(pkgs), 2 do
    local name = pkgs[i]
    local opts = pkgs[(i + 1)]
    table.insert(args, a.assoc(opts, 1, name))
  end
  return lazy.setup(args, {colorscheme = "gruvbox8"})
end
_2amodule_2a["setup-lazy"] = setup_lazy
local function _2_()
  return require("dots.plugins.gruvbox8")
end
local function _3_()
  return require("dots.plugins.todo-comments")
end
local function _4_()
  return require("dots.plugins.feline")
end
local function _5_()
  return require("dots.plugins.bufferline")
end
local function _6_()
  return require("dots.plugins.nvim-colorizer")
end
local function _7_()
  return (require("stabilize")).setup()
end
local function _8_()
  return (require("dressing")).setup()
end
local function _9_()
  return require("dots.plugins.noice")
end
local function _10_()
  return require("dots.plugins.persistence")
end
local function _11_()
  return require("dots.plugins.zen-mode")
end
local function _12_()
  return require("dots.plugins.twilight")
end
local function _13_()
  return require("dots.plugins.telescope")
end
local function _14_()
  return (require("scrollbar")).setup()
end
local function _15_()
  do end (require("lsp_lines")).setup()
  return vim.diagnostic.config({virtual_lines = false})
end
local function _16_()
  return (require("hop")).setup({keys = "jfkdls;amvieurow"})
end
local function _17_()
  return require("dots.plugins.treesitter")
end
local function _18_()
  return (require("dapui")).setup()
end
local function _19_()
  do end (require("litee.lib")).setup()
  return (require("litee.gh")).setup()
end
local function _20_()
  return (require("octo")).setup()
end
local function _21_()
  return require("dots.plugins.diffview")
end
local function _22_()
  return require("dots.plugins.gitsigns")
end
local function _23_()
  return require("dots.plugins.neogit")
end
local function _24_()
  vim.g.code_action_menu_show_details = false
  return nil
end
local function _25_()
  return require("dots.plugins.trouble")
end
local function _26_()
  return require("dots.plugins.symbols-outline")
end
local function _27_()
  return (require("inc_rename")).setup({input_buffer_type = "dressing"})
end
local function _28_()
  return require("dots.plugins.glance")
end
local function _29_()
  return require("dots.plugins.cmp")
end
local function _30_()
  return require("dots.plugins.copilot")
end
local function _31_()
  vim.g.antifennel_executable = "/home/leon/tmp/antifennel/antifennel"
  return nil
end
local function _32_()
  return require("dots.plugins.vimtex")
end
local function _33_()
  return require("dots.plugins.emmet")
end
local function _34_()
  vim.g.vlime_overlay = "slimv"
  return nil
end
local function _35_()
  vim.g.rustfmt_fail_silently = 1
  return nil
end
local function _36_()
  return (require("crates")).setup()
end
setup_lazy("Olical/aniseed", {branch = "develop"}, "nvim-lua/plenary.nvim", {}, "norcalli/nvim.lua", {}, "lifepillar/vim-gruvbox8", {priority = 1000, config = _2_, lazy = false}, "kyazdani42/nvim-web-devicons", {}, "folke/which-key.nvim", {}, "folke/todo-comments.nvim", {lazy = true, event = "VeryLazy", config = _3_}, "Famiu/feline.nvim", {config = _4_}, "akinsho/nvim-bufferline.lua", {config = _5_, tag = "v1.1.1"}, "ckipp01/nvim-jenkinsfile-linter", {dependencies = {"nvim-lua/plenary.nvim"}}, "psliwka/vim-smoothie", {}, "norcalli/nvim-colorizer.lua", {event = "VeryLazy", lazy = true, config = _6_}, "nathanaelkane/vim-indent-guides", {cmd = {"IndentGuidesToggle"}}, "luukvbaal/stabilize.nvim", {config = _7_}, "stevearc/dressing.nvim", {config = _8_}, "tweekmonster/startuptime.vim", {cmd = {"StartupTime"}}, "folke/noice.nvim", {config = _9_, dependencies = {"MunifTanjim/nui.nvim"}}, "folke/persistence.nvim", {config = _10_}, "folke/zen-mode.nvim", {config = _11_, cmd = {"ZenMode"}}, "folke/twilight.nvim", {config = _12_}, "moll/vim-bbye", {lazy = true, cmd = {"Bdelete", "Bwipeout"}}, "nvim-telescope/telescope.nvim", {config = _13_, cmd = {"Telescope"}, dependencies = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}}, "petertriho/nvim-scrollbar", {event = "VeryLazy", lazy = true, config = _14_}, "https://git.sr.ht/~whynothugo/lsp_lines.nvim", {config = _15_}, "jiangmiao/auto-pairs", {}, "tpope/vim-repeat", {}, "preservim/nerdcommenter", {event = "VeryLazy", lazy = true, priority = 1000}, "godlygeek/tabular", {cmd = {"Tabularize"}}, "tpope/vim-surround", {}, "hauleth/sad.vim", {}, "wellle/targets.vim", {}, "mg979/vim-visual-multi", {lazy = true, event = "VeryLazy"}, "tommcdo/vim-exchange", {}, "phaazon/hop.nvim", {lazy = true, event = "VeryLazy", config = _16_}, "nvim-treesitter/nvim-treesitter", {config = _17_, lazy = true, event = {"VeryLazy"}, build = ":TSUpdate"}, "RRethy/nvim-treesitter-textsubjects", {dependencies = {"nvim-treesitter/nvim-treesitter"}, lazy = true, event = {"VeryLazy"}}, "JoosepAlviste/nvim-ts-context-commentstring", {event = {"VeryLazy"}, lazy = true, dependencies = {"nvim-treesitter/nvim-treesitter"}}, "nvim-treesitter/playground", {event = {"VeryLazy"}, lazy = true, dependencies = {"nvim-treesitter/nvim-treesitter"}}, "rcarriga/nvim-dap-ui", {lazy = true, config = _18_, dependencies = {"mfussenegger/nvim-dap"}}, "mfussenegger/nvim-dap", {lazy = true}, "nvim-telescope/telescope-dap.nvim", {lazy = true, dependencies = {"nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap"}}, "ldelossa/gh.nvim", {lazy = true, config = _19_, dependencies = {"ldelossa/litee.nvim"}}, "pwntester/octo.nvim", {lazy = true, dependencies = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "kyazdani42/nvim-web-devicons"}, config = _20_}, "sindrets/diffview.nvim", {cmd = {"DiffviewOpen", "DiffviewToggleFiles"}, config = _21_}, "lewis6991/gitsigns.nvim", {dependencies = {"vim-gruvbox8", "petertriho/nvim-scrollbar"}, config = _22_}, "ruanyl/vim-gh-line", {}, "rhysd/conflict-marker.vim", {}, "tpope/vim-fugitive", {lazy = true, event = "VeryLazy"}, "TimUntersberger/neogit", {config = _23_, cmd = {"Neogit"}}, "ray-x/lsp_signature.nvim", {event = "BufEnter"}, "weilbith/nvim-code-action-menu", {cmd = "CodeActionMenu", config = _24_}, "folke/trouble.nvim", {lazy = true, config = _25_, cmd = {"Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle"}}, "simrat39/symbols-outline.nvim", {lazy = true, cmd = {"SymbolsOutline", "SymbolsOutlineClose", "SymbolsOutlineOpen"}, config = _26_}, "neovim/nvim-lspconfig", {event = "VeryLazy", lazy = true}, "smjonas/inc-rename.nvim", {config = _27_}, "dnlhc/glance.nvim", {lazy = true, config = _28_}, "hrsh7th/vim-vsnip", {lazy = true, event = {"VeryLazy"}}, "hrsh7th/vim-vsnip-integ", {lazy = true, event = {"VeryLazy"}}, "rafamadriz/friendly-snippets", {}, "hrsh7th/nvim-cmp", {lazy = true, event = {"VeryLazy"}, dependencies = {{"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"}, {"hrsh7th/cmp-vsnip"}, {"hrsh7th/cmp-nvim-lua"}, {"hrsh7th/cmp-calc"}, {"hrsh7th/cmp-path"}, {"hrsh7th/cmp-nvim-lsp-signature-help"}, {"davidsierradz/cmp-conventionalcommits"}, {"hrsh7th/cmp-omni"}}, config = _29_}, "zbirenbaum/copilot.lua", {cmd = "Copilot", event = "InsertEnter", config = _30_}, "tpope/vim-sleuth", {}, "editorconfig/editorconfig-vim", {}, "pechorin/any-jump.vim", {}, "sbdchd/neoformat", {}, "elkowar/antifennel-nvim", {config = _31_}, "Olical/conjure", {ft = {"fennel"}}, "eraserhd/parinfer-rust", {build = "cargo build --release"}, "lervag/vimtex", {ft = {"latex", "tex"}, config = _32_}, "kmonad/kmonad-vim", {}, "elkowar/yuck.vim", {ft = {"yuck"}}, "cespare/vim-toml", {ft = {"toml"}}, "bduggan/vim-raku", {ft = {"raku"}}, "LnL7/vim-nix", {ft = {"nix"}}, "kevinoid/vim-jsonc", {}, "pangloss/vim-javascript", {ft = {"javascript"}}, "ianks/vim-tsx", {ft = {"typescript-react"}}, "leafgarland/typescript-vim", {ft = {"typescript", "typescript-react", "javascript"}}, "HerringtonDarkholme/yats.vim", {}, "mxw/vim-jsx", {}, "mattn/emmet-vim", {lazy = true, config = _33_}, "purescript-contrib/purescript-vim", {ft = {"purescript"}}, "derekelkins/agda-vim", {ft = {"agda"}}, "neovimhaskell/haskell-vim", {ft = {"haskell"}}, "monkoose/nvlime", {ft = {"lisp"}, dependencies = {"monkoose/parsley"}, config = _34_}, "rust-lang/rust.vim", {ft = {"rust"}, dependencies = {"mattn/webapi-vim"}, config = _35_}, "simrat39/rust-tools.nvim", {ft = {"rust", "toml"}, dependencies = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}}, "Saecki/crates.nvim", {dependencies = {"nvim-lua/plenary.nvim"}, event = {"BufRead Cargo.toml"}, lazy = true, config = _36_}, "qnighy/lalrpop.vim", {}, "edwinb/idris2-vim", {ft = {"idris2"}}, "vmchale/ats-vim", {ft = {"ats", "dats", "sats"}}, "bakpakin/fennel.vim", {ft = {"fennel"}}, "evanleck/vim-svelte", {})
return _2amodule_2a