-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- TODO: these come from my old fennel config. I should definitely give them a second look
-- Disable command history
-- vim.keymap.set("n", "q:", ":q")  -- creates a "wait time" if we plan to use q as quit
-- Remap q (record macro) to Q


local map = vim.keymap.set

map("n", "q", "<Nop>")
map("n", "Q", "q")
map("n", "<S-K>", "<Nop>")

-- Helper function for which-key commands
local function cmd_string(s)
  return "<cmd>" .. s .. "<cr>"
end



-- Buffer navigation
map("n", "<leader>h", cmd_string("bprevious"), { desc = "Previous buffer" })
map("n", "<leader>l", cmd_string("bnext"), { desc = "Next buffer" })
map("n", "<C-h>", cmd_string("bprevious"), { desc = "Previous buffer" })
map("n", "<C-l>", cmd_string("bnext"), { desc = "Next buffer" })
map("i", "<C-h>", cmd_string("bprevious"), { desc = "Previous buffer" })
map("i", "<C-l>", cmd_string("bnext"), { desc = "Next buffer" })
map("v", "<C-h>", cmd_string("bprevious"), { desc = "Previous buffer" })
map("v", "<C-l>", cmd_string("bnext"), { desc = "Next buffer" })
map("n", "<C-x>", cmd_string("bdelete"), { desc = "Close buffer" })

-- Buffer management
map("n", "<leader>bc", cmd_string("bdelete!"), { desc = "Close buffer" })
map("n", "<leader>bw", cmd_string("bwipeout!"), { desc = "Wipeout buffer" })

-- Close floating windows
local function close_floating()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

-- Use q and <esc> to close floating windows and clear search
-- Already handled by LazyVim
--map("n", "<esc>", function()
--  close_floating()
--  vim.cmd("nohlsearch")
--end)
--
--map("n", "q", function()
--  close_floating()
--  vim.cmd("nohlsearch")
--end)

-- Exit visual mode without relying on <esc>
local function exit_visual_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "x", false)
end

-- Use q and <esc> to close floating windows and clear search in visual mode
map("v", "<esc>", function()
  close_floating()
  vim.cmd("nohlsearch")
  exit_visual_mode()
end)

map("v", "q", function()
  close_floating()
  vim.cmd("nohlsearch")
  exit_visual_mode()
end)

-- Move up/down in menus with C-j and C-k
map({ "i", "n", "c" }, "<C-j>", "<C-n>", { desc = "Move down" })
map({ "i", "n", "c" }, "<C-k>", "<C-p>", { desc = "Move up" })

-- Better indenting
map("v", "<", "<gv", { desc = "Reduce indent" })
map("v", ">", ">gv", { desc = "Increase indent" })

-- Indenting in insert mode
map("i", "<S-tab>", "<C-D>", { desc = "Decrease indent" })

-- handled by mini.move
map("v", "<tab>", ">gv", { desc = "Increase indent" })
map("v", "<S-tab>", "<gv", { desc = "Reduce indent" })

-- Clipboard operations
-- TODO: remap these
-- map("n", "<leader>y", ""+y", { desc = "Copy (system)" })
-- map("v", "<leader>y", ""+y", { desc = "Copy (system)" })
-- map("n", "<leader>p", ""+p", { desc = "Paste (system)" })
-- map("v", "<leader>p", ""+p", { desc = "Paste (system)" })

-- Copy-paste with Ctrl-C and Ctrl-V
-- map("v", "<C-c>", ""+y", { desc = "Copy to system clipboard" }) -- BUG: C-c and esc are the same key
-- map("n", "<C-v>", ""+p", { desc = "Paste from system clipboard" }) -- TODO: Can"t use due to visual block issues

map("i", "<C-v>", "<C-o>'+p", { desc = "Paste from system clipboard" })
map("v", "<C-v>", "'+p", { desc = "Paste from system clipboard" })

-- Unmap default keybinds related to code (lsp)
vim.keymap.del("n", "<leader>cd")
vim.keymap.del("n", "<leader>cf")
vim.keymap.del("n", "<leader>cm")
vim.keymap.del("n", "<leader>cs")
vim.keymap.del("n", "<leader>cS")

-- Unmap saving
vim.keymap.del("n", "<C-s>")
vim.keymap.del("i", "<C-s>")
vim.keymap.del("v", "<C-s>")




-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>gd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })


map("n", "<leader>C",
  function()
    local result = vim.treesitter.get_captures_at_cursor(0)
    print(vim.inspect(result))
  end,
  { noremap = true, silent = false, desc = "Get highlight group under cursor" }
)


-- Fix for Telescope"s race condition with default C-F
map("n", "<C-F>", LazyVim.pick("files"), { noremap = true, silent = false })
