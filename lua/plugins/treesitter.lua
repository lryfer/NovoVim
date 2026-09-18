return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },

  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = vim.g.treesitter_language_ensure_installed,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = false },
  },
	config = function(_, opts)
    local get_node_text = vim.treesitter.get_node_text
    vim.treesitter.get_node_text = function(node, ...)
      if not node or not node.range then
        return ""
      end
      return get_node_text(node, ...)
    end

    require("nvim-treesitter").setup(opts)
	end,
}
