function cmdbind(cmd)
  return function()
    vim.cmd(cmd)
  end
end

function trouble(thing)
  return cmdbind("Trouble " .. thing .. " focus=true")
end

return {
  --{
  --  "smjonas/inc-rename.nvim",
  --  opts = {
  --    --input_buffer_type = "dressing"
  --  }
  --},
  {
    "stevearc/dressing.nvim",
    opts = {
      select = {
        backend = { "builtin" },
        builtin = {
          min_height = { 0, 0 },
          title_pos = "left",
          border = "single",
          relative = "cursor",
        },
      }
    }
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keymaps = require("lazyvim.plugins.lsp.keymaps").get()
      vim.lsp.handlers["textDocument/publishDiagnostics"] =
          vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            -- Disable underline of errors (it's annoying)
            underline = false,
          })

      -- Disable all the default LazyVim keymaps
      for _, keymap in ipairs(keymaps) do
        keymap[2] = false
      end

      local custom_keymaps = {
        { "<leader>mf", vim.lsp.buf.format,                        desc = "Format buffer",        mode = { "n" }, },
        { "<C-s>",      vim.lsp.buf.signature_help,                mode = { "n", "i" },           desc = "Signature Help", has = "signatureHelp" },
        { "<leader>md", vim.lsp.buf.hover,                         desc = "Hover" },
        { "<leader>ms", vim.lsp.buf.workspace_symbol,              desc = "Project symbol search" },
        { "<leader>mg", trouble("lsp_definitions"),                desc = "Goto Definition",      has = "definition" },
        { "gd",         trouble("lsp_definitions"),                desc = "Goto Definition",      has = "definition" },
        { "<leader>mi", trouble("lsp_implementations"),            desc = "Goto Implementation" },
        { "<leader>mt", trouble("lsp_type_definitions"),           desc = "Goto Type Definition" },
        { "<leader>mn", vim.lsp.buf.rename,                        desc = "Rename",               has = "rename" },
        { "<leader>mr", trouble("lsp_references"),                 desc = "Find referenes" },
        { "<leader>mv", vim.lsp.buf.code_action,                   desc = "Code actions" },

        { "<leader>ml", vim.lsp.codelens.run,                      desc = "Run Codelens",         mode = { "n", "v" },     has = "codeLens" },
        { "<leader>mA", LazyVim.lsp.action.source,                 desc = "Source Action",        has = "codeAction" },
        { "<leader>mD", trouble("lsp_declarations"),               desc = "Goto Declaration" },
        { "K",          vim.lsp.buf.signature_help,                mode = "n",                    desc = "Signature Help", has = "signatureHelp" },
        { "<leader>mN", Snacks.rename.rename_file,                 desc = "Rename File",          mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },

        { "<leader>me", vim.diagnostic.goto_next,                  desc = "Line Diagnostics" },
        { "<leader>ee", cmdbind("Trouble diagnostics focus=true"), desc = "Line Diagnostics" },

        {
          "]]",
          function() Snacks.words.jump(vim.v.count1) end,
          has = "documentHighlight",
          desc = "Next Reference",
          cond = function() return Snacks.words.enabled end
        },
        {
          "[[",
          function() Snacks.words.jump(-vim.v.count1) end,
          has = "documentHighlight",
          desc = "Prev Reference",
          cond = function() return Snacks.words.enabled end
        },
      }

      vim.list_extend(keymaps, custom_keymaps)
      opts.keymaps = keymaps
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "LspAttach",
    keys = {
      {
        "<C-Y>",
        function()
          local dropbar_utils = require("dropbar.utils")
          local dropbar_api = require("dropbar.api")
          local bar = dropbar_utils.bar.get_current()
          local components = bar.components
          dropbar_api.pick(#components)
          --if not menu then
          --  return
          --end
          --local cursor = vim.api.nvim_win_get_cursor(menu.win)
          --local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
          --if component then
          --  menu:click_on(component, nil, 1, "l")
          --end
        end,
        desc = "Pick symbols in winbar"
      },
    },
    -- https://github.com/Bekaboo/dropbar.nvim/issues/160
    opts = function()
      local utils = require('dropbar.utils')
      local bar_utils = require('dropbar.utils.bar')
      local api = require('dropbar.api')

      local open_item_and_close_menu = function()
        local menu = utils.menu.get_current()
        local cursor = vim.api.nvim_win_get_cursor(menu.win)
        local entry = menu.entries[cursor[1]]
        -- stolen from https://github.com/Bekaboo/dropbar.nvim/issues/66
        local component = entry:first_clickable(entry.padding.left + entry.components[1]:bytewidth())
        if component then
          menu:click_on(component, nil, 1, 'l')
        end
      end

      local function prev_breadcrumb()
        local menu = utils.menu.get_current()
        if menu.prev_menu then
          menu:close()
        end
        local bar = bar_utils.get({ win = menu.prev_win })
        if not bar then
          return
        end
        local barComponents = bar.components
        for _, component in ipairs(barComponents) do
          if component.menu then
            local idx = component._.bar_idx
            if idx > 1 then -- Only move if not at the first item
              menu:close()
              api.pick(idx - 1)
            end
            break
          end
        end
      end


      local function next_breadcrumb()
        local menu = utils.menu.get_current()
        if menu.prev_menu then
          menu:close()
        end
        local bar = bar_utils.get({ win = menu.prev_win })
        if not bar then
          return
        end
        local barComponents = bar.components
        local maxIdx = #barComponents
        for _, component in ipairs(barComponents) do
          if component.menu then
            local idx = component._.bar_idx
            if idx < maxIdx then
              menu:close()
              api.pick(idx + 1)
            end
            break
          end
        end
      end
      local expand_menu = function()
        local menu = utils.menu.get_current()
        if not menu then
          return
        end
        local cursor = vim.api.nvim_win_get_cursor(menu.win)
        local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
        if component then
          menu:click_on(component, nil, 1, 'l')
        end
      end

      return {

        menu = {
          -- do not switch editor view on selection, use CR otherwise, the
          -- next_breadcrumb will not work sometimes because the window changes
          preview = false,
          keymaps = {
            ['<C-h>'] = function()
              -- Move to previous breadcrumb
              prev_breadcrumb()
            end,
            ['<C-l>'] = function()
              -- Move to next breadcrumb
              next_breadcrumb()
            end,
            ['h'] = function()
              prev_breadcrumb()
            end,
            ['l'] = function()
              expand_menu()
            end,
            ['<CR>'] = open_item_and_close_menu,
            ['o'] = open_item_and_close_menu,
          }
        },
      }
    end
  },
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {
      icons = {
        type = "» ",
        parameter = "« ",
        offspec = " ", -- hint kind not defined in official LSP spec
        unknown = " ", -- hint kind is nil
      },
    },
  },
}

-- try: https://github.com/Saghen/blink.cmp?tab=readme-ov-file#compared-to-nvim-cmp
