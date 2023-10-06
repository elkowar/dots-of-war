(import-macros m :macros)
(m.al a nfnl.core)
(m.al utils dots.utils)
(m.al todo-comments todo-comments)


(fn setup []
  (todo-comments.setup  
    {:keywords {:TODO {:icon " "}
                :WARN {:icon " " :alt [:WARNING :XXX :!!!]}
                :NOTE {:icon " " :alt [:INFO]} 
                :FIX  {:icon " " :alt [:FIXME :BUG :FIXIT :ISSUE :PHIX]} 
                :PERF {:icon " " :alt [:OPTIM :PERFORMANCE :OPTIMIZE]}
                :HACK {:icon " "}}}))

[(utils.plugin
   :folke/todo-comments.nvim
   {:lazy true
    :event "VeryLazy"
    :config setup})]
