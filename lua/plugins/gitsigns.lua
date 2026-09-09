return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			signs = {
				add          = { text = "▎" },
				change       = { text = "▎" },
				delete       = { text = "" },
				topdelete    = { text = "" },
				changedelete = { text = "▎" },
				untracked    = { text = "▎" },
			},
			current_line_blame = false,
		})

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_next_hunk,
			function()
				require("gitsigns").next_hunk()
			end,
			{ desc = "Next git hunk" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_prev_hunk,
			function()
				require("gitsigns").prev_hunk()
			end,
			{ desc = "Prev git hunk" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_stage_hunk,
			function()
				require("gitsigns").stage_hunk()
			end,
			{ desc = "Stage hunk" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_reset_hunk,
			function()
				require("gitsigns").reset_hunk()
			end,
			{ desc = "Reset hunk" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_undo_stage_hunk,
			function()
				require("gitsigns").undo_stage_hunk()
			end,
			{ desc = "Undo stage hunk" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_stage_buffer,
			function()
				require("gitsigns").stage_buffer()
			end,
			{ desc = "Stage buffer" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_preview_hunk,
			function()
				require("gitsigns").preview_hunk()
			end,
			{ desc = "Preview hunk" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_blame_line,
			function()
				require("gitsigns").blame_line({ full = true })
			end,
			{ desc = "Blame line" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_diff_this,
			function()
				require("gitsigns").diffthis()
			end,
			{ desc = "Diff this file" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_git_status,
			function()
				require("telescope.builtin").git_status()
			end,
			{ desc = "Git status" }
		)

		vim.keymap.set(
			"n",
			vim.g.command_gitsigns_git_branches,
			function()
				require("telescope.builtin").git_branches()
			end,
			{ desc = "Git branches" }
		)
	end,
}
