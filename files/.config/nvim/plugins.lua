local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data").."/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
  execute "packadd packer.nvim"
end


vim.cmd [[packadd packer.nvim]]

require("packer").startup(function(use)

  --use_rocks "rtsisyk/fun"

  use "tami5/compe-conjure"

  use "pwntester/octo.nvim"

  use "Olical/conjure"

  use "p00f/nvim-ts-rainbow"
  use "romgrk/nvim-treesitter-context"
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }

  --use "code-biscuits/nvim-biscuits"

  use "simrat39/symbols-outline.nvim"
  use "folke/which-key.nvim"
  use "folke/lsp-trouble.nvim"


  -- better quickfix window
  --use "kevinhwang91/nvim-bqf"

  -- json query stuff
  use {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json" }
  }


  use {
    "Olical/aniseed", 
    tag = "v3.16.0"
  }

  -- general purpose lua wrappers for nvim stuff
  use "norcalli/nvim.lua"


  use "akinsho/nvim-bufferline.lua"
  use "tweekmonster/startuptime.vim"
  use "tpope/vim-repeat"
  use {
    "junegunn/goyo.vim",
    cmd = "Goyo",
  }

  --use "mhinz/vim-signify"
  use "lewis6991/gitsigns.nvim"

  use "tpope/vim-fugitive"
  use "preservim/nerdcommenter"
  use "glepnir/galaxyline.nvim"
  use "gruvbox-community/gruvbox"
  use "godlygeek/tabular"               -- :Tab /regex can align code on occurrences of the given regex. I.e. :Tab /= aligns all = signs in a block.
  use "tpope/vim-surround"
  use "christoomey/vim-tmux-navigator"  -- good integration with tmux pane switching
  use "nathanaelkane/vim-indent-guides" -- Can be toggled using <leader>ig (intent-guides)

  -- <C-n> to select current word. <C-n> to select next occurrence.
  -- with multiple lines selected in Visual mode, <C-n> to insert cursor in each line. I not i to insert in Visual-mode.
  -- use "terryma/vim-multiple-cursors"
  use "mg979/vim-visual-multi"
  use "hauleth/sad.vim"          -- Use siw instead of ciw. when using . afterwards, will find the next occurrence of the changed word and change it too
  use "wellle/targets.vim"       -- more text objects. IE: cin) (change in next parens). generally better handling of surrounding objects.
  use "unblevable/quick-scope"   -- highlight targets when pressing f<character>
  use {
    "iamcco/markdown-preview.nvim", 
    run = vim.fn["mkdp#util#install"]
  }

  use "machakann/vim-highlightedyank"
  use "ciaranm/detectindent"
  use "pechorin/any-jump.vim"
  use "justinmk/vim-sneak"
  use "psliwka/vim-smoothie"
  use "editorconfig/editorconfig-vim"
  use "honza/vim-snippets"
  use "tommcdo/vim-exchange"
  use "kien/rainbow_parentheses.vim"
  use "bhurlow/vim-parinfer"


  use "ray-x/lsp_signature.nvim"

  -- Language Plugins ----------------------------------------------------- {{{

  use "bduggan/vim-raku"
  use "LnL7/vim-nix"

  use "kevinoid/vim-jsonc"

  use "ap/vim-css-color"
  use "pangloss/vim-javascript" -- syntax highlighting JS
  use "ianks/vim-tsx"
  use "leafgarland/typescript-vim"
  use "sheerun/vim-polyglot"    -- Syntax highlighting for most languages
  -- use "mattn/emmet-vim"

  use "purescript-contrib/purescript-vim"

  use "HerringtonDarkholme/yats.vim" -- typescript syntax highlighting
  use "mxw/vim-jsx"

  -- Haskell
  use "neovimhaskell/haskell-vim"

  -- Rust
  use "rust-lang/rust.vim"
  use "mattn/webapi-vim"

  use "bakpakin/fennel.vim"
  use "tjdevries/nlua.nvim"

  -- use "mxw/vim-prolog"


  use "simrat39/rust-tools.nvim"

  use "neovim/nvim-lspconfig"

  -- use "nvim-lua/completion-nvim"
  use "hrsh7th/nvim-compe"
  use "glepnir/lspsaga.nvim"
  -- use "cohama/lexima.vim"

  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use "nvim-telescope/telescope.nvim"

  use "RishabhRD/popfix"
  use "RishabhRD/nvim-lsputils"

  use "nvim-telescope/telescope-media-files.nvim"

  -- }}}

end)

