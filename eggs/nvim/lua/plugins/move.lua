local function lua_cmd_string(s)
  return "<cmd>lua " .. s .. "<cr>"
end


return {
  "nvim-mini/mini.move",
  --opts = {
  -- TODO: figure out which mappings to use that do not conflict with popup menus, or tmux (no alt)
  --   mappings = {
  --  --   -- visual
  --  --   left = "<C-h>",
  --  --   right = "<C-l>",
  --  --   down = "<C-j>",
  --  --   up = "<C-k>",
  --  --   -- normal
  --  --   line_left = "<C-h>",
  --  --   line_right = "<C-l>",
  --  --   word_left = "<C-h>",
  --  --   word_right = "<C-l>",
  --  -- }
  --},
  keys = {
    -- We cannot map <Tab>, it's the same as <C-i> which is used by vim for jumping around
    -- TODO: unsure if alacritty supports custom keycodes / modifyOtherKeys xterm stuff. Look into it, it might be a workaround :)
    -- foot seems tohttps://codeberg.org/dnkl/foot/issues/319
    -- { "<Tab>",   lua_cmd_string("MiniMove.move_line('right')"), noremap = true, },
    { "<S-Tab>", lua_cmd_string("MiniMove.move_line('left')"), noremap = true, },
    -- Handled by keymaps.lua
    -- { "<Tab>",   lua_cmd_string("MiniMove.move_line('right')"), mode = "v",     noremap = true, },
    -- { "<S-Tab>", lua_cmd_string("MiniMove.move_line('left')"),  mode = "v",     noremap = true, },
  },
}
