return {
  {
    "echasnovski/mini.icons",
    opts = {
      filetype = {
        -- replace some icons that render too big
        sh = { glyph = "" },
        yaml = { glyph = "" },
      }
    },
  },
  {
    "zenbones-theme/zenbones.nvim",
    -- I dont want lush
    --dependencies = "rktjmp/lush.nvim",
    priority = 1000,
    lazy = true,
    config = function()
      vim.g.zenbones_compat = 1 -- needed if lush is disabled
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts_extend = { "custom_highlights" },
    priority = 1000,
    opts = {
      color_overrides = {
        mocha = {
          rosewater = "#d4be98", -- Gruvbox light beige
          flamingo = "#ea6962",  -- Gruvbox light red
          pink = "#d3869b",      -- Gruvbox purple ( a bit darker than regular)
          mauve = "#d3869b",     -- Gruvbox purple (reused as there's no direct equivalent)
          red = "#ea6962",       -- Gruvbox red
          maroon = "#d75f5f",    -- Gruvbox dark red
          peach = "#e78a4e",     -- Gruvbox orange
          yellow = "#d8a657",    -- Gruvbox yellow
          green = "#a9b665",     -- Gruvbox green
          teal = "#89b482",      -- Gruvbox aqua
          sky = "#89b482",       -- Gruvbox aqua (reused as there's no direct equivalent)
          sapphire = "#7daea3",  -- Gruvbox blue-green
          blue = "#7daea3",      -- Gruvbox blue
          lavender = "#89b482",  -- Gruvbox aqua (reused as there's no direct equivalent)

          -- Harder background
          --text = "#fbf1c7",     -- fg
          --subtext1 = "#ebdbb2", -- primary text
          --subtext0 = "#d5c4a1", -- punctuation
          --overlay2q;q = "#c6b697", -- doc comments
          --overlay1 = "#a89984", -- comments
          --overlay0 = "#928474", -- invisibles
          --surface2 = "#504945", -- darker grey
          --surface1 = "#3c3836", -- dark grey
          --surface0 = "#32302f", -- slightly lighter than bg
          --base = "#1d2021",     -- bg
          --mantle = "#1d2021",   -- same as bg
          --crust = "#1b1b1b",    -- slightly darker than bg

          --text = "#d9c9a5",     -- Gruvbox fg
          text = "#bfb191",     -- Gruvbox fg - but darkened
          subtext1 = "#d5c4a1", -- Gruvbox fg1
          subtext0 = "#bdae93", -- Gruvbox fg2
          overlay2 = "#a89984", -- Gruvbox fg3
          overlay1 = "#928374", -- Gruvbox fg4
          overlay0 = "#7c6f64", -- Gruvbox gray
          surface2 = "#504945", -- Gruvbox bg2
          surface1 = "#3c3836", -- Gruvbox bg1
          surface0 = "#32302f", -- Gruvbox bg0_s
          base = "#282828",     -- Gruvbox bg0
          mantle = "#1d2021",   -- Gruvbox bg0_h
          crust = "#1b1b1b",    -- Gruvbox bg0_h (slightly darker)

        },
      },
      no_italic = true,
      no_bold = true,
      custom_highlights = function(colors)
        local U = require("catppuccin.utils.colors")
        local scrollbarHandle = U.darken(colors.text, 0.10, colors.base)

        return {
          Comment = --{ fg = U.darken(colors.surface3, 0.66, colors.base) },
          { fg = U.darken(colors.text, 0.35, colors.base) },
          -- Spelling
          Spell = { fg = colors.red },
          SpellBad = { fg = colors.red },
          SpellCap = { fg = colors.red },
          SpellLocal = { fg = colors.red },

          NormalBorder = { bg = colors.mantle, fg = colors.mantle },
          FloatBorder = { bg = colors.mantle, fg = colors.mantle },
          FloatTitle = { bg = colors.red, fg = colors.crust },
          MsgArea = { bg = colors.mantle, fg = colors.text },

          -- Custom diagnostic highlights using the 'U.darken' function
          DiagnosticVirtualTextError = {
            bg = U.darken(colors.red, 0.07, colors.base),
            fg = U.darken(colors.red, 0.65, colors.base)
          },
          DiagnosticVirtualTextWarn = {
            bg = U.darken(colors.yellow, 0.04, colors.base),
            fg = U.darken(colors.yellow, 0.25, colors.base)
          },
          DiagnosticVirtualTextInfo = {
            bg = U.darken(colors.sky, 0.04, colors.base),
            fg = U.darken(colors.sky, 0.25, colors.base)
          },
          DiagnosticVirtualTextHint = {
            bg = U.darken(colors.teal, 0.02, colors.base),
            fg = U.darken(colors.teal, 0.5, colors.base)
          },

          -- TODO: Move to telescope.lua
          -- currently, that breaks this highlighting
          TelescopePromptPrefix = { bg = colors.mantle, fg = colors.red, },
          TelescopePromptTitle = { bg = colors.red, fg = colors.crust, },
          TelescopeSelection = { bg = colors.base, fg = colors.text, },
          TelescopeResultsDiffAdd = { fg = colors.green, },
          TelescopeResultsDiffChange = { fg = colors.yellow, },
          TelescopeResultsDiffDelete = { fg = colors.red, },
          TelescopeNormal = { bg = colors.mantle, },
          TelescopeBorder = { bg = colors.mantle, fg = colors.mantle, },
          TelescopePromptBorder = { bg = colors.mantle, fg = colors.mantle, },
          TelescopePromptNormal = { bg = colors.mantle, fg = colors.text, },
          TelescopeResultsTitle = { bg = colors.red, fg = colors.crust, },

          -- TODO: move to notify
          -- Does not work
          -- NotifyBackground = { bg = colors.red, fg = colors.text },
          NoiceCmdline = { bg = U.darken(colors.mantle, 0.45, colors.base) },


          -- TODO: Move to LSP
          LspInlayHint = { fg = U.darken(colors.text, 0.15, colors.mantle), bg = "" },

          -- TODO: Move to noice / notify
          -- Bug: does not work
          NotifyBackground = { bg = colors.red },

          -- Scrollbar highlights

          ScrollbarHandle = { bg = scrollbarHandle },
          ScrollbarCursorHandle = { bg = U.darken(colors.text, 0.25, colors.base) },
          -- link to CursorLine
          ScrollbarCursor = { bg = "#2a2b3c" },

          ScrollbarSearchHandle = { fg = colors.yellow, bg = scrollbarHandle },
          ScrollbarSearch = { fg = colors.yellow },

          ScrollbarErrorHandle = { fg = colors.red, bg = scrollbarHandle },
          ScrollbarError = { fg = colors.red },

          ScrollbarWarnHandle = { fg = colors.yellow, bg = scrollbarHandle },
          ScrollbarWarn = { fg = colors.yellow },

          ScrollbarInfoHandle = { fg = colors.sky, bg = scrollbarHandle },
          ScrollbarInfo = { fg = colors.sky },

          ScrollbarHintHandle = { fg = colors.teal, bg = scrollbarHandle },
          ScrollbarHint = { fg = colors.teal },

          ScrollbarMiscHandle = { fg = colors.pink, bg = scrollbarHandle },
          ScrollbarMisc = { fg = colors.pink },

          ScrollbarGitAddHandle = { fg = colors.green, bg = scrollbarHandle },
          ScrollbarGitAdd = { fg = colors.green },

          ScrollbarGitChangeHandle = { fg = colors.yellow, bg = scrollbarHandle },
          ScrollbarGitChange = { fg = colors.yellow },

          ScrollbarGitDeleteHandle = { fg = colors.red, bg = scrollbarHandle },
          ScrollbarGitDelete = { fg = colors.red },

          -- Blink
          BlinkCmpMenu = { bg = colors.mantle },

          ["@error"] = { style = { "undercurl" } },

        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
