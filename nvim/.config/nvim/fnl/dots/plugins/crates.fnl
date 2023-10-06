(module dots.plugins.crates
  {autoload {a aniseed.core
             crates crates}})


(crates.setup {:disable_invalid_feature_diagnostic true
               :enable_update_available_warning false})
