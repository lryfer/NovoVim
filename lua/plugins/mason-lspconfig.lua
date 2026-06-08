return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed   = "✓",
						package_pending     = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			local loader = require("languages.language_loader")
			require("mason-lspconfig").setup({
				ensure_installed      = loader.lsp_server_names(),
				automatic_installation = true,
				automatic_enable      = false,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 100,
		config = function()
			local loader   = require("languages.language_loader")
			local lsp_diag = require("core.diagnostic")

			-- LspAttach fires reliably for every client regardless of how
			-- the server was started, unlike on_attach in vim.lsp.config("*").
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end
					local bufnr   = args.buf
					local root_dir = client.config.root_dir or vim.fn.getcwd()
					lsp_diag.register_client(client, root_dir)

					local opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "K",          vim.lsp.buf.hover,           opts)
					vim.keymap.set("n", "gd",         vim.lsp.buf.definition,      opts)
					vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,     opts)
					vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,  opts)
					vim.keymap.set("n", "gr",         vim.lsp.buf.references,      opts)
					vim.keymap.set("n", "gt",         vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,     opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          opts)
					vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help,  opts)
					vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,    opts)
					vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,    opts)
					vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,   opts)
					vim.keymap.set("n", "<leader>q",  vim.diagnostic.setloclist,   opts)
				end,
			})

			-- Capabilities set globally; no on_attach here (handled by LspAttach above)
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			-- Per-server opts from lang definitions (merged with global)
			for name, opts in pairs(loader.lsp_servers()) do
				vim.lsp.config(name, opts)
			end

			vim.lsp.enable(loader.lsp_server_names())
		end,
	},
}
