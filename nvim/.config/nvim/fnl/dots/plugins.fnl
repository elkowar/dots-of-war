(module dots.plugins
  {autoload {a aniseed.core
             lazy lazy}
   require-macros [macros]})



(defn- safe-req-conf [name]
  "safely require a plugins configuration module, prepending 'dots.plugins.' to the given module name"
  (let [(ok? val-or-err) (pcall require (.. "dots.plugins." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(defn setup-lazy [...]
  (let [pkgs [...]]
    (local args [])
    (for [i 1 (a.count pkgs) 2]
      (let [name (. pkgs i)
            opts (. pkgs (+ i 1))]
        (table.insert args (a.assoc opts 1 name))))
    (lazy.setup args)))



(macro cfg [config-mod opts]
  (let [a (require "aniseed.core")]
    (a.assoc (or opts {}) 
      :opt `false 
      :config `#(require ,config-mod))))

(macro setup [name opts]
  `((. (require ,name) :setup) ,opts))


(setup-lazy
  ; TODO sort me pls

  ; sorted from here!
  :Olical/aniseed {:branch "develop"}
  :lewis6991/impatient.nvim {}
  :nvim-lua/plenary.nvim {}
  :norcalli/nvim.lua {}
  :lifepillar/vim-gruvbox8 {:config #(require "dots.plugins.gruvbox8")}
  :kyazdani42/nvim-web-devicons {}
  :folke/which-key.nvim {}
  :folke/todo-comments.nvim {:config #(require "dots.plugins.todo-comments")}

  :Famiu/feline.nvim {:config #(require "dots.plugins.feline")}
  :akinsho/nvim-bufferline.lua {:config #(require "dots.plugins.bufferline")
                                :tag "v1.1.1"}

  :psliwka/vim-smoothie {}
  :norcalli/nvim-colorizer.lua {:config #(require "dots.plugins.nvim-colorizer")}
  :nathanaelkane/vim-indent-guides {:cmd ["IndentGuidesToggle"]}
  :luukvbaal/stabilize.nvim {:config #(setup :stabilize)}

  :tweekmonster/startuptime.vim {:cmd ["StartupTime"]}
  :folke/noice.nvim {:config #(setup :noice {:presets {:inc_rename true}})
                     :dependencies [:MunifTanjim/nui.nvim]}
  :folke/persistence.nvim {:config #(require "dots.plugins.persistence")}
  :folke/zen-mode.nvim {:config #(require "dots.plugins.zen-mode")
                        :cmd ["ZenMode"]}
  :folke/twilight.nvim {:config #(require "dots.plugins.twilight")}
  :nvim-telescope/telescope.nvim {:config #(require "dots.plugins.telescope")
                                  :cmd ["Telescope"]
                                  :dependencies [:nvim-lua/popup.nvim :nvim-lua/plenary.nvim]}

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
  :justinmk/vim-sneak {:config #(require "dots.plugins.sneak")}
  ; >>>
  
  ; treesitter <<<
  :nvim-treesitter/nvim-treesitter {:config #(require "dots.plugins.treesitter") 
                                    :event ["BufEnter"]
                                    :build ":TSUpdate"}

  :JoosepAlviste/nvim-ts-context-commentstring {:event ["BufEnter"]
                                                :dependencies [:nvim-treesitter/nvim-treesitter]}
  
  :nvim-treesitter/playground {:event ["BufEnter"]
                               :dependencies [:nvim-treesitter/nvim-treesitter]}
  ; >>>
 
  ; debugger <<<
  :rcarriga/nvim-dap-ui {:config #(setup :dapui)
                         :dependencies [:mfussenegger/nvim-dap]}
  :mfussenegger/nvim-dap {}
  :nvim-telescope/telescope-dap.nvim {:dependencies [:mfussenegger/nvim-dap
                                                     :nvim-telescope/telescope.nvim]}

  ; >>>

  ; git stuff  <<<
  :ldelossa/gh.nvim {:config #(do ((. (require "litee.lib") :setup))
                                  ((. (require "litee.gh") :setup)))
                     :dependencies [:ldelossa/litee.nvim]}
  :pwntester/octo.nvim {:dependencies [:nvim-lua/plenary.nvim
                                       :nvim-telescope/telescope.nvim
                                       :kyazdani42/nvim-web-devicons]
                        :config #(setup :octo)}
  :sindrets/diffview.nvim {:cmd ["DiffviewOpen" "DiffviewToggleFiles"]
                           :config #(require "dots.plugins.diffview")}
  
  :lewis6991/gitsigns.nvim {:after ["vim-gruvbox8"]
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
  
  ;:folke/trouble.nvim {:opt false}
  :elkowar/trouble.nvim {:branch "fix_error_on_nil_window"
                         :config #(require "dots.plugins.trouble")
                         :cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
  
  :simrat39/symbols-outline.nvim {:config #(require "dots.plugins.symbols-outline")}
  
  :neovim/nvim-lspconfig {}

  :smjonas/inc-rename.nvim {:config #(setup :inc_rename)}
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
  
  :hrsh7th/nvim-cmp {:commit "4c0a6512a0f8a235213959badf70031b9fa0220a"
                     :dependencies [:hrsh7th/cmp-nvim-lsp 
                                    :hrsh7th/cmp-buffer
                                    :hrsh7th/cmp-vsnip
                                    :hrsh7th/cmp-nvim-lua
                                    :hrsh7th/cmp-calc
                                    :hrsh7th/cmp-path
                                    :hrsh7th/cmp-omni]
                     :config #(require "dots.plugins.cmp")}
  ; >>>

  ; code-related ----------------------------------------- <<<
  :github/copilot.vim {:cmd ["Copilot"]}

  :tpope/vim-sleuth {}
  :editorconfig/editorconfig-vim {}
  :pechorin/any-jump.vim {}
  :sbdchd/neoformat {}
  :elkowar/antifennel-nvim {:config #(set vim.g.antifennel_executable "/home/leon/tmp/antifennel/antifennel")}
  :Olical/conjure {:ft ["fennel"]}
  :eraserhd/parinfer-rust {:build "cargo build --release"}

  :lervag/vimtex {:config #(require :dots.plugins.vimtex)}
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
  :mattn/emmet-vim {:config #(require "dots.plugins.emmet")}
  :purescript-contrib/purescript-vim {:ft ["purescript"]}
  :derekelkins/agda-vim {:ft ["agda"]}
  :neovimhaskell/haskell-vim { :ft ["haskell"]}
  :stewy33/mercury-vim {} 
  :ionide/Ionide-vim {}

  
  :rust-lang/rust.vim {:ft ["rust"]
                       :dependencies ["mattn/webapi-vim"]
                       :config #(do (set vim.g.rustfmt_fail_silently 1))}
                                  
  :simrat39/rust-tools.nvim {:dependencies ["nvim-lua/popup.nvim" "nvim-lua/plenary.nvim"]}

  :Saecki/crates.nvim {:dependencies ["nvim-lua/plenary.nvim"]
                       :event ["BufRead Cargo.toml"]
                       :config #(setup :crates)}

  :qnighy/lalrpop.vim {}
  :edwinb/idris2-vim {:ft ["idris2"]}
  :vmchale/ats-vim {:ft ["ats" "dats" "sats"]}
  :bakpakin/fennel.vim {:ft ["fennel"]}
  :evanleck/vim-svelte {})


; >>>

;(require "packer_compiled")

; vim:foldmarker=<<<,>>>


