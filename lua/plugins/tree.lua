return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,

	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},

			view = {
				width = 30,
				side = "right",
			},

			renderer = {
				group_empty = true,
				highlight_git = true,

				icons = {
					show = {
						file = false,
						folder = true,
						folder_arrow = true,
						git = false,
					},
				},
			},

			filters = {
				dotfiles = true,
			},
		})

		local function theme_color(...)
			for _, group in ipairs({ ... }) do
				local color = vim.fn.synIDattr(
					vim.fn.hlID(group),
					"fg"
				)

				if color ~= "" then
					return color
				end
			end

			return nil
		end
		local green = theme_color("String", "Comment", "Constant", "Normal")
		local purple = theme_color("Identifier", "Keyword", "Function", "Normal")
		local cyan = theme_color("Type", "Special", "Statement", "Normal")
		local red = theme_color("Error", "DiagnosticError", "Constant", "Normal")
		local yellow = theme_color("WarningMsg", "DiagnosticWarn", "Todo", "Normal")
		local git_colors = {
			NvimTreeGitNew = green,
			NvimTreeGitDirty = purple,
			NvimTreeGitDeleted = red,
			NvimTreeGitRenamed = cyan,
			NvimTreeGitStaged = yellow,
		}

		for group, color in pairs(git_colors) do
			if color then
				vim.cmd("highlight " .. group .. " guifg=" .. color)
			end
		end
		vim.keymap.set(
			"n",
			"<leader>tt",
			vim.cmd.NvimTreeToggle,
			{ desc = "Toggle File Tree" }
		)
	end,
}
