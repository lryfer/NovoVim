local lspconfig = require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup()
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false }
    }
  }
}
lspconfig.clangd.setup {}
lspconfig.pyright.setup {}
lspconfig.ts_ls.setup {}
