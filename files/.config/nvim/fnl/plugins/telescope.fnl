(module plugins.telescope
  {require {utils utils
            telescope telescope
            actions telescope.actions}})

(telescope.setup {})

(utils.keymap :n :<C-p> ":Telescope find_files<CR>")
