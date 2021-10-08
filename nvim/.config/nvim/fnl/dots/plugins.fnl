






(module dots.plugins
  {require {a aniseed.core}
   require-macros [macros]})



(defn abuse [use stuff rest]
  (use (a.assoc rest 1 stuff)))




(local packer (require :packer))
(packer.startup
 (fn [use]
  (abuse
   use "/home/leon/coding/projects/nvim-gehzu" {})
  (abuse
   use "/home/leon/coding/projects/yuck.vim" {})
  (abuse
   use :nvim-lua/plenary.nvim {})
  (abuse
   use :elkowar/antifennel-nvim {:opt false :config #(set vim.g.antifennel_executable "/home/leon/tmp/antifennel/antifennel")})
  (abuse
   use :elkowar/kmonad.vim {})

  (abuse
   use :ruanyl/vim-gh-line {})
  (abuse
   use :rhysd/conflict-marker.vim {})
  (abuse
   use :wellle/visual-split.vim {})
  (abuse
   use :sindrets/diffview.nvim {})
  (abuse
   use :folke/persistence.nvim {:opt false :config #(require "dots.plugins.persistence")})
  (abuse
   use :folke/zen-mode.nvim {:cmd ["ZenMode"]
                             :opt false :config #(require "dots.plugins.zen-mode")})
  (abuse
   use :folke/twilight.nvim {:opt false :config #(require "dots.plugins.twilight")})
  (abuse
   use :TimUntersberger/neogit {:opt false :config #(require "dots.plugins.neogit")
                                :cmd ["Neogit"]})

  (abuse
   use :lifepillar/vim-gruvbox8 {:opt false
                                 :config
                                 #(do (set vim.g.gruvbox_italics 0)
                                      (set vim.g.gruvbox_italicise_strings 0)
                                      (set vim.g.gruvbox_filetype_hi_groups 1)
                                      (set vim.g.gruvbox_plugin_hi_groups 1)
                                      (vim.cmd "colorscheme gruvbox8")
                                      ((. (require :dots.utils) :highlight) :SignColumn {:bg (. (require :dots.colors) :dark0)}))})
                                       ;(req dots.utils.highlight :SignColumn {:bg (. (require :dots.colors) :dark0)}))}
                                       ;(req dots.utils.highlight :LspDiagnosticsUnderlineError {:gui "underline"}))}

  (abuse
   use :nvim-telescope/telescope.nvim {:opt false :config #(require "dots.plugins.telescope")
                                       :cmd ["Telescope"]
                                        :requires [:nvim-lua/popup.nvim 
                                                   :nvim-lua/plenary.nvim]})

  (abuse
   use :nvim-telescope/telescope-packer.nvim {})
  (abuse
   use :nvim-telescope/telescope-frecency.nvim {:requires [:tami5/sql.nvim]
                                                :opt false})
                                           ;:opt false :config #((. (require :telescope) :load_extension) "frecency")}
                                             
  

  (abuse
   use :kyazdani42/nvim-web-devicons {})

  (abuse
   use :nvim-treesitter/nvim-treesitter {:opt false :config #(require "dots.plugins.treesitter") 
                                         :event ["BufEnter"]
                                         :run ":TSUpdate"})

  (abuse
   use :JoosepAlviste/nvim-ts-context-commentstring {:event ["BufEnter"]
                                                     :requires [:nvim-treesitter/nvim-treesitter]})
  (abuse
   use :nvim-treesitter/playground {:event ["BufEnter"]
                                    :requires [:nvim-treesitter/nvim-treesitter]})
  ;:p00f/nvim-ts-rainbow {}
  ;:romgrk/nvim-treesitter-context {}


  ;:code-biscuits/nvim-biscuits {:requires [:nvim-treesitter/nvim-treesitter]
                                  ;:event ["BufReadPost"]
                                  ;:opt false :config #((. (require "nvim-biscuits") :setup) {})}
                                


  (abuse
   use :jiangmiao/auto-pairs {})

  (abuse
   use :folke/which-key.nvim {})

  ; json query stuff
  ;:gennaro-tedesco/nvim-jqx {:ft ["json"]}

  (abuse use :Olical/aniseed {:branch "develop"}); :tag "v3.16.0"}
  ;(abuse use :Olical/aniseed {:tag "v3.21.0"}); :tag "v3.16.0"}
  ; (abuse use :Olical/aniseed {:branch "master"}); :tag "v3.16.0"}
  ;:Olical/aniseed {}; :tag "v3.16.0"}
  
  ; general purpose lua wrappers for nvim stuff
  (abuse
   use :norcalli/nvim.lua {})

  (abuse
   use :Famiu/feline.nvim {:opt false :config #(require "dots.plugins.feline")})
                      ;config #(require "dots.plugins.feline")}

  (abuse
   use :akinsho/nvim-bufferline.lua {:opt false :config #(require "dots.plugins.bufferline")})
  ;:romgrk/barbar.nvim {:opt false :config #(require "dots.plugins.barbar")}

  (abuse
    use
    :sindrets/diffview.nvim {:cmd ["DiffviewOpen" "DiffviewToggleFiles"]
                             :opt false :config #(require "dots.plugins.diffview")})
  (abuse
   use :tweekmonster/startuptime.vim {:cmd ["StartupTime"]})
  (abuse
   use :tpope/vim-repeat {})

  (abuse
   use :lewis6991/gitsigns.nvim {:after ["vim-gruvbox8"]
                                 :opt false :config #(require "dots.plugins.gitsigns")})


  (abuse
   use :tpope/vim-fugitive {})
  (abuse
   use :preservim/nerdcommenter {})
  (abuse
   use :godlygeek/tabular {:cmd ["Tabularize"]}) ; :Tab /regex can align code on occurrences of the given regex. I.e. :Tab /= aligns all = signs in a block.
  (abuse
   use :tpope/vim-surround {})
  (abuse
   use :nathanaelkane/vim-indent-guides {}) ; Can be toggled using <leader>ig (intent-guides)

  ; <C-n> to select current word. <C-n> to select next occurrence.
  ; with multiple lines selected in Visual mode, <C-n> to insert cursor in each line. I not i to insert in Visual-mode.
  (abuse
   use :terryma/vim-multiple-cursors {})
  (abuse
   use :mg979/vim-visual-multi {})
  (abuse
   use :hauleth/sad.vim {})          ; Use siw instead of ciw. when using . afterwards, will find the next occurrence of the changed word and change it too
  (abuse
   use :wellle/targets.vim {})       ; more text objects. IE: cin (change in next parens). generally better handling of surrounding objects.

  ; (abuse use :iamcco/markdown-preview.nvim {:run vim.fn.mkdp#util#install})

  (abuse
    use
    :rcarriga/nvim-dap-ui {:opt false 
                           :opt false :config #((. (require :dapui) :setup))
                           ;:opt false :config #(req dapui.setup)
                           :requires [:mfussenegger/nvim-dap]})

  (abuse
   use :mfussenegger/nvim-dap {:opt false})
                          ;:opt false :config #(require "dots.plugins.nvim-dap")}
  (abuse
    use
    :nvim-telescope/telescope-dap.nvim {:opt false
                                        :requires [:mfussenegger/nvim-dap
                                                   :nvim-telescope/telescope.nvim]})

  ; code-related ----------------------------------------- <<<


  (abuse
   use :ray-x/lsp_signature.nvim {:events [:BufEnter]})
  (abuse
    use
    "/home/leon/coding/prs/trouble.nvim" {:opt false :config #(require "dots.plugins.trouble")
                                          :cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]})
  ;:folke/lsp-trouble.nvim {:opt false :config #(require "dots.plugins.trouble")
                           ;:cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
  (abuse
    use
    :simrat39/symbols-outline.nvim {:opt false :config #(require "dots.plugins.symbols-outline")})
  (abuse
    use
    :neovim/nvim-lspconfig {})

  ;:hrsh7th/nvim-compe {:opt false :config #(require "dots.plugins.compe")}
  ;:/home/leon/coding/prs/nvim-compe {:event [:InsertEnter]
                                     ;:opt false :config #(require "dots.plugins.compe")}
  ;:ms-jpq/coq_nvim {:opt false :config #(require "dots.plugins.coq-nvim") 
                    ;:branch "coq"

  ;:ms-jpq/coq.artifacts {:branch "artifacts"}

  (abuse use :hrsh7th/cmp-nvim-lsp {})
  (abuse use :hrsh7th/cmp-buffer {})
  (abuse
    use
    :hrsh7th/nvim-cmp
    {:opt false 
     :requires [:hrsh7th/cmp-nvim-lsp :hrsh7th/cmp-buffer]
     :config #(require "dots.plugins.cmp")})



  (abuse
    use
    :tami5/lspsaga.nvim {:after "vim-gruvbox8"
                         :opt false 
                         :config #(require "dots.plugins.lspsaga")})

  (abuse
    use
    :sbdchd/neoformat {})


  ;; --------------------

  ; (use :AndrewRadev/splitjoin.vim {})

  (abuse
    use
    :Olical/conjure {})

  (abuse
    use
    :tami5/compe-conjure {:requires [:Olical/conjure]})

  (abuse 
    use
    :ciaranm/detectindent {:opt false :config #(require "dots.plugins.detect-indent")})
  (abuse
   use :pechorin/any-jump.vim {})
  (abuse
   use :justinmk/vim-sneak {:opt false :config #(require "dots.plugins.sneak")})
  (abuse
   use :psliwka/vim-smoothie {})
  (abuse
   use :editorconfig/editorconfig-vim {})
  (abuse
   use :tommcdo/vim-exchange {})

  ;:frazrepo/vim-rainbow {}

  ;:bhurlow/vim-parinfer {:ft ["fennel" "carp" "lisp" "elisp"]}

  (abuse use :eraserhd/parinfer-rust {:run "cargo build --release"})

  ;:/home/leon/coding/prs/parinfer-rust {}
  ;"elkowar/parinfer-rust" {:run "cargo build --release"
                           ;:branch "yuck"}

  (abuse
   use :bduggan/vim-raku {:ft ["raku"]})
  (abuse
   use :LnL7/vim-nix {:ft ["nix"]})

  (abuse
   use :kevinoid/vim-jsonc {})

  (abuse
   use :norcalli/nvim-colorizer.lua {:opt false :config #(require "dots.plugins.nvim-colorizer")})
  (abuse
   use :pangloss/vim-javascript {}) ; syntax highlighting JS
  (abuse
   use :ianks/vim-tsx {})
  (abuse
   use :leafgarland/typescript-vim {})
  (abuse
   use :HerringtonDarkholme/yats.vim {}) ; typescript syntax highlighting
  (abuse
   use :mxw/vim-jsx {})
  (abuse
   use :mattn/emmet-vim {:opt false :config #(require "dots.plugins.emmet")})

  (abuse
   use :purescript-contrib/purescript-vim {})


  (abuse
   use :derekelkins/agda-vim {:ft ["agda"]})
  (abuse
   use :neovimhaskell/haskell-vim { :ft ["haskell"]})

  (abuse
    use
    :rust-lang/rust.vim {:ft ["rust"]
                         :requires ["mattn/webapi-vim"]
                         :opt false :config #(do (set vim.g.rustfmt_fail_silently 1))})
                                  
  (abuse 
    use
    :simrat39/rust-tools.nvim {:requires ["nvim-lua/popup.nvim" "nvim-lua/plenary.nvim"]})

  ; (use
  ;   :Saecki/crates.nvim {:requires ["nvim-lua/plenary.nvim"]
  ;                        :event ["BufRead Cargo.toml"]
  ;                        :opt false :config #((. (require "crates") :setup))})

  (abuse 
    use
    :qnighy/lalrpop.vim {})

  (abuse
    use
    :edwinb/idris2-vim {:ft ["idris2"]})
  ;:ShinKage/nvim-idris2 {}
  (abuse
    use
    :vmchale/ats-vim {:ft ["ats" "dats" "sats"]})

  (abuse
    use
    :google/vim-jsonnet {})

  (abuse
    use
    :bakpakin/fennel.vim {})

  (abuse
    use
    :evanleck/vim-svelte {})))

; >>>


; vim:foldmarker=<<<,>>>


