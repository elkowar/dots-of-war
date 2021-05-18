(module dots.smart-compe-conjure
  {autoload {utils dots.utils
             a aniseed.core
             str aniseed.string
             view aniseed.view
             popup popup
             compe compe
             help dots.help-thingy}
   require-macros [macros]})


(def fuck (require "compe_conjure"))


(def my_source {})
(set my_source.new
  (fn [] 
    (setmetatable {} {:__index my_source})))

(set my_source.determine fuck.determine)
(set my_source.get_metadata fuck.get_metadata)
(set my_source.complete fuck.complete)
(set my_source.abort fuck.abort)
(set my_source.documentation 
  (fn [self args]
    (a.println (view.serialise args))
    (args.callback 
      (let [help-tag (help.find-help-tag-for args.completed_item.word)]
        (when help-tag 
          (var lines ["```help"])
          (each [_ line (ipairs (help.help-for-tag help-tag))]
            (table.insert lines line))
          (table.insert lines "```")
          lines)))))

(compe.register_source :epic (my_source.new))


(compe.setup 
 {:enabled true
  :autocomplete false
  :debug false 
  :min_length 1 
  :preselect "enable" 
  :throttle_time 80 
  :source_timeout 200 
  :incomplete_delay 400 
  :max_abbr_width 100 
  :max_kind_width 100 
  :max_menu_width 100 
  :documentation true 
  :source {:path true
           :buffer true 
           :calc true 
           :nvim_lsp true 
           :nvim_lua true 
           :vsnip false
           :epic true}})



