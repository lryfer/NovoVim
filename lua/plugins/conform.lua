return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()
			local loader = require("lang.loader")

			require("conform").setup({
				formatters_by_ft = loader.conform_formatters(),
			})

			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				require("conform").format({ lsp_fallback = true })
			end, { desc = "Format buffer" })
		end,
	},
}
