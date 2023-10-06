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

 
  :autocmd
  (fn [...]
    `(nvim.ex.autocmd ,...))
 
  :_:
  (fn [name ...]
    `((. nvim.ex ,(tostring name)) ,...))
  
  :viml->fn
  (fn [name]
    `(.. "lua require('" *module-name* "')['" ,(tostring name) "']()"))
 
 
  :each-pair
  (fn [args ...]
    (let [[l# r# d#] args]
      `(let [a# (require "nfnl.core")
             data# ,d#]
        (for [i# 1 (a#.count data#) 2]
          (let [,l# (. data# i#)
                ,r# (. data# (+ i# 1))]
            ,...)))))}




