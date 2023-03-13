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
    (lazy.setup args {:colorscheme "gruvbox8"})))



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
  ; :lewis6991/impatient.nvim {}
  :nvim-lua/plenary.nvim {}
  :norcalli/nvim.lua {}
  :lifepillar/vim-gruvbox8 {:lazy false :priority 1000 :config #(require "dots.plugins.gruvbox8")}
  :kyazdani42/nvim-web-devicons {}
  :folke/which-key.nvim {}
  :folke/todo-comments.nvim {:lazy true
                             :event "VeryLazy"
                             :config #(require "dots.plugins.todo-comments")}

  :Famiu/feline.nvim {:config #(require "dots.plugins.feline")}
  :akinsho/nvim-bufferline.lua {:config #(require "dots.plugins.bufferline")
                                :tag "v1.1.1"}
  :ckipp01/nvim-jenkinsfile-linter {:dependencies ["nvim-lua/plenary.nvim"]}

  :psliwka/vim-smoothie {}
  :norcalli/nvim-colorizer.lua {:event "VeryLazy"
                                :lazy true
                                :config #(require "dots.plugins.nvim-colorizer")}
  :nathanaelkane/vim-indent-guides {:cmd ["IndentGuidesToggle"]}
  :luukvbaal/stabilize.nvim {:config #(setup :stabilize)}

  :stevearc/dressing.nvim {:config #(setup :dressing)}

  :tweekmonster/startuptime.vim {:cmd ["StartupTime"]}
  :folke/noice.nvim {:config #(require "dots.plugins.noice")
                     :dependencies [:MunifTanjim/nui.nvim]}
  :folke/persistence.nvim {:config #(require "dots.plugins.persistence")}
  :folke/zen-mode.nvim {:config #(require "dots.plugins.zen-mode")
                        :cmd ["ZenMode"]}
  :folke/twilight.nvim {:config #(require "dots.plugins.twilight")}
  :moll/vim-bbye {:lazy true :cmd [:Bdelete :Bwipeout]}
  :nvim-telescope/telescope.nvim {:config #(require "dots.plugins.telescope")
                                  :cmd ["Telescope"]
                                  :dependencies [:nvim-lua/popup.nvim
                                                 :nvim-lua/plenary.nvim]}

  :petertriho/nvim-scrollbar {:event "VeryLazy"
                              :lazy true
                              :config #(setup :scrollbar)}

  "https://git.sr.ht/~whynothugo/lsp_lines.nvim" {:config #(setup :lsp_lines)}


  ; editing and movement <<<
  :jiangmiao/auto-pairs {}
  :tpope/vim-repeat {}
  :preservim/nerdcommenter {:event "VeryLazy"
                            :lazy true
                            :priority 1000}
  :godlygeek/tabular {:cmd ["Tabularize"]}
  :tpope/vim-surround {}
  :hauleth/sad.vim {}
  :wellle/targets.vim {} ; more text objects. IE: cin (change in next parens). generally better handling of surrounding objects.
  :mg979/vim-visual-multi {:lazy true :event "VeryLazy"}
  :tommcdo/vim-exchange {}
  :phaazon/hop.nvim {:lazy true
                     :event "VeryLazy"
                     :config #(setup "hop" {:keys "jfkdls;amvieurow"})}
  ;:justinmk/vim-sneak {:lazy true}
                       ;:config #(require "dots.plugins.sneak")}
  ; >>>
  
  ; treesitter <<<
  :nvim-treesitter/nvim-treesitter {:config #(require "dots.plugins.treesitter") 
                                    :lazy true
                                    :event ["VeryLazy"]
                                    :build ":TSUpdate"}
  :RRethy/nvim-treesitter-textsubjects {:dependencies [:nvim-treesitter/nvim-treesitter]
                                        :lazy true
                                        :event ["VeryLazy"]}
  
  :JoosepAlviste/nvim-ts-context-commentstring {:event ["VeryLazy"]
                                                :lazy true
                                                :dependencies [:nvim-treesitter/nvim-treesitter]}
  
  :nvim-treesitter/playground {:event ["VeryLazy"]
                               :lazy true
                               :dependencies [:nvim-treesitter/nvim-treesitter]}
  ; >>>
 
  ; debugger <<<
  :rcarriga/nvim-dap-ui {:lazy true
                         :config #(setup :dapui)
                         :dependencies [:mfussenegger/nvim-dap]}
  :mfussenegger/nvim-dap {:lazy true}
  :nvim-telescope/telescope-dap.nvim {:lazy true
                                      :dependencies [:nvim-telescope/telescope.nvim
                                                     :mfussenegger/nvim-dap]}
                                                     
                                                     

  ; >>>

  ; git stuff  <<<
  :ldelossa/gh.nvim {:lazy true
                     :config #(do ((. (require "litee.lib") :setup))
                                  ((. (require "litee.gh") :setup)))
                     :dependencies [:ldelossa/litee.nvim]}
  :pwntester/octo.nvim {:lazy true
                        :dependencies [:nvim-lua/plenary.nvim
                                       :nvim-telescope/telescope.nvim
                                       :kyazdani42/nvim-web-devicons]
                        :config #(setup :octo)}
  :sindrets/diffview.nvim {:cmd ["DiffviewOpen" "DiffviewToggleFiles"]
                           :config #(require "dots.plugins.diffview")}
  
  :lewis6991/gitsigns.nvim {:dependencies [:vim-gruvbox8
                                           :petertriho/nvim-scrollbar]
                            :config #(require "dots.plugins.gitsigns")}
                                         


  :ruanyl/vim-gh-line {}
  :rhysd/conflict-marker.vim {}
  :tpope/vim-fugitive {:lazy true :event "VeryLazy"}
  :TimUntersberger/neogit {:config #(require "dots.plugins.neogit")
                           :cmd ["Neogit"]}

  ; >>>

  ; lsp <<<
  :ray-x/lsp_signature.nvim {:event :BufEnter}
  :weilbith/nvim-code-action-menu {:cmd "CodeActionMenu"
                                   :config #(set vim.g.code_action_menu_show_details false)}
  
  :folke/trouble.nvim {:lazy true 
                       :config #(require "dots.plugins.trouble")
                       :cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
                       
  ; :elkowar/trouble.nvim {:branch "fix_error_on_nil_window"
  ;                        :config #(require "dots.plugins.trouble")
  ;                        :cmd ["Trouble" "TroubleClose" "TroubleRefresh" "TroubleToggle"]}
  
  :simrat39/symbols-outline.nvim {:lazy true
                                  :cmd ["SymbolsOutline" "SymbolsOutlineClose" "SymbolsOutlineOpen"]
                                  :config #(require "dots.plugins.symbols-outline")}
  
  :neovim/nvim-lspconfig {:event "VeryLazy"
                          :lazy true}

  :smjonas/inc-rename.nvim {:config #(setup :inc_rename {:input_buffer_type "dressing"})}
  :dnlhc/glance.nvim {:lazy true :config #(require "dots.plugins.glance")}
  ; >>>

  ; cmp <<<
  :hrsh7th/vim-vsnip {:lazy true :event ["VeryLazy"]}
  :hrsh7th/vim-vsnip-integ {:lazy true :event ["VeryLazy"]}
  :rafamadriz/friendly-snippets {}
  
  :hrsh7th/nvim-cmp {:lazy true
                     :event ["VeryLazy"]
                     :dependencies [[:hrsh7th/cmp-nvim-lsp] 
                                    [:hrsh7th/cmp-buffer]
                                    [:hrsh7th/cmp-vsnip]
                                    [:hrsh7th/cmp-nvim-lua]
                                    [:hrsh7th/cmp-calc]
                                    [:hrsh7th/cmp-path]
                                    [:hrsh7th/cmp-nvim-lsp-signature-help]
                                    [:davidsierradz/cmp-conventionalcommits]
                                    [:hrsh7th/cmp-omni]]
                     :config #(require "dots.plugins.cmp")}
  ; >>>

  ; code-related ----------------------------------------- <<<
  ;:github/copilot.vim {:cmd ["Copilot"]}
  :zbirenbaum/copilot.lua {:cmd "Copilot"
                           :event "InsertEnter"
                           :config #(require "dots.plugins.copilot")}

  :monkoose/nvlime {:ft ["lisp"] :dependencies [:monkoose/parsley]}

  :tpope/vim-sleuth {}
  :editorconfig/editorconfig-vim {}
  :pechorin/any-jump.vim {}
  :sbdchd/neoformat {}
  :elkowar/antifennel-nvim {:config #(set vim.g.antifennel_executable "/home/leon/tmp/antifennel/antifennel")}
  :Olical/conjure {:ft ["fennel"]}
  :eraserhd/parinfer-rust {:build "cargo build --release"}

  :lervag/vimtex {:ft ["latex" "tex"]
                  :config #(require :dots.plugins.vimtex)}
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
  :mattn/emmet-vim {:lazy true
                    :config #(require "dots.plugins.emmet")}
  :purescript-contrib/purescript-vim {:ft ["purescript"]}
  :derekelkins/agda-vim {:ft ["agda"]}
  :neovimhaskell/haskell-vim { :ft ["haskell"]}

  
  :rust-lang/rust.vim {:ft ["rust"]
                       :dependencies ["mattn/webapi-vim"]
                       :config #(do (set vim.g.rustfmt_fail_silently 1))}
                                  
  :simrat39/rust-tools.nvim {:ft ["rust" "toml"]
                             :dependencies ["nvim-lua/popup.nvim" "nvim-lua/plenary.nvim"]}

  :Saecki/crates.nvim {:dependencies ["nvim-lua/plenary.nvim"]
                       :event ["BufRead Cargo.toml"]
                       :lazy true
                       :config #(setup :crates)}

  :qnighy/lalrpop.vim {}
  :edwinb/idris2-vim {:ft ["idris2"]}
  :vmchale/ats-vim {:ft ["ats" "dats" "sats"]}
  :bakpakin/fennel.vim {:ft ["fennel"]}
  :evanleck/vim-svelte {})


; >>>

;(require "packer_compiled")

; vim:foldmarker=<<<,>>>


