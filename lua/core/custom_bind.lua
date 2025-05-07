vim.g.mapleader = " "
vim.diagnostic.config({virtual_text=true})

local function diagnostic()
vim.diagnostic.get(0, { severity = {
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
} })
end;

-- all the global nvim option should be here 
vim.encoding= "utf-8"
vim.fileencoding= "utf-8"
vim.scriptencording = "utf-8"
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
vim.showcmd = true
vim.opt.scrolloff = 10
vim.opt.cmdheight = 0
vim.opt.inccommand = "split"
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.wrap = true
vim.opt.backspace = {"start", "eol", "indent"}
vim.opt.path:append{"**"}
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "cursor"
-- can lead to sanity problems, skill issue
vim.opt.mouse = ""
vim.keymap.set('n', '<leader>tt', vim.cmd.NvimTreeToggle)

