(module plugins.telescope
  {require {a aniseed.core
            fennel aniseed.fennel 
            nvim aniseed.nvim 
            utils utils
            
            telescope telescope
            actions telescope.actions}})

(telescope.setup 
  {:defaults
    {:i { "<esc>" actions.close}}})

(telescope.load_extension "media_files")
             
(utils.keymap :n :<C-p> ":Telescope find_files<CR>")
