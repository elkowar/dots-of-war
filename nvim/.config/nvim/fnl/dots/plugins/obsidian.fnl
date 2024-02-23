(local {: autoload : utils} (require :dots.prelude))

(local vault-path (.. (vim.fn.expand "~") "/Documents/obsidian-vault"))

[(utils.plugin :epwalsh/obsidian.nvim
               {:lazy true
                :version "*"
                :ft "markdown"
                :event [(.. "BufReadPre " vault-path "/**.md")
                        (.. "BufNewFile " vault-path "/**.md")]
                :dependencies ["nvim-lua/plenary.nvim"]
                :opts {:workspaces [{:name "Vault"
                                     :path vault-path}]
                       :completion {:nvim_cmp true}}})]
                                    
