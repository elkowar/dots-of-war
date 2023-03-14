(module dots.plugins.telescope
  {autoload {utils dots.utils
             telescope telescope
             actions telescope.actions
             colors dots.colors}})

(telescope.setup 
  {:defaults {:mappings {:i {:<esc> actions.close}}
              :file_ignore_patterns ["Cargo.lock" ".*.snap" "docs/theme/.*" "node%_modules/.*" "target/.*"]}
   :extensions {:ui-select [((. (require "telescope.themes") :get_dropdown))]}})
                  
(telescope.load_extension "dap")
;(telescope.load_extension "ui-select")

(utils.keymap :n :<C-p> ":Telescope find_files<CR>")

