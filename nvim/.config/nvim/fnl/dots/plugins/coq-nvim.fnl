(module dots.plugins.coq-nvim
  {autoload {utils dots.utils
             coq coq}})

(set vim.g.coq_settings {:limits.completion_auto_timeout 1
                         :clients.lsp.weight_adjust 2
                         :clients.tree_sitter.enabled false
                         :display.icons.mode "short"})
                         

(vim.cmd "autocmd! InsertEnter * COQnow --shut-up")
