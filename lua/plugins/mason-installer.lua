return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	event = "VeryLazy",
	config = function()
		local loader = require("languages.language_loader")

		local tools = loader.mason_tools()
		vim.list_extend(tools, loader.dap_tools())

		require("mason-tool-installer").setup({
			ensure_installed = tools,
			auto_update      = false,
			run_on_start     = true,
			start_delay      = 3000,
			debounce_hours   = 5,
		})
	end,
}
