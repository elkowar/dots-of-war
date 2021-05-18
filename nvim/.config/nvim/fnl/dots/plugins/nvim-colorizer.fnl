(module dots.plugins.nvim-colorizer
  {autoload {colorizer colorizer}})


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
   :mode "background"})
