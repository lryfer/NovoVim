return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	config = function()
		local telescope = require("telescope")

		-- Setup pickers with TUI thin lines
		telescope.setup({
			pickers = {
				find_files = {
					border = true,
					borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				},
				live_grep = {
					border = true,
					borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				},
				buffers = {
					border = true,
					borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				},
			},
		})

		-- Set Telescope highlight groups after colorscheme is loaded
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("telescope_highlights", { clear = true }),
			callback = function()
				-- Get colors from current theme
				local purple = vim.fn.synIDattr(vim.fn.hlID("Identifier"), "fg") -- Purple for grep
				local cyan = vim.fn.synIDattr(vim.fn.hlID("Type"), "fg") -- Cyan for find_files
				local green = vim.fn.synIDattr(vim.fn.hlID("String"), "fg") -- Green for other

				-- Fallback to other theme highlight groups if not found
				if purple == "" then
					purple = vim.fn.synIDattr(vim.fn.hlID("Keyword"), "fg")
				end
				if cyan == "" then
					cyan = vim.fn.synIDattr(vim.fn.hlID("Special"), "fg")
				end
				if green == "" then
					green = vim.fn.synIDattr(vim.fn.hlID("Comment"), "fg")
				end

				-- Keep backgrounds normal
				vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopePromptNormal", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { link = "Normal" })

				-- Color borders based on picker - using vim.cmd for explicit color
				-- find_files: cyan
				if cyan ~= "" then
					vim.cmd("highlight TelescopeBorder guifg=" .. cyan)
				end
				-- live_grep/results: purple
				if purple ~= "" then
					vim.cmd("highlight TelescopePromptBorder guifg=" .. purple)
					vim.cmd("highlight TelescopeResultsBorder guifg=" .. purple)
				end
				-- preview: green
				if green ~= "" then
					vim.cmd("highlight TelescopePreviewBorder guifg=" .. green)
				end

				-- Titles
				vim.api.nvim_set_hl(0, "TelescopePromptTitle", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { link = "Normal" })

				-- Selection and matching
				vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "Visual" })
				vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopeMatching", { link = "Search" })
			end,
		})

		-- Trigger colorscheme event to apply highlights
		vim.cmd("doautocmd ColorScheme")
	end,
}
