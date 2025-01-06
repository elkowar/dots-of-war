-- Options are automatically loaded before lazy.nvim startup
vim.g.mapleader = " "                -- Set space as the leader key
vim.g.maplocalleader = ","           -- Set comma as the local leader key
vim.g.netrw_banner = 0               -- Disable netrw banner
vim.g.markdown_recommended_style = 0 -- Fix vim ignores shoftabstop in markdown

local opt = vim.opt
opt.autowrite = true  -- Auto-save before certain actions
opt.exrc = true       -- Allow local .vimrc files in directories
opt.completeopt = ""  -- Disable built-in completion behavior
opt.conceallevel = 3  -- Hide markup characters in files like markdown
opt.confirm = true    -- Confirm to save changes before closing
opt.cursorline = true -- Highlight the current line
opt.expandtab = true  -- Convert tabs to spaces

-- As of nvim 0.9, gqq is broken. Use gww instead, or override:
-- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
-- (set by lazyvim)
--opt.formatexpr = ""

opt.formatoptions = "jcroqlnt" -- Set format options for comments and text wrapping
opt.grepformat = "%f:%l:%c:%m" -- Format for showing grep results
opt.grepprg = "rg --vimgrep"   -- Use ripgrep for searching
opt.ignorecase = true          -- Ignore case in search patterns
opt.inccommand = "nosplit"     -- Live preview of substitution changes
opt.laststatus = 0             -- Hide the status line initially
opt.mouse = "a"                -- Enable mouse support
opt.number = false             -- Show line numbers
opt.pumblend = 10              -- Set popup menu transparency
opt.pumheight = 10             -- Limit popup menu height
opt.relativenumber = false     -- Show relative line numbers
opt.scrolloff = 4              -- Minimal lines to keep above and below cursor
opt.sessionoptions = {         -- Session persistence settings
  "buffers",
  "curdir",
  "tabpages",
  "winsize"
}
opt.shiftround = true              -- Round indent to multiple of `shiftwidth`
opt.shiftwidth = 2                 -- Number of spaces to use for indentation
opt.shortmess:append({
  I = true,                        -- Suppress intro message
  W = true,                        -- Suppress "written" message when saving a file
  c = true                         -- Suppress completion messages
})
opt.showmode = false               -- Don't show mode in command line (like -- INSERT --)
opt.sidescrolloff = 8              -- Columns to keep left/right of the cursor during horizontal scroll
opt.smartcase = true               -- Override `ignorecase` if search contains uppercase letters
opt.smartindent = true             -- Smart auto-indentation
opt.spelllang = { "en" }           -- Set language for spell check to English
opt.splitbelow = true              -- Force all horizontal splits to go below current window
opt.splitright = true              -- Force all vertical splits to go to the right
opt.tabstop = 2                    -- Number of spaces tabs count for
opt.termguicolors = true           -- Enable 24-bit RGB colors in the terminal
opt.timeoutlen = 300               -- Time to wait for a mapped sequence to complete
opt.undofile = true                -- Enable persistent undo
opt.undolevels = 10000             -- Maximum number of undo levels
opt.updatetime = 200               -- Faster completion (default is 4000ms)
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5                -- Minimum window width
opt.wrap = false                   -- Don't wrap lines by default
opt.compatible = false             -- Disable 'compatible' mode to use modern features
opt.hidden = true                  -- Allow switching buffers without saving
opt.encoding = "utf-8"             -- Set file encoding to UTF-8
opt.autoindent = true              -- Copy indent from current line when starting a new line
opt.incsearch = true               -- Show search matches as you type
opt.ruler = false                  -- Don't show ruler (line and column info)
opt.switchbuf = "usetab"           -- Reuse existing tabs for switching buffers
opt.smarttab = true                -- Make tab behavior context-sensitive
opt.copyindent = true              -- Copy indent from previous line
opt.previewheight = 38             -- Set height for preview windows
opt.softtabstop = -1               -- Use `shiftwidth` for tab size in editing
opt.backspace = "indent,eol,start" -- Allow backspacing over everything in insert mode
opt.swapfile = false               -- Disable swap file creation
opt.foldcolumn = "0"               -- No fold column on the left
opt.signcolumn = "yes"             -- Always show the sign column
opt.laststatus = 3                 -- Global status line
opt.shell = "zsh"                  -- Set default shell to zsh
opt.cmdheight = 1                  -- Set height of command line to 1
opt.showcmd = false                -- Hide command in progress in command line
opt.cmdheight = 0                  -- Hide command line when not in use
opt.splitkeep = "screen"           -- Keep view stable when splitting
opt.statuscolumn = ""              -- Customize status column
opt.clipboard = ""                 -- Do not use system clipboard
