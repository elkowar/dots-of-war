(import-macros {: al} :macros)
(al utils dots.utils)
(al telescope telescope)
(al actions telescope.actions)
(al colors dots.colors)

(fn setup []
  (telescope.setup 
    {:defaults {:mappings {:i {:<esc> actions.close}}
                :file_ignore_patterns ["Cargo.lock" ".*.snap" "docs/theme/.*" "node%_modules/.*" "target/.*"]}
     :extensions {:ui-select [((. (require "telescope.themes") :get_dropdown))]}})
                    
  (telescope.load_extension "dap")
  ;(telescope.load_extension "ui-select")

  (utils.keymap :n :<C-p> ":Telescope find_files<CR>"))

[(utils.plugin :nvim-telescope/telescope.nvim
               {:config setup
                :cmd ["Telescope"]
                :dependencies [:nvim-lua/popup.nvim
                               :nvim-lua/plenary.nvim]})]

