vim.g.mapleader = " "
vim.diagnostic.config({virtual_text=true})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.cmd[[set expandtab]]
vim.cmd[[set shiftwidth=2]]
vim.cmd[[set number]]

vim.keymap.set('n', '<leader>tt', vim.cmd.NvimTreeToggle)

    
    
