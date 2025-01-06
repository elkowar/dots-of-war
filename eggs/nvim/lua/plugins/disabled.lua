return {
  -- { "folke/trouble.nvim", enabled = false },
  -- { "folke/noice.nvim",                    enabled = false },
  -- { "MunifTanjim/nui.nvim",                enabled = false },
  -- { "rcarriga/nvim-notify",                enabled = false },

  {
    "sphamba/smear-cursor.nvim",
    opts = {
      smear_between_neighbor_lines = false,
    },
    enabled = false,
  },

  { "folke/tokyonight.nvim",               enabled = false },
  --{ "nvimdev/dashboard-nvim",              enabled = false },
  { "lucas-reineke/indent-blankline.nvim", enabled = false },
  { "folke/flash.nvim",                    enabled = false },
  { "folke/todo-comments.nvim",            enabled = false },
  { "nvim-neo-tree/neo-tree.nvim",         enabled = false },
  { "folke/persistence.nvim",              enabled = false },
  { "rafamadriz/friendly-snippets",        enabled = false },
  { "garymjr/nvim-snippets",               enabled = false },
  { "akinsho/bufferline.nvim",             enabled = false },
  -- html
  { "windwp/nvim-ts-autotag",              enabled = false },
  -- ??
  { "Bilal2453/luvit-meta",                enabled = false },

  -- { "echasnovski/mini.ai",                 enabled = false }, -- a / i text objects like a( a) a'...
  -- { "echasnovski/mini.icons",              enabled = false },
  { "echasnovski/mini.pairs",              enabled = false }, -- [({})] kind of thing
  -- { "stevearc/dressing.nvim",              enabled = false }, -- used tor lsp popups and pickers
  { "stevearc/conform.nvim",               enabled = false }, -- formatter
  -- { "MagicDuck/grug-far.nvim",             enabled = false }, -- find and replace
  -- Limit to one notification https://github.com/rcarriga/nvim-notify/issues/120#issuecomment-1214168883
  -- Change styles
  -- Make buffer not selectable with C-W

  -- TODO: use (or take as inspiration) 'diagflow' for aligned and improved diagnostics
}
