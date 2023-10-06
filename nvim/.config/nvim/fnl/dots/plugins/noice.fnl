(import-macros m :macros)
(m.al utils dots.utils)

(fn setup []
  (m.al a nfnl.core)
  (m.al lazy lazy)
  (m.al noice noice)
  (m.al colors dots.colors)
  (noice.setup 
    {:presets {:inc_rename true
               :long_message_to_split true
               :bottom_search true}
               ;:command_palette true}
     :lsp {:override {:vim.lsp.util.convert_input_to_markdown_lines true
                      :vim.lsp.util.stylize_markdown true
                      :cmp.entry.get_documentation true}}
     :views {:cmdline_popup {:border {:style "none" :padding [1 1]}
                             :position {:row 5 :col "50%"}
                             :size {:width 60 :height "auto"}}
             :popupmenu {:relative "editor"
                         :border {:style "none" :padding [1 1]}
                         :position {:row 8 :col "50%"}
                         :size {:width 60 :height 10}}
             :mini      {:max_height 5}}
     :cmdline {:view "cmdline" ; change to cmdline_popup
               :format {:cmdline {:icon ":"}
                        :lua false
                        :help false}}
     :messages {:view "mini"
                :view_error "cmdline_output"
                :view_warn "mini"
                :view_search "virtualtext"}
     :markdown {:hover {"|(%S-)|" vim.cmd.help}}
     :routes [{:view "notify" :filter {:event "msg_showmode"}}
              {:view "mini"
               :filter {:error true :max_height 5}}
              {:view "cmdline_output"
               :filter {:error true :min_height 6}}]}))

;[(utils.plugin :folke/noice.nvim
;               {:config setup
;                :dependencies [:MunifTanjim/nui.nvim]}}]}))
[]
