(import-macros m :macros)
(m.al persistence persistence)
(m.al utils dots.utils)


(fn setup []
  (persistence.setup
    {:dir (vim.fn.expand (.. (vim.fn.stdpath "cache") "/sessions/"))}))

[(utils.plugin :folke/persistence.nvim
         {:config setup})]
