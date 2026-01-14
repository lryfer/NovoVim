return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-dap-python",
		"mxsdev/nvim-dap-vscode-js",
	},
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Set Breakpoint with Condition",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Continue (Start/Resume)",
		},
		{
			"<leader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<leader>ds",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<leader>dd",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle Debug UI",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Open REPL",
		},
		{
			"<leader>dw",
			function()
				require("dapui").elements.watches.add()
			end,
			desc = "Add Watch Expression",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			controls = {
				enabled = true,
				element = "repl",
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
			expand_lines = true,
			element_mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open = { "<CR>", "<2-LeftMouse>" },
				remove = { "d" },
				edit = { "e" },
				repl = { "<CR>" },
				toggle = { "<CR>" },
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.30 },
						{ id = "breakpoints", size = 0.20 },
						{ id = "stacks", size = 0.20 },
						{ id = "watches", size = 0.20 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 10,
					position = "bottom",
				},
			},
			floating = {
				max_height = 0.10,
				max_width = 0.8,
				border = "rounded",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
		})

		-- Telescope backend for vim.ui.select
		local ok, telescope = pcall(require, "telescope")
		if ok then
			local themes = require("telescope.themes")

			vim.ui.select = function(items, opts, on_choice)
				opts = opts or {}

				-- Format items (Neovim uses opts.format_item)
				local format_item = opts.format_item or function(item)
					return tostring(item)
				end

				-- Use a clean dropdown with borders and no glitches
				local picker_opts = themes.get_dropdown({
					prompt_title = opts.prompt or "Select",
					previewer = false,
					layout_config = {
						width = 0.45,
						height = math.min(#items + 4, 15), -- limite dinamico per evitare overflow
					},
				})

				require("telescope.pickers")
					.new(picker_opts, {
						finder = require("telescope.finders").new_table({
							results = items,
							entry_maker = function(item)
								return {
									value = item,
									display = format_item(item),
									ordinal = format_item(item),
								}
							end,
						}),
						sorter = require("telescope.config").values.generic_sorter(picker_opts),
						attach_mappings = function(prompt_bufnr, map)
							local actions = require("telescope.actions")
							local action_state = require("telescope.actions.state")

							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()
								if selection then
									on_choice(selection.value)
								end
							end)

							return true
						end,
					})
					:find()
			end

		end

		-- Virtual text to show variable values inline
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			enabled_commands = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			virt_text_pos = "eol",
			all_frames = false,
			virt_lines = false,
			prefix = "» ",
		})

		-- Auto open/close UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Codelldb adapter configuration for C/C++/Rust debugging
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		-- C/C++ debug configurations
		dap.configurations.c = {
			{
				name = "Launch (C/C++)",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				runInTerminal = false,
				sourceLanguages = { "c" },
			},
			{
				name = "Launch with Args (C/C++)",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				args = function()
					local args_str = vim.fn.input("Arguments (space-separated): ")
					return vim.split(args_str, " ")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				runInTerminal = false,
			},
		}

		dap.configurations.cpp = dap.configurations.c

		-- Rust debug configurations
		dap.configurations.rust = dap.configurations.c

		-- Python debug configuration
		require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/bin/python3")
		dap.configurations.python = {
			{
				name = "Launch Python",
				type = "python",
				request = "launch",
				program = function()
					return vim.fn.input("Path to Python file: ", vim.fn.getcwd() .. "/", "file")
				end,
				pythonPath = function()
					return vim.fn.input("Python interpreter path: ", "python3")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		-- JavaScript/TypeScript debug configuration with node
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/node-debug2-adapter",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.javascript = {
			{
				name = "Launch Node.js",
				type = "pwa-node",
				request = "launch",
				program = function()
					return vim.fn.input("Path to JavaScript file: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				skipFiles = { "<node_internals>/**" },
				console = "integratedTerminal",
			},
			{
				name = "Attach to Node Process",
				type = "pwa-node",
				request = "attach",
				processId = function()
					return tonumber(vim.fn.input("Process ID: "))
				end,
			},
		}

		dap.configurations.typescript = dap.configurations.javascript
	end,
}
