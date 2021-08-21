(module dots.plugins.persistence
  {autoload {persistence persistence}})

(persistence.setup
  {:dir (vim.fn.expand (.. (vim.fn.stdpath "cache") "/sessions/"))})
