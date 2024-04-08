vim.g.mapleader = " "
vim.diagnostic.config({virtual_text=true})
vim.cmd[[set expandtab]]
vim.cmd[[set shiftwidth=2]]
vim.keymap.set('n', '<leader>tt', vim.cmd.Explore)
vim.keymap.set('n', '<leader>tl', vim.cmd.Lexplore)
    
    

