return{
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  config = function ()
    require("mason-lspconfig").setup {
      ensure_installed = {"clangd"},
      automatic_installation = false,
    }
    require("mason").setup({
      ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
        }
      }
    })
    end,
}
