(import-macros m :macros)
(m.al utils dots.utils)

(fn setup []
  (set vim.g.vimtex_view_method "general")
  (set vim.g.vimtex_view_general_viewer "zathura")
  (set vim.g.vimtex_view_general_options "--synctex-forward @line:1:@tex @pdf")
  ;(set vim.g.vimtex_view_general_options "--unique file:@pdf#src:@line@tex")
  (set vim.g.vimtex_quickfix_method "pplatex")
  (set vim.g.vimtex_quickfix_mode 2)
  (set vim.g.vimtex_quickfix_open_on_warning 0)

  (set vim.g.vimtex_compiler_latexmk {:build_dir ""
                                      :callback 1
                                      :continuous 1
                                      :executable "latexmk"
                                      :hooks []
                                      :options ["-verbose"
                                                "-file-line-error"
                                                "-synctex=1"
                                                "-interaction=nonstopmode"
                                                "-shell-escape"]})

  (set vim.g.vimtex_syntax_custom_cmds
       [{:name "scripture" :argstyle "ital"}])
  (set vim.g.vimtex_syntax_conceal {:accents 1
                                    :cites 1
                                    :fancy 1
                                    :greek 1
                                    :math_bounds 1
                                    :math_delimiters 1
                                    :math_fracs 1
                                    :math_super_sub 1
                                    :math_symbols 1
                                    :sections 0
                                    :styles 0}))
                                  


[(utils.plugin
   :lervag/vimtex
   {:ft ["latex" "tex"]
    :config setup})]
