(local utils (require :dots.utils))

[(utils.plugin
   :folke/todo-comments.nvim
   {:lazy true
    :event "VeryLazy"
    :opts {:keywords {:TODO {:icon " "}
                      :WARN {:icon " " :alt [:WARNING :XXX :!!!]}
                      :NOTE {:icon " " :alt [:INFO]} 
                      :FIX  {:icon " " :alt [:FIXME :BUG :FIXIT :ISSUE :PHIX]} 
                      :PERF {:icon " " :alt [:OPTIM :PERFORMANCE :OPTIMIZE]}
                      :HACK {:icon " "}}}})]
