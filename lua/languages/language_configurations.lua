-- ─────────────────────────────────────────────────────────────────────────────
--  Language definitions
--  To enable a language  → uncomment its block
--  To disable a language → comment out its block
--
--  Fields:
--    lsp         string          lspconfig server name
--    lsp_opts    table           extra opts passed to vim.lsp.config(name, opts)
--    mason       string[]        mason package names  (formatters, linters, etc.)
--    dap         string[]        mason DAP adapter package names
--    dap_configs table<ft,list>  nvim-dap launch configurations per filetype
--    fmt         table<ft,list>  conform formatters per filetype
--    ts          string[]        treesitter parsers
-- ─────────────────────────────────────────────────────────────────────────────

return {

	-- ── Lua ────────────────────────────────────────────────────────────────────
	{
		lsp = "lua_ls",
		lsp_opts = {
			settings = {
				Lua = {
					runtime    = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace  = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
					telemetry  = { enable = false },
				},
			},
		},
		mason = { "stylua" },
		fmt   = { lua = { "stylua" } },
		ts    = { "lua" },
	},

	-- ── C / C++ ────────────────────────────────────────────────────────────────
	{
		lsp = "clangd",
		lsp_opts = {
			cmd = { "clangd", "--background-index", "--header-insertion=never" },
		},
		mason = { "clang-format" },
		dap   = { "codelldb" },
		dap_configs = {
			c = {
				{
					name    = "Launch",
					type    = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd         = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name    = "Launch with args",
					type    = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					args = function()
						return vim.split(vim.fn.input("Args: "), " ", { plain = true })
					end,
					cwd         = "${workspaceFolder}",
					stopOnEntry = false,
				},
			},
		},
		fmt = { c = { "clang_format" }, cpp = { "clang_format" } },
		ts  = { "c", "cpp" },
	},

	-- ── Python ─────────────────────────────────────────────────────────────────
	{
		lsp   = "pyright",
		mason = { "black", "isort" },
		dap   = { "debugpy" },
		dap_configs = {
			python = {
				{
					name    = "Launch file",
					type    = "python",
					request = "launch",
					program = "${file}",
					pythonPath = function()
						local venv = vim.fn.getcwd() .. "/.venv/bin/python"
						if vim.fn.executable(venv) == 1 then return venv end
						return vim.fn.exepath("python3") or "python3"
					end,
				},
				{
					name    = "Launch file with args",
					type    = "python",
					request = "launch",
					program = "${file}",
					args = function()
						return vim.split(vim.fn.input("Args: "), " ", { plain = true })
					end,
					pythonPath = function()
						local venv = vim.fn.getcwd() .. "/.venv/bin/python"
						if vim.fn.executable(venv) == 1 then return venv end
						return vim.fn.exepath("python3") or "python3"
					end,
				},
			},
		},
		fmt = { python = { "black", "isort" } },
		ts  = { "python" },
	},

	-- ── Rust ───────────────────────────────────────────────────────────────────
	{
		lsp = "rust_analyzer",
		lsp_opts = {
			settings = {
				["rust-analyzer"] = {
					checkOnSave   = { command = "clippy" },
					cargo         = { allFeatures = true },
					procMacro     = { enable = true },
					inlayHints    = {
						bindingModeHints  = { enable = true },
						chainingHints     = { enable = true },
						closingBraceHints = { enable = true },
						typeHints         = { enable = true },
						parameterHints    = { enable = true },
					},
				},
			},
		},
		mason = {},
		dap   = { "codelldb" },
		dap_configs = {
			rust = {
				{
					name    = "Launch",
					type    = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd         = "${workspaceFolder}",
					stopOnEntry = false,
				},
			},
		},
		fmt = { rust = { "rustfmt" } },
		ts  = { "rust" },
	},

	-- ── HTML ───────────────────────────────────────────────────────────────────
	{
		lsp = "html",
		lsp_opts = {
			settings = {
				html = {
					format = { templating = true, wrapLineLength = 120, wrapAttributes = "auto" },
					hover  = { documentation = true, references = true },
				},
			},
		},
		mason = { "prettier" },
		fmt   = { html = { "prettier" } },
		ts    = { "html" },
	},

	-- ── CSS ────────────────────────────────────────────────────────────────────
	{
		lsp   = "cssls",
		mason = {},
		fmt   = { css = { "prettier" } },
		ts    = { "css" },
	},

	-- ── Svelte ─────────────────────────────────────────────────────────────────
	-- NOTE: uncomment ts_ls below too — svelte-language-server delegates
	--       TypeScript/JavaScript analysis to ts_ls at runtime.
	{
		lsp   = "svelte",
		mason = { "prettier" },
		fmt   = { svelte = { "prettier" } },
		ts    = { "svelte" },
	},

	-- ── JavaScript / TypeScript ────────────────────────────────────────────────
	-- {
	-- 	lsp   = "ts_ls",
	-- 	mason = { "prettier" },
	-- 	dap   = { "node-debug2-adapter" },
	-- 	dap_configs = {
	-- 		javascript = {
	-- 			{
	-- 				name    = "Launch Node.js",
	-- 				type    = "pwa-node",
	-- 				request = "launch",
	-- 				program = "${file}",
	-- 				cwd     = "${workspaceFolder}",
	-- 				skipFiles = { "<node_internals>/**" },
	-- 			},
	-- 			{
	-- 				name      = "Attach to process",
	-- 				type      = "pwa-node",
	-- 				request   = "attach",
	-- 				processId = require("dap.utils").pick_process,
	-- 			},
	-- 		},
	-- 		typescript = "javascript",
	-- 	},
	-- 	fmt = { javascript = { "prettier" }, typescript = { "prettier" } },
	-- 	ts  = { "javascript", "typescript" },
	-- },

	-- ── Embedded / Bare-metal (GDB remote) ────────────────────────────────────
	-- Adds embedded debug configs to the C/C++ filetype.
	-- Set vim.g.embedded_gdb = "arm-none-eabi-gdb" (or riscv-none-elf-gdb,
	-- avr-gdb, etc.) in a project-local .nvim.lua to pick the right toolchain.
	-- Start your GDB server separately (openocd, JLinkGDBServer, pyocd, etc.),
	-- then launch a debug session with <leader>dc and pick "Attach to GDB server".
	{
		dap_configs = {
			c = {
				{
					name    = "Attach to GDB server",
					type    = "gdb",
					request = "attach",
					program = function()
						return vim.fn.input("ELF: ", vim.fn.getcwd() .. "/", "file")
					end,
					target = function()
						return vim.fn.input("Server address (host:port): ", "localhost:3333")
					end,
					cwd            = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
			},
		},
	},

	-- ── ASM (x86 / x86_64 / ARM / RISC-V) ─────────────────────────────────────
	{
		lsp   = "asm_lsp",
		mason = {},
		dap   = { "codelldb" },
		dap_configs = {
			asm = {
				{
					name    = "Launch",
					type    = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd         = "${workspaceFolder}",
					stopOnEntry = false,
				},
			},
		},
		fmt = {},
		ts  = { "asm" },
	},

	-- ── Misc parsers (no LSP) ──────────────────────────────────────────────────
	{
		ts = { "markdown", "json", "yaml", "bash", "vim" },
	},

}
