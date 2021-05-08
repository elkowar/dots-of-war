(module init 
  {autoload {utils utils
             nvim aniseed.nvim
             a aniseed.core
             fennel aniseed.fennel
             colors colors}
   require-macros [macros]})

(macro make-errors-epic [f]
  `(xpcall #,f #(a.println (fennel.traceback $1))))

(make-errors-epic (require "plugins"))

(make-errors-epic (require "plugins.lsp"))
(make-errors-epic (require "keybinds"))


(set vim.g.conjure#client#fennel#aniseed#aniseed_module_prefix "aniseed.")

; Colors  ------------------------------------------------------- foldstart

(utils.highlight-add 
 ["GruvboxBlueSign" "GruvboxAquaSign" "GruvboxRedSign" "GruvboxYellowSign" "GruvboxGreenSign" "GruvboxOrangeSign" "GruvboxPurpleSign"] 
 {:bg "NONE"})



; foldend 


;(nvim-biscuits.setup {}
  ;{ :on_events ["InsertLeave" "CursorHoldI"]})

; :: and _ as space ------------------------------------------------------------------- foldstart
(var remapped-space nil)
(fn _G.RebindShit [newKey]
  (set remapped-space {:old (vim.fn.maparg :<Space> :i)
                       :cur newKey})
  (utils.keymap :i :<Space> newKey {:buffer true}))

(fn _G.UnbindSpaceStuff []
  (when (and remapped-space (~= remapped-space {}))
   (utils.del-keymap :i :<Space> true)
   (when (~= remapped-space.old "")
    (utils.keymap :i :<Space> remapped-space.old {:buffer true}))
   (set remapped-space nil)))
 


(nvim.command "autocmd! InsertLeave * :call v:lua.UnbindSpaceStuff()")
(utils.keymap :n "<Tab>j" ":call v:lua.RebindShit('_')<CR>")
(utils.keymap :n "<Tab>k" ":call v:lua.RebindShit('::')<CR>")
(utils.keymap :i "<Tab>j" "<space><C-o>:call v:lua.RebindShit('_')<CR>")
(utils.keymap :i "<Tab>k" "<space><C-o>:call v:lua.RebindShit('::')<CR>")
(utils.keymap :n "ö" "a")

; foldend


 ; vim:foldmarker=foldstart,foldend
