return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          javascript = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          markdown = { "prettier" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          rust = { "rustfmt" },
        },
        format_on_save = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          local formatters = require("conform").list_formatters(bufnr)

          if #formatters == 0 then
            return nil
          end

          return {
            lsp_fallback = true,
            timeout_ms = 500,
          }
        end,
      })

      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        require("conform").format({ lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  }
}
