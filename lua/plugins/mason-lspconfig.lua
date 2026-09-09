return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",

		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = vim.g.Mason_Icon_package_installed,
						package_pending = vim.g.Mason_Icon_package_pending,
						package_uninstalled = vim.g.Mason_Icon_package_uninstalled,
					},
				},
			})
		end,
	},

	{
		"mason-org/mason-lspconfig.nvim",

		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},

		config = function()
			local servers = {}

			local language_servers = {
				vim.g.c_language_server,
				vim.g.lua_language_server,
				vim.g.rust_language_server,
				vim.g.javascript_language_server,
				vim.g.html_language_server,
			}

			for _, server in ipairs(language_servers) do
				if server and server ~= "" then
					table.insert(servers, server)
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
				automatic_enable = false,
			})

			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.lsp.enable(servers)
		end,
	},

	{
		"neovim/nvim-lspconfig",

		lazy = false,
		priority = 100,

		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", {
					clear = true,
				}),

				callback = function(args)
					local opts = {
						buffer = args.buf,
						silent = true,
					}

					vim.keymap.set(
						"n",
						vim.g.command_lsp_hover,
						vim.lsp.buf.hover,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_definition,
						vim.lsp.buf.definition,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_declaration,
						vim.lsp.buf.declaration,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_implementation,
						vim.lsp.buf.implementation,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_references,
						vim.lsp.buf.references,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_type_definition,
						vim.lsp.buf.type_definition,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_code_action,
						vim.lsp.buf.code_action,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_rename,
						vim.lsp.buf.rename,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_signature_help,
						vim.lsp.buf.signature_help,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_diagnostic_prev,
						vim.diagnostic.goto_prev,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_diagnostic_next,
						vim.diagnostic.goto_next,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_diagnostic_float,
						vim.diagnostic.open_float,
						opts
					)

					vim.keymap.set(
						"n",
						vim.g.command_lsp_diagnostic_loclist,
						vim.diagnostic.setloclist,
						opts
					)
				end,
			})
		end,
	},
}
