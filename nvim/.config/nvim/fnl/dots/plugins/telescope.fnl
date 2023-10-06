(local {: autoload} (require :nfnl.module))
(local utils (autoload :dots.utils))
(local telescope (autoload :telescope))
(local actions (autoload :telescope.actions))

(fn setup []
  (telescope.setup 
    {:defaults {:mappings {:i {:<esc> actions.close}}
                :file_ignore_patterns ["Cargo.lock" ".*.snap" "docs/theme/.*" "node%_modules/.*" "target/.*"]}
     :extensions {:ui-select [((. (require "telescope.themes") :get_dropdown))]}})
                    
  (telescope.load_extension "dap")

  (utils.keymap :n :<C-p> ":Telescope find_files<CR>"))

[(utils.plugin :nvim-telescope/telescope.nvim
               {:config setup
                :cmd ["Telescope"]
                :dependencies [:nvim-lua/popup.nvim
                               :nvim-lua/plenary.nvim]})]

