(module plugins.telescope
  {require {utils utils
            telescope telescope
            actions telescope.actions}})

(telescope.setup
  {:defaults
   {:i { "<esc>" actions.close}}})

(telescope.load_extension "media_files")
             
(utils.keymap :n :<C-p> ":Telescope find_files<CR>")
