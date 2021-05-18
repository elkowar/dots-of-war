(module dots.plugins.compe
  {autoload {utils dots.utils
             compe compe}})
            

(utils.keymap :i :<C-Space> "compe#complete()" {:expr true})
(utils.keymap :i :kj "compe#close('<esc>')" {:expr true})
;(utils.keymap :i :<esc> "compe#close('<esc>')" {:expr true})


(defn result-formatter [items]
  (var max-width 0)
  (each [_ item (ipairs items)]
    (set item.abbr (-> item.abbr
                       (string.gsub "~$" "")
                       (string.gsub " %(.*%)$" "")))
    (set max-width (math.max max-width (vim.fn.strwidth item.abbr))))
  (each [_ item (ipairs items)]
    (let [padding (string.rep " " (- max-width (vim.fn.strwidth item.abbr)))
          details (?. item :user_data :compe :completion_item :detail)]
      (when details
        (set item.abbr (.. item.abbr padding " " details)))))
  items)

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
  :formatting_functions {:nvim_lsp {:results result-formatter}}
  :source {:path true
           :buffer true 
           :calc true 
           :nvim_lsp true 
           :nvim_lua true
           :emoji false
           :vsnip false
           :conjure true}})

