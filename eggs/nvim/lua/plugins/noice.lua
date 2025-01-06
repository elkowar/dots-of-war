return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      return vim.tbl_extend("force",
        {
          cmdline = {
            view = "cmdline",
            enabled = true,
          },
          messages = {
            enabled = true,
          },
          -- the completion menu for the cmdline
          popupmenu = {
            enabled = true,
            backend = "nui" -- do not use the "vscode style" middle of the screen popup (nui?)
            -- Side effect: apparently fixed an issue with "Save changes to ..." popup being slow to respond(?)
          }
        }, opts)
    end
  },
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      local stages_util = require("notify.stages.util")
      -- mix between https://github.com/rcarriga/nvim-notify/issues/105
      -- and https://github.com/rcarriga/nvim-notify/blob/master/lua/notify/stages/static.lua
      -- Basically: No border + move notifications up as they expire
      local function static_no_border_and_move_up(direction)
        return {
          function(state)
            local next_height = state.message.height + 2
            local next_row = stages_util.available_slot(state.open_windows, next_height, stages_util.DIRECTION.TOP_DOWN)
            if not next_row then
              return nil
            end
            return {
              relative = "editor",
              anchor = "NE",
              width = state.message.width,
              height = state.message.height,
              col = vim.opt.columns:get(),
              row = next_row,
              border = "none",
              style = "minimal",
            }
          end,
          function(state, win)
            return {
              col = vim.opt.columns:get(),
              time = true,
              row = {
                stages_util.slot_after_previous(win, state.open_windows, stages_util.DIRECTION.TOP_DOWN),
                frequency = 3,
                complete = function()
                  return true
                end,
              }
            }
          end,
        }
      end

      return {
        render = "compact",
        stages = static_no_border_and_move_up(),
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { focusable = false })
        end,
      }
    end
  }
}
