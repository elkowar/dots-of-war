(module init 
  {require {a aniseed.core
            fennel aniseed.fennel 
            nvim aniseed.nvim 
            kb keybinds 
            utils utils}
    require-macros [macros]})

(require "plugins.telescope")
(require "plugins.lsp")
(require "plugins.galaxyline")
(require "plugins.bufferline")

;(set nvim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")



; " :: and _ as space ------------------------------------------------------------------- {{{
(var remapped-space nil)
(fn _G.RebindShit [newKey]
  (set remapped-space {:old (vim.fn.maparg :<Space> :i)
                       :cur newKey})
  (utils.keymap :i :<Space> newKey {:buffer true}))

(fn _G.UnbindSpaceStuff []
  (if (and remapped-space (~= remapped-space {}))
    (do 
      (utils.del-keymap :i :<Space> true)
      (if (~= remapped-space.old "")
        (utils.keymap :i :<Space> remapped-space.old {:buffer true}))
      (set remapped-space nil))))
 




(nvim.command "autocmd! InsertLeave * :call v:lua.UnbindSpaceStuff()")
(utils.keymap :n "<Tab>j" ":call v:lua.RebindShit('_')<CR>")
(utils.keymap :n "<Tab>k" ":call v:lua.RebindShit('::')<CR>")
(utils.keymap :i "<Tab>j" "<space><C-o>:call v:lua.RebindShit('_')<CR>")
(utils.keymap :i "<Tab>k" "<space><C-o>:call v:lua.RebindShit('::')<CR>")
(utils.keymap :n "ö" "a")

; }}}
