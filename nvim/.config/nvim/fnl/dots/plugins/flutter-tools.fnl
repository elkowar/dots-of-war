(local {: autoload : utils} (require :dots.prelude))
; (local flutter-tools (autoload :flutter-tools)))
[(utils.plugin :akinsho/flutter-tools.nvim
               {:config true
                :lazy false
                :dependencies ["nvim-lua/plenary.nvim" "stevearc/dressing.nvim"]})]
                
