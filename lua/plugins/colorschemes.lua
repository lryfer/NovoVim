return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000,
	config = function()
		require("everforest").setup({
			background = "medium",
			transparent_background_level = 0,
			italics = false,
			disable_italic_comments = true,
			sign_column_background = "none",
			ui_contrast = "low",
			float_style = "dim",
			dim_inactive_windows = false,
			lualine_bold = true,

			on_highlights = function(highlights, palette)
				-- Custom highlights here
			end,
		})

		vim.cmd.colorscheme("everforest")
	end,
}
