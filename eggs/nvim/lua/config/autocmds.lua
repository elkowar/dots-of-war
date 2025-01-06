-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- pre-defined autocmds are:
-- 1. Automatically reload the file when it changes (triggered on certain events like focus gain).
-- 2. Highlights text when yanked (copied).
-- 3. Resizes all window splits if the Vim window is resized.
-- 4. Automatically returns to the last cursor location when reopening a buffer, except for certain file types (e.g., gitcommit).
-- 5. Binds <q> to close certain filetypes (like help, LSP info, and test panels) for easier quitting.
-- 6. Man files opened inline are set as unlisted to prevent clutter in buffer lists.
-- 7. Enables word wrap and spell checking for text-related filetypes (markdown, gitcommit, etc.).
-- 8. Disables JSON file concealment for better readability.
-- 9. Automatically creates missing directories when saving a file, ensuring that any intermediate directories are created if needed.
-- 10. Adds custom filetype detection logic to handle large files ("bigfile"), disables certain animations, and adjusts syntax highlighting to improve performance.


local function augroup(name)
  return vim.api.nvim_create_augroup("drusk_" .. name, { clear = true })
end

-- Enable wrap and spell check for gitcommit and markdown filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Disable line numbers and enter insert mode when opening a terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("term_open"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})

-- Set filetype to "helm" for specific YAML template and helm-related files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*/templates/*.yaml", "*/templates/*.tpl", "*.gotmpl", "helmfile*.yaml" },
  callback = function()
    vim.opt_local.filetype = "helm"
  end,
})
