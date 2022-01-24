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


(macro cfg [config-mod opts]
  (let [a (require "aniseed.core")]
    (a.assoc (or opts {}) 
      :opt `false 
      :config `#(require ,config-mod))))

(use
  ; sort me pls

  :github/copilot.vim {:opt true :cmd ["Copilot"]}

  :lervag/vimtex {:opt false 
                  :setup #(require :dots.plugins.vimtex)}

  :brymer-meneses/grammar-guard.nvim {:opt false
                                      :requires ["williamboman/nvim-lsp-installer"
                                                 "neovim/nvim-lspconfig"]}

  ; sorted from here!
  :Olical/aniseed {:branch "develop"}
  :lewis6991/impatient.nvim {}
  :nvim-lua/plenary.nvim {}
  :norcalli/nvim.lua {}
  :lifepillar/vim-gruvbox8 (cfg "dots.plugins.gruvbox8")
  :kyazdani42/nvim-web-devicons {}
  :folke/which-key.nvim {}

  :Famiu/feline.nvim (cfg "dots.plugins.feline")
  :akinsho/nvim-bufferline.lua (cfg "dots.plugins.bufferline")

  :psliwka/vim-smoothie {}
  :norcalli/nvim-colorizer.lua (cfg "dots.plugins.nvim-colorizer")
  :nathanaelkane/vim-indent-guides {:cmd ["IndentGuidesToggle"]}
  :luukvbaal/stabilize.nvim {:opt false :config #((. (require :stabilize) :setup))}

  :tweekmonster/startuptime.vim {:cmd ["StartupTime"]}
  :folke/persistence.nvim (cfg "dots.plugins.persistence")
  :folke/zen-mode.nvim (cfg "dots.plugins.zen-mode" {:cmd ["ZenMode"]})
  :folke/twilight.nvim (cfg "dots.plugins.twilight")
  :nvim-telescope/telescope.nvim {:config #(require "dots.plugins.telescope")
                                  :cmd ["Telescope"]
                                  :requires [:nvim-lua/popup.nvim :nvim-lua/plenary.nvim]}

  ; editing and movement <<<
  :jiangmiao/auto-pairs {}
  :tpope/vim-repeat {}
  :preservim/nerdcommenter {}
  :godlygeek/tabular {:cmd ["Tabularize"]}
  :tpope/vim-surround {}
  :hauleth/sad.vim {}
  :wellle/targets.vim {} ; more text objects. IE: cin (change in next parens). generally better handling of surrounding objects.
  :mg979/vim-visual-multi {}
  :tommcdo/vim-exchange {}
  :justinmk/vim-sneak {:opt false :config #(require "dots.plugins.sneak")}
  ; >>>
  
  ; treesitter <<<
  :nvim-treesitter/nvim-treesitter {:config #(require "dots.plugins.treesitter") 
                                    :event ["BufEnter"]
                                    :run ":TSUpdate"}

  :JoosepAlviste/nvim-ts-context-commentstring {:event ["BufEnter"]
                                                :requires [:nvim-treesitter/nvim-treesitter]}
  
  :nvim-treesitter/playground {:event ["BufEnter"]
                               :requires [:nvim-treesitter/nvim-treesitter]}
  ; >>>
 
  ; debugger <<<
  :rcarriga/nvim-dap-ui {:opt false 
                         :config #((. (require :dapui) :setup))
                         :requires [:mfussenegger/nvim-dap]}

  
  :mfussenegger/nvim-dap {:opt false :config #(require "dots.plugins.nvim-dap")}
  
  :nvim-telescope/telescope-dap.nvim {:requires [:mfussenegger/nvim-dap
                                                 :nvim-telescope/telescope.nvim]}

  ; >>>

  ; git stuff  <<<
  :sindrets/diffview.nvim {:cmd ["DiffviewOpen" "DiffviewToggleFiles"]
                           :config #(require "dots.plugins.diffview")}
  
  :lewis6991/gitsigns.nvim {:after ["vim-gruvbox8"]
                            :opt false
                            :config #(require "dots.plugins.gitsigns")}

  :ruanyl/vim-gh-line {}
  :rhysd/conflict-marker.vim {}
  :tpope/vim-fugitive {}
  :TimUntersberger/neogit {:config #(require "dots.plugins.neogit")
                           :cmd ["Neogit"]}

  ; >>>

  ; lsp <<<
  :ray-x/lsp_signature.nvim {:events [:BufEnter]}
  :weilbith/nvim-code-action-menu {}
  
  ;:elkowar/trouble.nvim {:config #(require "dots.plugins.trouble")
                         ;:cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]

  :folke/lsp-trouble.nvim {:opt false :config #(require "dots.plugins.trouble")
                           :cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
  
  :simrat39/symbols-outline.nvim {:opt false :config #(require "dots.plugins.symbols-outline")}
  
  :neovim/nvim-lspconfig {}

  ;:ms-jpq/coq_nvim {:opt false :config #(require "dots.plugins.coq-nvim") 
                    ;:branch "coq"
  ;:ms-jpq/coq.artifacts {:branch "artifacts"}

  :tami5/lspsaga.nvim {:after "vim-gruvbox8"
                       :opt false 
                       :branch "nvim6.0"
                       :config #(require "dots.plugins.lspsaga")}

  ; >>>

  ; cmp <<<
  :hrsh7th/vim-vsnip {}
  :hrsh7th/vim-vsnip-integ {}
  :rafamadriz/friendly-snippets {}

  :hrsh7th/cmp-omni {}
  ;:hrsh7th/cmp-vsnip {}
  :hrsh7th/cmp-nvim-lsp {}
  :hrsh7th/cmp-buffer {}
  :hrsh7th/cmp-path {}
  :hrsh7th/cmp-nvim-lua {}
  :hrsh7th/cmp-calc {}
  
  :hrsh7th/nvim-cmp {:opt false 
                     :commit "4c0a6512a0f8a235213959badf70031b9fa0220a"
                     :requires [:hrsh7th/cmp-nvim-lsp 
                                :hrsh7th/cmp-buffer
                                :hrsh7th/cmp-vsnip
                                :hrsh7th/cmp-nvim-lua
                                :hrsh7th/cmp-calc
                                :hrsh7th/cmp-path
                                :hrsh7th/cmp-omni]
                     :config #(require "dots.plugins.cmp")}
  ; >>>

  ; code-related ----------------------------------------- <<<
  :tpope/vim-sleuth {}
  :editorconfig/editorconfig-vim {}
  :pechorin/any-jump.vim {}
  :sbdchd/neoformat {}
  :elkowar/antifennel-nvim {:opt false :config #(set vim.g.antifennel_executable "/home/leon/tmp/antifennel/antifennel")}
  :Olical/conjure {:ft ["fennel"]}
  :eraserhd/parinfer-rust {:run "cargo build --release"}


  :kmonad/kmonad-vim {}
  :elkowar/yuck.vim {:ft ["yuck"]}
  :cespare/vim-toml {:ft ["toml"]}
  :bduggan/vim-raku {:ft ["raku"]}
  :LnL7/vim-nix {:ft ["nix"]}
  :kevinoid/vim-jsonc {}
  :pangloss/vim-javascript {:ft ["javascript"]} ; syntax highlighting JS
  :ianks/vim-tsx {:ft ["typescript-react"]}
  :leafgarland/typescript-vim {:ft ["typescript" "typescript-react" "javascript"]}
  :HerringtonDarkholme/yats.vim {} ; typescript syntax highlighting
  :mxw/vim-jsx {}
  :mattn/emmet-vim {:opt false :config #(require "dots.plugins.emmet")}
  :purescript-contrib/purescript-vim {:ft ["purescript"]}
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
  :bakpakin/fennel.vim {:ft ["fennel"]}
  :evanleck/vim-svelte {})


; >>>

(require "packer_compiled")

; vim:foldmarker=<<<,>>>


