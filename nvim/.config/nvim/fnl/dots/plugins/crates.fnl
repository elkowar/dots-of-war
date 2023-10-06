(import-macros {: al} :macros)

(al utils dots.utils)
(al crates crates)

(fn setup []
  (crates.setup {:disable_invalid_feature_diagnostic true
                 :enable_update_available_warning false}))
  


[(utils.plugin :Saecki/crates.nvim
               {:dependencies ["nvim-lua/plenary.nvim"]
                :dir "/Users/leon/tmp/crates.nvim"
                :event ["BufRead Cargo.toml"]
                :lazy true
                :config setup})]
                                        
