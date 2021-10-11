(module dots.plugins
  {autoload {a aniseed.core
             packer packer}
   require-macros [macros]})



(defn- safe-req-conf [name]
  "safely require a plugins configuration module, prepending 'dots.plugins.' to the given module name"
  (let [(ok? val-or-err) (pcall require (.. "dots.plugins." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(defn use [...]
  (let [pkgs [...]]
    (packer.startup
      {1 (fn [use]
           (for [i 1 (a.count pkgs) 2]
             (let [name (. pkgs i)
                   opts (. pkgs (+ i 1))]
               (-?> (. opts :mod) (safe-req-conf))
               (use (a.assoc opts 1 name)))))
       :config {:compile_path (.. (vim.fn.stdpath "config") "/lua/packer_compiled.lua")}})))
      
(use
  :lewis6991/impatient.nvim {}
  :elkowar/yuck.vim {}
  :nvim-lua/plenary.nvim {}
  :elkowar/antifennel-nvim {:opt false :config #(set vim.g.antifennel_executable "/home/leon/tmp/antifennel/antifennel")}
  :elkowar/kmonad.vim {}

  :ruanyl/vim-gh-line {}
  :rhysd/conflict-marker.vim {}
  :wellle/visual-split.vim {}
  :sindrets/diffview.nvim {}
  :folke/persistence.nvim {:opt false :config #(require "dots.plugins.persistence")}
  
  :folke/zen-mode.nvim {:cmd ["ZenMode"]
                        :config #(require "dots.plugins.zen-mode")}
  
  :folke/twilight.nvim {:config #(require "dots.plugins.twilight")}

  :TimUntersberger/neogit {:config #(require "dots.plugins.neogit")
                           :cmd ["Neogit"]}

  
  :lifepillar/vim-gruvbox8 {:opt false
                            :config
                            (fn []
                              (set vim.g.gruvbox_italics 0)
                              (set vim.g.gruvbox_italicise_strings 0)
                              (set vim.g.gruvbox_filetype_hi_groups 1)
                              (set vim.g.gruvbox_plugin_hi_groups 1)
                              (vim.cmd "colorscheme gruvbox8")
                              ((. (require :dots.utils) :highlight) :SignColumn {:bg (. (require :dots.colors) :dark0)}))}
                                       ;(req dots.utils.highlight :SignColumn {:bg (. (require :dots.colors) :dark0)}))}
                                       ;(req dots.utils.highlight :LspDiagnosticsUnderlineError {:gui "underline"}))}

  
  :nvim-telescope/telescope.nvim {:config #(require "dots.plugins.telescope")
                                  :cmd ["Telescope"]
                                   :requires [:nvim-lua/popup.nvim 
                                              :nvim-lua/plenary.nvim]}

  
  :nvim-telescope/telescope-packer.nvim {}
                                             
  

  
  :kyazdani42/nvim-web-devicons {}

  
  :nvim-treesitter/nvim-treesitter {:config #(require "dots.plugins.treesitter") 
                                    :event ["BufEnter"]
                                    :run ":TSUpdate"}

  
  :JoosepAlviste/nvim-ts-context-commentstring {:event ["BufEnter"]
                                                :requires [:nvim-treesitter/nvim-treesitter]}
  
  :nvim-treesitter/playground {:event ["BufEnter"]
                               :requires [:nvim-treesitter/nvim-treesitter]}
  :jiangmiao/auto-pairs {}

  :folke/which-key.nvim {}

  :Olical/aniseed {:branch "develop"}
  
  :norcalli/nvim.lua {}
  
  :Famiu/feline.nvim {:opt false :config #(require "dots.plugins.feline")}
  :akinsho/nvim-bufferline.lua {:opt false :config #(require "dots.plugins.bufferline")}

  :sindrets/diffview.nvim {:cmd ["DiffviewOpen" "DiffviewToggleFiles"]
                           :config #(require "dots.plugins.diffview")}
  
  :tweekmonster/startuptime.vim {:cmd ["StartupTime"]}
  
  :tpope/vim-repeat {}

  
  :lewis6991/gitsigns.nvim {:after ["vim-gruvbox8"]
                            :opt false
                            :config #(require "dots.plugins.gitsigns")}


  
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

  ; ( use :iamcco/markdown-preview.nvim {:run vim.fn.mkdp#util#install})

  
  :rcarriga/nvim-dap-ui {:opt false 
                         :config #((. (require :dapui) :setup))
                         :requires [:mfussenegger/nvim-dap]}

  
  :mfussenegger/nvim-dap {:opt false :config #(require "dots.plugins.nvim-dap")}
  
  :nvim-telescope/telescope-dap.nvim {:requires [:mfussenegger/nvim-dap
                                                 :nvim-telescope/telescope.nvim]}

  ; code-related ----------------------------------------- <<<


  
  :ray-x/lsp_signature.nvim {:events [:BufEnter]}
  
  "/home/leon/coding/prs/trouble.nvim" {:opt false :config #(require "dots.plugins.trouble")
                                        :cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
  ;:folke/lsp-trouble.nvim {:opt false :config #(require "dots.plugins.trouble")
                           ;:cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
  
  :simrat39/symbols-outline.nvim {:opt false :config #(require "dots.plugins.symbols-outline")}
  
  :neovim/nvim-lspconfig {}

  ;:ms-jpq/coq_nvim {:opt false :config #(require "dots.plugins.coq-nvim") 
                    ;:branch "coq"
  ;:ms-jpq/coq.artifacts {:branch "artifacts"}

  :hrsh7th/vim-vsnip {}

  :hrsh7th/cmp-vsnip {}
  :hrsh7th/cmp-nvim-lsp {}
  :hrsh7th/cmp-buffer {}
  :hrsh7th/cmp-path {}
  :hrsh7th/cmp-nvim-lua {}
  :hrsh7th/cmp-calc {}
  
  :hrsh7th/nvim-cmp {:opt false 
                     :requires [:hrsh7th/cmp-nvim-lsp 
                                :hrsh7th/cmp-buffer
                                :hrsh7th/cmp-vsnip
                                :hrsh7th/cmp-nvim-lua
                                :hrsh7th/cmp-calc
                                :hrsh7th/cmp-path]
                                

                     :config #(require "dots.plugins.cmp")}



  
  :tami5/lspsaga.nvim {:after "vim-gruvbox8"
                       :opt false 
                       :commit "373bc031b39730cbfe492533c3acfac36007899a"
                       :config #(require "dots.plugins.lspsaga")}

  
  :sbdchd/neoformat {}


  ;; --------------------

  :Olical/conjure {}
  :ciaranm/detectindent {:opt false :config #(require "dots.plugins.detect-indent")}
  :pechorin/any-jump.vim {}
  :justinmk/vim-sneak {:opt false :config #(require "dots.plugins.sneak")}
  :psliwka/vim-smoothie {}
  :editorconfig/editorconfig-vim {}
  :tommcdo/vim-exchange {}
  :eraserhd/parinfer-rust {:run "cargo build --release"}

  :cespare/vim-toml {}
  :bduggan/vim-raku {:ft ["raku"]}
  :LnL7/vim-nix {:ft ["nix"]}
  :kevinoid/vim-jsonc {}
  :norcalli/nvim-colorizer.lua {:opt false :config #(require "dots.plugins.nvim-colorizer")}
  :pangloss/vim-javascript {} ; syntax highlighting JS
  :ianks/vim-tsx {}
  :leafgarland/typescript-vim {}
  :HerringtonDarkholme/yats.vim {} ; typescript syntax highlighting
  :mxw/vim-jsx {}
  :mattn/emmet-vim {:opt false :config #(require "dots.plugins.emmet")}
  :purescript-contrib/purescript-vim {}
  :derekelkins/agda-vim {:ft ["agda"]}
  :neovimhaskell/haskell-vim { :ft ["haskell"]}

  
  :rust-lang/rust.vim {:ft ["rust"]
                       :requires ["mattn/webapi-vim"]
                       :opt false :config #(do (set vim.g.rustfmt_fail_silently 1))}
                                  
  :simrat39/rust-tools.nvim {:requires ["nvim-lua/popup.nvim" "nvim-lua/plenary.nvim"]}

  :Saecki/crates.nvim {:requires ["nvim-lua/plenary.nvim"]
                       :event ["BufRead Cargo.toml"]
                       :opt false :config #((. (require "crates") :setup))}

  :qnighy/lalrpop.vim {}
  :edwinb/idris2-vim {:ft ["idris2"]}
  :vmchale/ats-vim {:ft ["ats" "dats" "sats"]}
  :google/vim-jsonnet {}
  :bakpakin/fennel.vim {}
  :evanleck/vim-svelte {})

(require "packer_compiled")

; >>>


; vim:foldmarker=<<<,>>>


