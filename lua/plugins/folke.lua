return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			config = function()
				require("notify").setup({
					timeout = 1000,
					stages = "static",
					background_colour = "#000000",
					render = "minimal",
				})
				vim.notify = require("notify")
			end,
		},
	},
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			progress = { enabled = false },
		},
		routes = {
			{ filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
			{ filter = { event = "msg_show", kind = "info" }, opts = { skip = true } },
			{ filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = false,
		},
		popupmenu = {
			backend = "nui",
			border = {
				style = "single",
			},
		},
	},
}
