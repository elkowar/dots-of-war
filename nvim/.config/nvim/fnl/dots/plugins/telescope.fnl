(module dots.plugins.telescope
  {autoload {utils dots.utils
             telescope telescope
             actions telescope.actions}})

(telescope.setup 
  {:defaults {:mappings {:i {:<esc> actions.close}}
              :file_ignore_patterns ["Cargo.lock" ".*.snap" "docs/theme/.*" "node%_modules/.*" "target/.*"]}
   :extensions {:frecency {:persistent_filter false}}})
                  
(telescope.load_extension "frecency")
(telescope.load_extension "dap")
(telescope.load_extension "packer")

(utils.keymap :n :<C-p> ":Telescope find_files<CR>")
