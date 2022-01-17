(module dots.plugins.vimtex)


;(set vim.g.vimtex_quickfix_enabled 0)

(set vim.g.vimtex_view_method "general")
(set vim.g.vimtex_view_general_viewer "okular")
(set vim.g.vimtex_view_general_options "--unique file:@pdf#src:@line@tex")

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
                                  :styles 0})
                                  
