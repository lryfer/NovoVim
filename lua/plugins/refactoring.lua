return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup({})

			vim.keymap.set(
				"x",
				vim.g.command_refactoring_extract_function,
				":Refactor extract ",
				{ desc = "Extract function" }
			)

			vim.keymap.set(
				"x",
				vim.g.command_refactoring_extract_to_file,
				":Refactor extract_to_file ",
				{ desc = "Extract to file" }
			)

			vim.keymap.set(
				"x",
				vim.g.command_refactoring_extract_variable,
				":Refactor extract_var ",
				{ desc = "Extract variable" }
			)

			vim.keymap.set(
				{ "n", "x" },
				vim.g.command_refactoring_inline_variable,
				":Refactor inline_var",
				{ desc = "Inline variable" }
			)

			vim.keymap.set(
				"n",
				vim.g.command_refactoring_inline_function,
				":Refactor inline_func",
				{ desc = "Inline function" }
			)

			vim.keymap.set(
				"n",
				vim.g.command_refactoring_extract_block,
				":Refactor extract_block",
				{ desc = "Extract block" }
			)

			vim.keymap.set(
				"n",
				vim.g.command_refactoring_extract_block_to_file,
				":Refactor extract_block_to_file",
				{ desc = "Extract block to file" }
			)
		end,
	},
}
