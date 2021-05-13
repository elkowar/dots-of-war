(module plugins.diffview
  {autoload {diffview diffview
             cb diffview.config}})

(diffview.setup
 {:diff_binaries false
  :file_panel {:width 35 
               :use_icons false}
  :key_bindings {:view {:<leader>dn (cb.diffview_callback "select_next_entry")
                        :<leader>dp (cb.diffview_callback "select_prev_entry")
                        :<leader>dd (cb.diffview_callback "toggle_files")}}})
