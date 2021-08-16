(module dots.plugins
  {require-macros [macros]})

(packer-use
  "/home/leon/coding/projects/nvim-gehzu" {}
  "/home/leon/coding/projects/yuck.vim" {}
  :elkowar/antifennel-nvim {:config #(set vim.g.antifennel_executable "/home/leon/tmp/antifennel/antifennel")}
  :elkowar/kmonad.vim {}

  :ruanyl/vim-gh-line {}
  :rhysd/conflict-marker.vim {}
  :wellle/visual-split.vim {}
  :sindrets/diffview.nvim {}
  :TimUntersberger/neogit {:mod "dots.plugins.neogit"
                           :cmd ["Neogit"]}

  :lifepillar/vim-gruvbox8 {:opt false
                            :config #(do (set vim.g.gruvbox_italics 0)
                                         (set vim.g.gruvbox_italicise_strings 0)
                                         (set vim.g.gruvbox_filetype_hi_groups 1)
                                         (set vim.g.gruvbox_plugin_hi_groups 1)
                                         (vim.cmd "colorscheme gruvbox8"))}

  :nvim-telescope/telescope.nvim {:mod "dots.plugins.telescope"
                                  :cmd ["Telescope"]
                                  :requires [:nvim-lua/popup.nvim 
                                             :nvim-lua/plenary.nvim]}

  :nvim-telescope/telescope-packer.nvim {}
  :nvim-telescope/telescope-frecency.nvim {:requires [:tami5/sql.nvim]
                                           :opt false}
                                           ;:config #((. (require :telescope) :load_extension) "frecency")}
                                             
  

  :kyazdani42/nvim-web-devicons {}

  :nvim-treesitter/nvim-treesitter {:mod "dots.plugins.treesitter" 
                                    :event ["BufEnter"]
                                    :run ":TSUpdate"}
  :JoosepAlviste/nvim-ts-context-commentstring {:event ["BufEnter"]
                                                :requires [:nvim-treesitter/nvim-treesitter]}
  :nvim-treesitter/playground {:event ["BufEnter"]
                               :requires [:nvim-treesitter/nvim-treesitter]}
  ;:p00f/nvim-ts-rainbow {}
  ;:romgrk/nvim-treesitter-context {}


  ;:code-biscuits/nvim-biscuits {:requires [:nvim-treesitter/nvim-treesitter]
                                ;:event ["BufReadPost"]
                                ;:config #((. (require "nvim-biscuits") :setup) {})}
                                


  :jiangmiao/auto-pairs {}

  :folke/which-key.nvim {}

  ; json query stuff
  ;:gennaro-tedesco/nvim-jqx {:ft ["json"]}

  :Olical/aniseed {:branch "develop"}; :tag "v3.16.0"}
  ;:Olical/aniseed {}; :tag "v3.16.0"}
  
  ; general purpose lua wrappers for nvim stuff
  :norcalli/nvim.lua {}

  :Famiu/feline.nvim {:mod "dots.plugins.feline"}

  :akinsho/nvim-bufferline.lua {:mod "dots.plugins.bufferline"}
  ;:romgrk/barbar.nvim {:mod "dots.plugins.barbar"}

  :sindrets/diffview.nvim {:cmd ["DiffviewOpen" "DiffviewToggleFiles"]
                           :mod "dots.plugins.diffview"}
  :tweekmonster/startuptime.vim {:cmd ["StartupTime"]}
  :tpope/vim-repeat {}

  :junegunn/goyo.vim {:cmd "Goyo"}
  
  :lewis6991/gitsigns.nvim {:after ["vim-gruvbox8"]
                            :mod "dots.plugins.gitsigns"}


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

  :rcarriga/nvim-dap-ui {:opt false 
                         :config #((. (require :dapui) :setup))
                         :requires [:mfussenegger/nvim-dap]}
  :mfussenegger/nvim-dap {:opt false}
                          ;:mod "dots.plugins.nvim-dap"}
  :nvim-telescope/telescope-dap.nvim {:opt false
                                      :requires [:mfussenegger/nvim-dap
                                                 :nvim-telescope/telescope.nvim]}

  ; code-related ----------------------------------------- <<<

  :ray-x/lsp_signature.nvim {:events [:BufEnter]}
  "/home/leon/coding/prs/trouble.nvim" {:mod "dots.plugins.trouble"
                                        :cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
  ;:folke/lsp-trouble.nvim {:mod "dots.plugins.trouble"
                           ;:cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
  :simrat39/symbols-outline.nvim {:mod "dots.plugins.symbols-outline"}
  :neovim/nvim-lspconfig {}

  ;:hrsh7th/nvim-compe {:mod "dots.plugins.compe"}
  ;:/home/leon/coding/prs/nvim-compe {:event [:InsertEnter]
                                     ;:mod "dots.plugins.compe"}
  :ms-jpq/coq_nvim {:mod "dots.plugins.coq-nvim" 
                    :branch "coq"}

  :ms-jpq/coq.artifacts {:branch "artifacts"}




  :glepnir/lspsaga.nvim {:after "vim-gruvbox8"
                         :mod "dots.plugins.lspsaga"}

  :sbdchd/neoformat {}


  ;; --------------------

  :AndrewRadev/splitjoin.vim {}

  :Olical/conjure {}
  :tami5/compe-conjure {:requires [:Olical/conjure]}

  :ciaranm/detectindent {:mod "dots.plugins.detect-indent"}
  :pechorin/any-jump.vim {}
  :justinmk/vim-sneak {:mod "dots.plugins.sneak"}
  :psliwka/vim-smoothie {}
  :editorconfig/editorconfig-vim {}
  :tommcdo/vim-exchange {}

  ;:frazrepo/vim-rainbow {}

  ;:bhurlow/vim-parinfer {:ft ["fennel" "carp" "lisp" "elisp"]}

  ;:eraserhd/parinfer-rust {:run "cargo build --release"}
  "elkowar/parinfer-rust" {:run "cargo build --release"
                           :branch "configure-filetypes"}

  :bduggan/vim-raku {:ft ["raku"]}
  :LnL7/vim-nix {:ft ["nix"]}

  :kevinoid/vim-jsonc {}

  :norcalli/nvim-colorizer.lua {:mod "dots.plugins.nvim-colorizer"}
  :pangloss/vim-javascript {} ; syntax highlighting JS
  :ianks/vim-tsx {}
  :leafgarland/typescript-vim {}
  ;:sheerun/vim-polyglot {:event [:BufEnter]}    ; Syntax highlighting for most languages
  :HerringtonDarkholme/yats.vim {} ; typescript syntax highlighting
  :mxw/vim-jsx {}
  :mattn/emmet-vim {:mod "dots.plugins.emmet"}

  :purescript-contrib/purescript-vim {}


  :derekelkins/agda-vim {:ft ["agda"]}
  :neovimhaskell/haskell-vim { :ft ["haskell"]}

  :rust-lang/rust.vim {:ft ["rust"]
                       :requires ["mattn/webapi-vim"]
                       :config #(do (set vim.g.rustfmt_fail_silently 1))}
                                  
  :simrat39/rust-tools.nvim {:requires ["nvim-lua/popup.nvim" "nvim-lua/plenary.nvim"]}

  :qnighy/lalrpop.vim {}

  :edwinb/idris2-vim {:ft ["idris2"]}
  ;:ShinKage/nvim-idris2 {}
  :vmchale/ats-vim {:ft ["ats" "dats" "sats"]}
  :google/vim-jsonnet {}

  :bakpakin/fennel.vim {}

  :evanleck/vim-svelte {})


; >>>


; vim:foldmarker=<<<,>>>


