(module plugins.detect-indent)

(vim.cmd "autocmd! BufReadPost * :DetectIndent")
(set vim.g.detectindent_preferred_expandtab 1)
(set vim.g.detectindent_preferred_indent 2)

