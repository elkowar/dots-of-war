-- [nfnl] Compiled from fnl/dots/plugins/plugins.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  do end (require("lsp_lines")).setup()
  return vim.diagnostic.config({virtual_lines = false})
end
local function _2_()
  do end (require("litee.lib")).setup()
  return (require("litee.gh")).setup()
end
local function _3_()
  vim.g.code_action_menu_show_details = false
  return nil
end
local function _4_()
  vim.g.antifennel_executable = "/home/leon/tmp/antifennel/antifennel"
  return nil
end
local function _5_()
  vim.g.vlime_overlay = "slimv"
  return nil
end
local function _6_()
  vim.g.rustfmt_fail_silently = 1
  return nil
end
return {"Olical/aniseed", "Olical/nfnl", "nvim-lua/plenary.nvim", "norcalli/nvim.lua", "kyazdani42/nvim-web-devicons", "folke/which-key.nvim", {"ckipp01/nvim-jenkinsfile-linter", dependencies = {"nvim-lua/plenary.nvim"}}, "psliwka/vim-smoothie", {"nathanaelkane/vim-indent-guides", cmd = {"IndentGuidesToggle"}}, {"luukvbaal/stabilize.nvim", config = true}, {"stevearc/dressing.nvim", config = true}, {"tweekmonster/startuptime.vim", cmd = {"StartupTime"}}, {"moll/vim-bbye", lazy = true, cmd = {"Bdelete", "Bwipeout"}}, {"petertriho/nvim-scrollbar", event = "VeryLazy", lazy = true, config = true}, {"TimUntersberger/neogit", opts = {integrations = {diffview = true}}, cmd = {"Neogit"}}, {"folke/persistence.nvim", opts = {dir = vim.fn.expand((vim.fn.stdpath("cache") .. "/sessions/"))}}, {"https://git.sr.ht/~whynothugo/lsp_lines.nvim", config = _1_}, "jiangmiao/auto-pairs", "tpope/vim-repeat", {"preservim/nerdcommenter", event = "VeryLazy", lazy = true, priority = 1000}, {"godlygeek/tabular", cmd = {"Tabularize"}}, "tpope/vim-surround", "hauleth/sad.vim", "wellle/targets.vim", {"mg979/vim-visual-multi", lazy = true, event = "VeryLazy"}, "tommcdo/vim-exchange", {"phaazon/hop.nvim", lazy = true, event = "VeryLazy", opts = {keys = "jfkdls;amvieurow"}}, {"rcarriga/nvim-dap-ui", lazy = true, config = true, dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}}, {"mfussenegger/nvim-dap", lazy = true}, {"nvim-telescope/telescope-dap.nvim", lazy = true, dependencies = {"nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap"}}, {"ldelossa/gh.nvim", lazy = true, config = _2_, dependencies = {"ldelossa/litee.nvim"}}, {"pwntester/octo.nvim", lazy = true, dependencies = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "kyazdani42/nvim-web-devicons"}, config = true}, "ruanyl/vim-gh-line", "rhysd/conflict-marker.vim", {"tpope/vim-fugitive", lazy = true, event = "VeryLazy"}, {"ray-x/lsp_signature.nvim", event = "BufEnter"}, {"weilbith/nvim-code-action-menu", cmd = "CodeActionMenu", config = _3_}, {"dnlhc/glance.nvim", lazy = true, config = true}, {"smjonas/inc-rename.nvim", opts = {input_buffer_type = "dressing"}}, {"monkoose/nvlime", ft = {"lisp"}, dependencies = {"monkoose/parsley"}}, "imsnif/kdl.vim", "tpope/vim-sleuth", "editorconfig/editorconfig-vim", "sbdchd/neoformat", {"elkowar/antifennel-nvim", config = _4_}, {"Olical/conjure", ft = {"fennel"}}, {"eraserhd/parinfer-rust", build = "cargo build --release"}, "kmonad/kmonad-vim", {"elkowar/yuck.vim", ft = {"yuck"}}, {"cespare/vim-toml", ft = {"toml"}}, {"bduggan/vim-raku", ft = {"raku"}}, {"LnL7/vim-nix", ft = {"nix"}}, {"kevinoid/vim-jsonc"}, {"pangloss/vim-javascript", ft = {"javascript"}}, {"ianks/vim-tsx", ft = {"typescript-react"}}, {"leafgarland/typescript-vim", ft = {"typescript", "typescript-react", "javascript"}}, {"HerringtonDarkholme/yats.vim"}, {"mxw/vim-jsx"}, {"purescript-contrib/purescript-vim", ft = {"purescript"}}, {"derekelkins/agda-vim", ft = {"agda"}}, {"neovimhaskell/haskell-vim", ft = {"haskell"}}, {"monkoose/nvlime", ft = {"lisp"}, dependencies = {"monkoose/parsley"}, config = _5_}, {"rust-lang/rust.vim", ft = {"rust"}, dependencies = {"mattn/webapi-vim"}, config = _6_}, {"Saecki/crates.nvim", dependencies = {"nvim-lua/plenary.nvim"}, opts = {disable_invalid_feature_diagnostic = true, enable_update_available_warning = false}}, {"mrcjkb/rustaceanvim", version = "^4", ft = {"rust", "toml"}}, {"qnighy/lalrpop.vim"}, {"edwinb/idris2-vim", ft = {"idris2"}}, {"vmchale/ats-vim", ft = {"ats", "dats", "sats"}}, {"bakpakin/fennel.vim", ft = {"fennel"}}, {"evanleck/vim-svelte"}}
