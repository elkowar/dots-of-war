(module dots.plugins.cmp
  {autoload {a aniseed.core
             cmp cmp}})

(cmp.setup
  {:snippet {:expand (fn [args]
                       ((. vim.fn :vsnip#anonymous) args.body))}
   :mapping {:<C-d> (cmp.mapping.scroll_docs -4)
             :<C-f> (cmp.mapping.scroll_docs 4)
             :<C-space> (cmp.mapping.complete)
             :<esc> #(do (cmp.mapping.close) (vim.cmd "stopinsert"))
             :<CR>  (cmp.mapping.confirm {:select true})}
   :sources [{:name "nvim_lsp" 
              :priority 5}
             {:name "vsnip"
              :priority 3}]
             ;{:name "buffer"}]
   :sorting {:comparators [#(do 
                              ;(print ($1:get_kind) $1.completion_item.label "--" ($2:get_kind) $2.completion_item.label) 
                              (if (= 15 ($1:get_kind)) false nil)) ; 15 means "SNIPPET", see https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/lsp.lua
                           cmp.config.compare.offset
                           cmp.config.compare.exact
                           cmp.config.compare.score
                           cmp.config.compare.kind
                           cmp.config.compare.sort_text
                           cmp.config.compare.length
                           cmp.config.compare.order]}})
                           
