(local {: autoload : utils} (require :dots.prelude))
(local colorizer (autoload :colorizer))

[(utils.plugin
   :norcalli/nvim-colorizer.lua
   {:event "VeryLazy"
    :lazy true
    :config #(colorizer.setup
               ["*"]
               {:RGB true
                :RRGGBB true
                :names true
                :RRGGBBAA true
                :rgb_fn true
                :hsl_fn true
                :mode "background"})})]
