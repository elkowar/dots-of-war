return {
  {
    "petertriho/nvim-scrollbar",
    opts = {
      set_highlights = false,
      hide_if_all_visible = true,
      throttle_ms = 50, -- default: 100
      marks = {
        Error = {
          text = { "-" },
        },
        Warn = {
          text = { "-" },
        },
        Info = {
          text = { "-" },
        },
        Hint = {
          text = { "-" },
        },
        Cursor = {
          text = " ",
        }
      }
    }
  }
}
