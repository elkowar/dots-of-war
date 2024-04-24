-- [nfnl] Compiled from fnl/dots/plugins/cmp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local utils = _local_1_["utils"]
local cmp = autoload("cmp")
local function item_formatter(item, vim_item)
  do
    local padding = string.rep(" ", (10 - vim.fn.strwidth(vim_item.abbr)))
    local details
    do
      local t_2_ = item
      if (nil ~= t_2_) then
        t_2_ = (t_2_).completion_item
      else
      end
      if (nil ~= t_2_) then
        t_2_ = (t_2_).detail
      else
      end
      details = t_2_
    end
    if details then
      vim_item.abbr = (vim_item.abbr .. padding .. " " .. details)
    else
    end
  end
  return vim_item
end
local function setup()
  local function _6_(args)
    return vim.fn["vsnip#anonymous"](args.body)
  end
  local function _7_()
    cmp.mapping.close()
    return vim.cmd("stopinsert")
  end
  local function _8_(_241, _242)
    if ((15 == _241:get_kind()) and (15 == _242:get_kind())) then
      return nil
    elseif (15 == _241:get_kind()) then
      return false
    elseif (15 == _242:get_kind()) then
      return true
    else
      return nil
    end
  end
  cmp.setup({snippet = {expand = _6_}, completion = {autocomplete = false}, mapping = cmp.mapping.preset.insert({["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-space>"] = cmp.mapping.complete(), ["<esc>"] = _7_, ["<CR>"] = cmp.mapping.confirm({select = true})}), experimental = {custom_menu = true}, sources = {{name = "nvim_lsp", priority = 5}, {name = "vsnip", priority = 3}, {name = "nvim_lua"}, {name = "calc"}, {name = "path"}, {name = "nvim_lsp_signature_help"}, {name = "conventionalcommits"}, {name = "crates"}}, formatting = {format = item_formatter}, sorting = {priority_weight = 2, comparators = {_8_, cmp.config.compare.offset, cmp.config.compare.exact, cmp.config.compare.score, cmp.config.compare.kind, cmp.config.compare.sort_text, cmp.config.compare.length, cmp.config.compare.order}}})
  return cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})
end
return {utils.plugin("hrsh7th/vim-vsnip", {lazy = true, event = {"VeryLazy"}}), utils.plugin("hrsh7th/vim-vsnip-integ", {lazy = true, event = {"VeryLazy"}}), utils.plugin("rafamadriz/friendly-snippets"), utils.plugin("hrsh7th/nvim-cmp", {lazy = true, event = {"VeryLazy"}, dependencies = {{"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"}, {"hrsh7th/cmp-vsnip"}, {"hrsh7th/cmp-nvim-lua"}, {"hrsh7th/cmp-calc"}, {"hrsh7th/cmp-path"}, {"hrsh7th/cmp-nvim-lsp-signature-help"}, {"davidsierradz/cmp-conventionalcommits"}, {"hrsh7th/cmp-omni"}}, config = setup})}
