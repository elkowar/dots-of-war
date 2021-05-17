(module plugins.telescope
  {require {utils utils
            telescope telescope
            actions telescope.actions}})

(telescope.setup 
  {:defaults {:mappings {:i {:<esc> actions.close}}}})
                  
;(telescope.load_extension "dap")

(utils.keymap :n :<C-p> ":Telescope find_files<CR>")
