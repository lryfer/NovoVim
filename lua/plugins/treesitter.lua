return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        "c",
        "cpp",
        "rust",
        "lua",
        "markdown",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "yaml",
        "bash",
        "python",
        "vim",
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
