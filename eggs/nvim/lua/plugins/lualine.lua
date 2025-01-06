return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- needed to not override lazyvim's options for the sections
      local opts = vim.tbl_deep_extend("force", opts, {
        options = {
          component_separators = { left = "│", right = "│" },
          section_separators = { left = " ", right = " " },
        },
        sections = {
          lualine_y = {
            { "location", padding = { left = 0, right = 1 } }
          },
          lualine_z = {},
        },
        tabline = {
          lualine_b = {
            {
              "buffers",
              mode = 2,
              max_length = 999999,
              use_mode_colors = true,
              padding = { left = 1, right = 1 }
            }
          },
        }
      })

      return opts
    end
  }
}
