;; [nfnl-macro]

{:augroup
  (fn [name ...]
    `(do
       (nvim.ex.augroup ,(tostring name))
       (nvim.ex.autocmd_)
       ,...
       (nvim.ex.augroup :END)))

  :al
  (fn [name thing]
    `(local ,name ((. (require :nfnl.module) :autoload) ,(tostring thing))))


  :defer
  (fn [...]
    `(let [utils# (require :dots.utils)]
       (utils#.defer-to-end (fn [] ,...))))
     
  
  :req
  (fn [name ...]
    (let [str  (require :nfnl.string) 
          a    (require :nfnl.core)
          segs (str.split (tostring name) "%.")
          mod  (str.join "." (a.butlast segs))
          func (a.last segs)]
      `((. (require (tostring ,mod)) (tostring ,func)) ,...)))
 
  :autocmd
  (fn [...]
    `(nvim.ex.autocmd ,...))
 
  :_:
  (fn [name ...]
    `((. nvim.ex ,(tostring name)) ,...))
  
  :viml->fn
  (fn [name]
    `(.. "lua require('" *module-name* "')['" ,(tostring name) "']()"))
 
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
      `(let [a# (require "nfnl.core")
             data# ,d#]
        (for [i# 1 (a#.count data#) 2]
          (let [,l# (. data# i#)
                ,r# (. data# (+ i# 1))]
            ,...)))))

  :packer-use
  (fn [...]
    (let [a (require "nfnl.core")
          args [...]
          use-statements []]
      (for [i 1 (a.count args) 2]
        (let [name (. args i)
              block (. args (+ i 1))]
          (a.assoc block 1 name)
          (when (. block :mod)
            ;(a.assoc block :config `#((. (require "utils") :safe-require) ,(. block :mod)))
            (a.assoc block :config `#(
                                      ;do
                                        ;(print ,(. block :mod))
                                        ;(time
                                          ;(
                                           require ,(. block :mod))))
          (a.assoc block :mod)
          (table.insert use-statements block)))
  
      (let [use-sym (gensym)]
        `(let [packer# (require "packer")]
           (packer#.startup
             (fn [,use-sym]
               ,(unpack
                 (icollect [_# v# (ipairs use-statements)]
                  `(,use-sym ,v#)))))))))}



