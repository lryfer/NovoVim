return{
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  config = function ()
    require("nvim-lspconfig").setup{
      opts = {
        settings = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 120,
              wrapAttributes = 'auto',
            },
            hover = {
              documentation = true,
              references = true,
            },
          },
        },
      },
    }
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    require("lspconfig").html.setup{
      capabilities = capabilities,
    }
    require("mason-lspconfig").setup {
      ensure_installed = {"clangd", "html", "css", "javascript", "typescript"},
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
