(module dots.plugins.coq-nvim
  {autoload {utils dots.utils
             coq coq}})

(set vim.g.coq_settings {:limits.completion_auto_timeout 1})

(vim.cmd "autocmd! InsertEnter * COQnow --shut-up")
