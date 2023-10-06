(import-macros m :macros)
(m.al a aniseed.core)
(m.al glance glance)
(m.al utils dots.utils)

[(utils.plugin
   :dnlhc/glance.nvim
   {:lazy true :config #(glance.setup)})]
