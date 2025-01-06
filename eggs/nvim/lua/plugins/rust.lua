return {
  'neovim/nvim-lspconfig',
  opts = {
    setup = {
      -- Fix a problem with rust_analyzer being installed with lazyvim
      -- see `:h rustaceanvim.mason`
      rust_analyzer = function()
        return true
      end,
    },
  },
}
