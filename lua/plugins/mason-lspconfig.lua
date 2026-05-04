return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
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
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "html", "cssls", "pyright", "lua_ls", "rust_analyzer", "svelte" },
				automatic_installation = true,
				automatic_enable = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 100,
		config = function()
			-- Use Neovim 0.11+ native API
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- on_attach hook for all servers
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
			end

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				},
				clangd = {
					cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
					init_options = {
						clangdFileStatus = true,
						usePlaceholders = true,
						completeUnimplementedMethods = true,
					},
				},
				html = {
					settings = {
						html = {
							format = {
								templating = true,
								wrapLineLength = 120,
								wrapAttributes = "auto",
							},
							hover = {
								documentation = true,
								references = true,
							},
						},
					},
				},
				cssls = {},
				pyright = {},
			}

			-- Configure servers using native Neovim 0.11+ API
			for server_name, config_opts in pairs(servers) do
				config_opts.capabilities = capabilities
				config_opts.on_attach = on_attach
				vim.lsp.config(server_name, config_opts)
			end

			-- Enable all configured servers
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
}
