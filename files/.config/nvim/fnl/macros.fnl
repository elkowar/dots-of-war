{:augroup
  (fn [name ...]
    `(do
       (nvim.ex.augroup ,(tostring name))
       (nvim.ex.autocmd_)
       ,...
       (nvim.ex.augroup :END)))
 
  :autocmd
  (fn [...]
    `(nvim.ex.autocmd ,...))
 
  :_:
  (fn [name ...]
    `((. nvim.ex ,(tostring name)) ,...))
  
  :viml->fn
  (fn [name]
    `(.. "lua require('" *module-name* "')['" ,(tostring name) "']()"))
 
  :dbg
  (fn [x]
    `(let [view# (. (require "aniseed.fennel") :view)]
      (print (.. `,(tostring x) " => " (view# ,x)))
      ,x))
 
  :dbg-call
  (fn [x ...]
    `(do
      (a.println ,...)
      (,x ,...)))
 
  :pkg
  (fn [name mappings ...]
    `(if (~= nil (. packer_plugins `,(tostring name)))
        (let ,mappings ,...)
        (print (.. "plugin disabled " `,(tostring name)))))
 
  :vim-let
  (fn [field value]
    (let [text (.. "let " `,(tostring field) "=\"" value "\"")]
     `(vim.cmd ,text)))
 
  :each-pair
  (fn [args ...]
    (let [[l# r# d#] args]
      `(let [data# ,d#]
        (for [i# 1 (a.count data#) 2]
          (let [,l# (. data# i#)
                ,r# (. data# (+ i# 1))]
            ,...)))))
 
  :use-macro
  (fn [...]
    (let [a (require "aniseed.core")
          fennel (require "aniseed.fennel")
          args [...]
          use-statements []]
      (for [i 1 (a.count args) 2]
        (let [name (. args i)
              block (. args (+ i 1))]
          (a.assoc block 1 name)
          (when (. block :mod)
            (a.assoc block :config `#((. (require "utils") :safe-require) ,(. block :mod))))
          (a.assoc block :mod nil)
          (table.insert use-statements block)))
  
      (let [use-sym (gensym)]
        `(let [packer# (require "packer")]
           (packer#.startup
             (fn [,use-sym]
               ,(unpack
                 (icollect [_# v# (ipairs use-statements)]
                  `(,use-sym ,v#)))))))))


  :se
  (fn [name value]
    (let [str-name (tostring name)
          (info-ok scope) (pcall #(. (vim.api.nvim_get_option_info str-name) :scope))]
      (if info-ok
        (match scope
          :global `(tset vim.o ,str-name ,value)
          :win `(tset vim.wo ,str-name ,value)
          :buf `(tset vim.bo ,str-name ,value)
          _ (print (.. "option " str-name " has unhandled scope " scope)))
        (print (.. "Unknown vim-option: " str-name)))))}
