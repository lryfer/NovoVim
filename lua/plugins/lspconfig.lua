return {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function() 
      require("mason").setup()
      require(lspconfig.health).check();
      require("mason-lspconfig").setup_handlers{
          ensure_installed = { "lua_ls", "clangd"},
          automatic_installation = true,
          function (server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {}
          end,
          -- Next, you can provide a dedicated handler for specific servers.
          -- For example, a handler override for the `rust_analyzer`:
          ["clangd"] = function ()
              require("clangd").setup {}
          end

        }
    end,
}
