(module plugins
  {require {}
   require-macros [macros]})

(packer-use
  "/home/leon/coding/projects/nvim-gehzu" {}
  :elkowar/kmonad.vim {}

  :gruvbox-community/gruvbox {:opt false
                              :config #(vim.cmd "colorscheme gruvbox")}

  :nvim-telescope/telescope.nvim {:mod "plugins.telescope"
                                  :cmd ["Telescope"]
                                  :requires [:nvim-lua/popup.nvim :nvim-lua/plenary.nvim]}

  :kyazdani42/nvim-web-devicons {}

  :p00f/nvim-ts-rainbow {}
  ;:romgrk/nvim-treesitter-context {}
  :JoosepAlviste/nvim-ts-context-commentstring {}
  :nvim-treesitter/nvim-treesitter {:mod "plugins.treesitter" 
                                    :run ":TSUpdate"}
  :nvim-treesitter/playground {}


  :jiangmiao/auto-pairs {}
  
  ; :code-biscuits/nvim-biscuits {} ; show opening line after closing curly

  :folke/which-key.nvim {}

  ; json query stuff
  :gennaro-tedesco/nvim-jqx {:ft ["json"]}

  :Olical/aniseed {}; :tag "v3.16.0"}
  
  ; general purpose lua wrappers for nvim stuff
  :norcalli/nvim.lua {}

  ;:glepnir/galaxyline.nvim {:mod "plugins.galaxyline"
                            ;:after "gruvbox"}

  :Famiu/feline.nvim {:mod "plugins.feline"
                      :after "gruvbox"}

  ;:gwimm/lililine.nvim {:after "gruvbox"
                        ;:mod "plugins.lililine"}

  :akinsho/nvim-bufferline.lua {:mod "plugins.bufferline"}
  ;:romgrk/barbar.nvim {:mod "plugins.barbar"}

  :sindrets/diffview.nvim {:mod "plugins.diffview"}
  :tweekmonster/startuptime.vim {:cmd ["StartupTime"]}
  :tpope/vim-repeat {}

  :junegunn/goyo.vim {:cmd "Goyo"}
  
  :lewis6991/gitsigns.nvim {:mod "plugins.gitsigns"}


  :tpope/vim-fugitive {}
  :preservim/nerdcommenter {}
  :godlygeek/tabular {:cmd ["Tabularize"]} ; :Tab /regex can align code on occurrences of the given regex. I.e. :Tab /= aligns all = signs in a block.
  :tpope/vim-surround {}
  :nathanaelkane/vim-indent-guides {} ; Can be toggled using <leader>ig (intent-guides)

  ; <C-n> to select current word. <C-n> to select next occurrence.
  ; with multiple lines selected in Visual mode, <C-n> to insert cursor in each line. I not i to insert in Visual-mode.
  :terryma/vim-multiple-cursors {}
  :mg979/vim-visual-multi {}
  :hauleth/sad.vim {}          ; Use siw instead of ciw. when using . afterwards, will find the next occurrence of the changed word and change it too
  :wellle/targets.vim {}       ; more text objects. IE: cin (change in next parens). generally better handling of surrounding objects.

  :iamcco/markdown-preview.nvim {:run vim.fn.mkdp#util#install}

  ; code-related ----------------------------------------- <<<

  :folke/lsp-trouble.nvim {:mod "plugins.trouble"}
  :simrat39/symbols-outline.nvim {:mod "plugins.symbols-outline"}
  :neovim/nvim-lspconfig {}

  ;:hrsh7th/nvim-compe {:mod "plugins.compe"}
  :/home/leon/coding/prs/nvim-compe {:mod "plugins.compe"}


  :glepnir/lspsaga.nvim {:mod "plugins.lspsaga"}


  :Olical/conjure {}
  :tami5/compe-conjure {:requires [:Olical/conjure]}

  :ciaranm/detectindent {:mod "plugins.detect-indent"}
  :pechorin/any-jump.vim {}
  :justinmk/vim-sneak {:mod "plugins.sneak"}
  :psliwka/vim-smoothie {}
  :editorconfig/editorconfig-vim {}
  :tommcdo/vim-exchange {}

  ;:frazrepo/vim-rainbow {}

  ;:bhurlow/vim-parinfer {:ft ["fennel" "carp" "lisp" "elisp"]}

  :eraserhd/parinfer-rust {:run "cargo build --release"}

  :bduggan/vim-raku {:ft ["raku"]}
  :LnL7/vim-nix {:ft ["nix"]}

  :kevinoid/vim-jsonc {}

  :norcalli/nvim-colorizer.lua {:mod "plugins.nvim-colorizer"}
  :pangloss/vim-javascript {} ; syntax highlighting JS
  :ianks/vim-tsx {}
  :leafgarland/typescript-vim {}
  :sheerun/vim-polyglot {}    ; Syntax highlighting for most languages
  :HerringtonDarkholme/yats.vim {} ; typescript syntax highlighting
  :mxw/vim-jsx {}
  :mattn/emmet-vim {:mod "plugins.emmet"}

  :purescript-contrib/purescript-vim {}


  :derekelkins/agda-vim {:ft ["agda"]}
  :neovimhaskell/haskell-vim { :ft ["haskell"]}

  :rust-lang/rust.vim {:ft ["rust"]
                       :requires ["mattn/webapi-vim"]}
  :simrat39/rust-tools.nvim {:ft ["rust"]}
   :qnighy/lalrpop.vim {}

  :ray-x/lsp_signature.nvim {}

  :vmchale/ats-vim {:ft ["ats"]}

  :bakpakin/fennel.vim {})
; >>>


; vim:foldmarker=<<<,>>>


