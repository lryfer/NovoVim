return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	event = "VeryLazy",
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = tools,
			auto_update      = false,
			run_on_start     = true,
			start_delay      = 3000,
			debounce_hours   = 5,
		})
	end,
}
