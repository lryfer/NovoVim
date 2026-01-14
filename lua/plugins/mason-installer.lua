-- Automatic installation and management of LSP servers, debuggers, and formatters
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
			ensure_installed = {
				"prettier",
				"stylua",
				"black",
				"clang-format",
				"eslint_d",
				"flake8",
				"html",
				"cssls",
				"clangd",
				"pyright",
				"lua_ls",
				"jsonls",
				"marksman",
				"bashls",
				"codelldb",
				"debugpy",
				"node-debug2-adapter",
				"rust-analyzer",
				"svelte-language-server",
			},

			auto_update = false,
			run_on_start = true,
			start_delay = 3000,
			debounce_hours = 5,
		})
	end,
}
