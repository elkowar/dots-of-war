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
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- local keymaps = require("lazyvim.plugins.lsp.keymaps").get()
      -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      --   -- Disable underline of errors (it's annoying)
      --   underline = false,
      -- })

      -- Disable all the default LazyVim keymaps
      -- for _, keymap in ipairs(keymaps) do
      --   keymap[2] = false
      -- end

      -- opts.keymaps = keymaps
      opts.servers = {}
      opts.servers["*"] = {
        keys = {
          { "<leader>mf", vim.lsp.buf.format, desc = "Format buffer", mode = { "n" } },
          {
            "<C-s>",
            vim.lsp.buf.signature_help,
            mode = { "n", "i" },
            desc = "Signature Help",
            has = "signatureHelp",
          },
          { "<leader>md", vim.lsp.buf.hover, desc = "Hover" },
          { "<leader>ms", vim.lsp.buf.workspace_symbol, desc = "Project symbol search" },
          {
            "<leader>mg",
            trouble("lsp_definitions"),
            desc = "Goto Definition",
            has = "definition",
          },
          {
            "gd",
            trouble("lsp_definitions"),
            desc = "Goto Definition",
            has = "definition",
          },
          { "<leader>mi", trouble("lsp_implementations"), desc = "Goto Implementation" },
          { "<leader>mt", trouble("lsp_type_definitions"), desc = "Goto Type Definition" },
          { "<leader>mn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
          { "<leader>mr", trouble("lsp_references"), desc = "Find referenes" },
          { "<leader>mv", vim.lsp.buf.code_action, desc = "Code actions" },

          {
            "<leader>ml",
            vim.lsp.codelens.run,
            desc = "Run Codelens",
            mode = { "n", "v" },
            has = "codeLens",
          },
          {
            "<leader>mA",
            LazyVim.lsp.action.source,
            desc = "Source Action",
            has = "codeAction",
          },
          { "<leader>mD", trouble("lsp_declarations"), desc = "Goto Declaration" },
          {
            "K",
            vim.lsp.buf.signature_help,
            mode = "n",
            desc = "Signature Help",
            has = "signatureHelp",
          },
          {
            "<leader>mN",
            Snacks.rename.rename_file,
            desc = "Rename File",
            mode = { "n" },
            has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
          },

          {
            "<leader>me",
            function()
              vim.diagnostic.jump({ count = 1 })
            end,
            desc = "Line Diagnostics",
          },
          { "<leader>ee", cmdbind("Trouble diagnostics focus=true"), desc = "Line Diagnostics" },

          {
            "]]",
            function()
              Snacks.words.jump(vim.v.count1)
            end,
            has = "documentHighlight",
            desc = "Next Reference",
            cond = function()
              return Snacks.words.enabled
            end,
          },
          {
            "[[",
            function()
              Snacks.words.jump(-vim.v.count1)
            end,
            has = "documentHighlight",
            desc = "Prev Reference",
            cond = function()
              return Snacks.words.enabled
            end,
          },
        },
      }
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
        end,
        desc = "Pick symbols in winbar",
      },
    },
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
