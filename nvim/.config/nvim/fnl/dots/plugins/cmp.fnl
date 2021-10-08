(module dots.plugins.cmp
  {autoload {a aniseed.core
             cmp cmp}})


(cmp.setup
  {:mapping {:<C-d> (cmp.mapping.scroll_docs -4)
             :<C-f> (cmp.mapping.scroll_docs 4)
             :<C-space> (cmp.mapping.complete)
             :<esc> #(do (cmp.mapping.close) (vim.cmd "stopinsert"))
             :<CR>  (cmp.mapping.confirm {:select true})}
   :sources [{:name "nvim_lsp"}
             {:name "buffer"}]})
