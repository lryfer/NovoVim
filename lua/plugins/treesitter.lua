return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local get_node_text = vim.treesitter.get_node_text
		vim.treesitter.get_node_text = function(node, ...)
			if not node or not node.range then return "" end
			return get_node_text(node, ...)
		end

		local loader = require("lang.loader")

		require("nvim-treesitter.configs").setup({
			ensure_installed = loader.treesitter_parsers(),
			auto_install     = true,
			highlight = { enable = true },
			indent    = { enable = false },
		})
	end,
}
