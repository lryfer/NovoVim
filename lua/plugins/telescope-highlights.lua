return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	config = function()
		local telescope = require("telescope")

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
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("telescope_highlights", { clear = true }),

-- Try to fetch colors from the current colorscheme for consistency.
-- I'm lazy, don't want to hardcode colors, and that allows me to switch colors a lot.
			callback = function()
				local purple = vim.fn.synIDattr(vim.fn.hlID("Identifier"), "fg")
				local cyan = vim.fn.synIDattr(vim.fn.hlID("Type"), "fg") 
				local green = vim.fn.synIDattr(vim.fn.hlID("String"), "fg") 
				if purple == "" then
					purple = vim.fn.synIDattr(vim.fn.hlID("Keyword"), "fg")
				end
				if cyan == "" then
					cyan = vim.fn.synIDattr(vim.fn.hlID("Special"), "fg")
				end
				if green == "" then
					green = vim.fn.synIDattr(vim.fn.hlID("Comment"), "fg")
				end
				vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopePromptNormal", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { link = "Normal" })
				if cyan ~= "" then
					vim.cmd("highlight TelescopeBorder guifg=" .. cyan)
				end
				if purple ~= "" then
					vim.cmd("highlight TelescopePromptBorder guifg=" .. purple)
					vim.cmd("highlight TelescopeResultsBorder guifg=" .. purple)
				end
				if green ~= "" then
					vim.cmd("highlight TelescopePreviewBorder guifg=" .. green)
				end
				vim.api.nvim_set_hl(0, "TelescopePromptTitle", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "Visual" })
				vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { link = "Normal" })
				vim.api.nvim_set_hl(0, "TelescopeMatching", { link = "Search" })
			end,
		})
		vim.cmd("doautocmd ColorScheme")
	end,
}
