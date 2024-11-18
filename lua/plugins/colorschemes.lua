return{
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
  },
  config = function()
    vim.o.background = "dark" 
    vim.cmd([[colorscheme kanagawa]])
  end,
}

