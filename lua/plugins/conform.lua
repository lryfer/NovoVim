return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()

			vim.keymap.set({ "n", "v" }, vim.g.command_conform_format_buffer , function()
				require("conform").format({ lsp_fallback = true })
			end, { desc = "Format buffer" })
		end,
	},
}
