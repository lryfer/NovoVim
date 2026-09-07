return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()

			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				require("conform").format({ lsp_fallback = true })
			end, { desc = "Format buffer" })
		end,
	},
}
