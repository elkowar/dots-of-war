return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      no_italic = true,
      no_bold = true,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>o", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>p", LazyVim.pick("files"),     desc = "Find Files (Root Dir)" },
      { "<leader>:", LazyVim.pick("commands"),  desc = "Commands" },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")
      opts.defaults.mappings = {
        i = {
          ["<C-n>"] = actions.move_selection_next,
          ["<C-p>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.close,
          ["<esc>"] = actions.close,
        },
        n = {
          ["q"] = actions.close,
          ["o"] = actions.close,
        },
      }
    end,
  },
}
