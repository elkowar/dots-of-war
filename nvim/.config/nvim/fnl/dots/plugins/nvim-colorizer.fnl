(import-macros m :macros)
(m.al colorizer colorizer)
(m.al utils dots.utils)


(fn setup []
  ; this really shouldn't be necessary,.. but it is
  (set vim.o.termguicolors true)

  (colorizer.setup
    ["*"]
    {:RGB true
     :RRGGBB true
     :names true
     :RRGGBBAA true
     :rgb_fn true
     :hsl_fn true
     :mode "background"}))

[(utils.plugin :norcalli/nvim-colorizer.lua
               {:event "VeryLazy"
                :lazy true
                :config setup})]
