vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 10
vim.opt.cmdheight = 0
vim.opt.inccommand = "split"
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.wrap = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = "a"
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })

-- Use system clipboard for yank operations
vim.opt.clipboard = "unnamedplus"

-- Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
