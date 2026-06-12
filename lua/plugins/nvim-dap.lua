return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-dap-python",
		"jay-babu/mason-nvim-dap.nvim",
	},
	keys = {
		{ "<leader>dc", function() require("dap").continue()                          end, desc = "Continue / Start" },
		{ "<leader>dn", function() require("dap").step_over()                         end, desc = "Step Over" },
		{ "<leader>ds", function() require("dap").step_into()                         end, desc = "Step Into" },
		{ "<leader>do", function() require("dap").step_out()                          end, desc = "Step Out" },
		{ "<leader>db", function() require("dap").toggle_breakpoint()                 end, desc = "Toggle Breakpoint" },
		{ "<F9>",       function() require("dap").toggle_breakpoint()                 end, desc = "Toggle Breakpoint" },
		{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
		{ "<leader>dx", function() require("dap").terminate()                         end, desc = "Terminate" },
		{ "<leader>dq", function()
			require("dap").terminate()
			require("dapui").close()
		end, desc = "Quit Debug (terminate + close UI)" },
		{ "<leader>dX", function()
			require("dap").disconnect({ terminateDebuggee = true })
			require("dap").close()
			require("dapui").close()
		end, desc = "Force Close Debug" },
		{ "<leader>dd", function() require("dapui").toggle()                          end, desc = "Toggle UI" },
		{ "<leader>dr", function() require("dap").repl.open()                         end, desc = "Open REPL" },
		{ "<leader>de", function() require("dapui").eval()                            end, mode = { "n", "v" }, desc = "Evaluate expression" },
	},
	config = function()
		local dap    = require("dap")
		local dapui  = require("dapui")
		local loader = require("languages.language_loader")

		require("mason-nvim-dap").setup({
			ensure_installed  = loader.dap_tools(),
			automatic_setup   = true,
			handlers          = {},
		})

		require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

		-- Generic GDB remote adapter for embedded / bare-metal targets.
		-- Set vim.g.embedded_gdb = "arm-none-eabi-gdb" in a project-local
		-- .nvim.lua to override the binary without touching this file.
		dap.adapters.gdb = {
			type    = "executable",
			command = function() return vim.g.embedded_gdb or "gdb" end,
			args    = { "--interpreter=dap", "--eval-command", "set print pretty on" },
		}

		-- JavaScript: pwa-node adapter (node-debug2-adapter)
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/node-debug2-adapter",
				args    = { "--port", "${port}" },
			},
		}

		-- ── Launch configurations from lang definitions ───────────────────────────
		for ft, configs in pairs(loader.dap_configs()) do
			dap.configurations[ft] = configs
		end

		-- ── UI ────────────────────────────────────────────────────────────────────
		dapui.setup({
			icons    = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			controls = {
				enabled = true,
				element = "repl",
				icons   = {
					pause      = "⏸",
					play       = "▶",
					step_into  = "⏎",
					step_over  = "⏭",
					step_out   = "⏮",
					step_back  = "b",
					run_last   = "▶▶",
					terminate  = "⏹",
					disconnect = "⏏",
				},
			},
			expand_lines     = true,
			element_mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open   = { "<CR>", "<2-LeftMouse>" },
				remove = { "d" },
				edit   = { "e" },
				repl   = { "<CR>" },
				toggle = { "<CR>" },
			},
			layouts = {
				{
					elements = {
						{ id = "scopes",      size = 0.30 },
						{ id = "breakpoints", size = 0.20 },
						{ id = "stacks",      size = 0.20 },
						{ id = "watches",     size = 0.20 },
					},
					size     = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl",    size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size     = 10,
					position = "bottom",
				},
			},
			floating = {
				max_height = 0.10,
				max_width  = 0.8,
				border     = "rounded",
				mappings   = { close = { "q", "<Esc>" } },
			},
		})

		-- Auto open/close UI
		dap.listeners.before.attach.dapui_config        = function() dapui.open() end
		dap.listeners.before.launch.dapui_config        = function() dapui.open() end
		dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
		dap.listeners.before.event_exited.dapui_config  = function() dapui.close() end

		-- Add 'q' to close DAP UI windows
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "dap-repl", "dapui_console", "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes" },
			callback = function(args)
				vim.keymap.set("n", "q", function()
					local win = vim.api.nvim_get_current_win()
					if vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_close(win, true)
					end
				end, { buffer = args.buf, desc = "Close DAP window" })
			end,
		})

		-- ── Mouse click on sign column to toggle breakpoint ─────────────────────
		vim.keymap.set("n", "<LeftMouse>", function()
			local pos = vim.fn.getmousepos()
			-- wincol == 1 → click landed in the sign column
			if pos.wincol == 1 and pos.line > 0 then
				vim.api.nvim_set_current_win(pos.winid)
				vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 0 })
				require("dap").toggle_breakpoint()
				return
			end
			-- Otherwise pass the click through normally
			vim.api.nvim_feedkeys(
				vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true), "n", false
			)
		end)

		-- ── Virtual text ─────────────────────────────────────────────────────────
		require("nvim-dap-virtual-text").setup({
			enabled                  = true,
			highlight_new_as_changed = false,
			show_stop_reason         = true,
			virt_text_pos            = "eol",
			all_frames               = false,
			prefix                   = "» ",
		})

		-- ── Telescope backend for vim.ui.select ──────────────────────────────────
		local ok, telescope = pcall(require, "telescope")
		if ok then
			local themes = require("telescope.themes")
			vim.ui.select = function(items, opts, on_choice)
				opts = opts or {}
				local format_item = opts.format_item or tostring
				local picker_opts = themes.get_dropdown({
					prompt_title  = opts.prompt or "Select",
					previewer     = false,
					layout_config = { width = 0.45, height = math.min(#items + 4, 15) },
				})
				require("telescope.pickers").new(picker_opts, {
					finder = require("telescope.finders").new_table({
						results     = items,
						entry_maker = function(item)
							return { value = item, display = format_item(item), ordinal = format_item(item) }
						end,
					}),
					sorter = require("telescope.config").values.generic_sorter(picker_opts),
					attach_mappings = function(prompt_bufnr)
						local actions      = require("telescope.actions")
						local action_state = require("telescope.actions.state")
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local sel = action_state.get_selected_entry()
							if sel then on_choice(sel.value) end
						end)
						return true
					end,
				}):find()
			end
		end
	end,
}
