(import-macros m :macros)
(m.al neogit neogit)
(m.al utils dots.utils)

[(utils.plugin :TimUntersberger/neogit
               {:config #(neogit.setup {:integrations {:diffview true}})
                :cmd ["Neogit"]})]


