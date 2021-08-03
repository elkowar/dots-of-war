(module dots.plugins.neogit
  {autoload {a aniseed.core
             neogit neogit}})

(neogit.setup
  {:integrations {:diffview true}})
