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

		-- Navigation
		vim.keymap.set("n", "]h", function() require("gitsigns").next_hunk() end,  { desc = "Next git hunk" })
		vim.keymap.set("n", "[h", function() require("gitsigns").prev_hunk() end,  { desc = "Prev git hunk" })

		-- Actions
		vim.keymap.set("n", "<leader>hs", function() require("gitsigns").stage_hunk() end,   { desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>hr", function() require("gitsigns").reset_hunk() end,   { desc = "Reset hunk" })
		vim.keymap.set("n", "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Undo stage hunk" })
		vim.keymap.set("n", "<leader>hS", function() require("gitsigns").stage_buffer() end, { desc = "Stage buffer" })
		vim.keymap.set("n", "<leader>hp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
		vim.keymap.set("n", "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
		vim.keymap.set("n", "<leader>hd", function() require("gitsigns").diffthis() end,     { desc = "Diff this file" })

		-- Git status panel via Telescope (staged + unstaged + untracked)
		vim.keymap.set("n", "<leader>gs", function()
			require("telescope.builtin").git_status()
		end, { desc = "Git status" })

		vim.keymap.set("n", "<leader>gb", function()
			require("telescope.builtin").git_branches()
		end, { desc = "Git branches" })
	end,
}
