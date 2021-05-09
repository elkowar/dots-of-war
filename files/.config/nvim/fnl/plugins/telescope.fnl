(module plugins.telescope
  {require {utils utils
            telescope telescope
            actions telescope.actions}})

(print "initializing telescope")

(telescope.setup {})

(utils.keymap :n :<C-p> ":Telescope find_files<CR>")
