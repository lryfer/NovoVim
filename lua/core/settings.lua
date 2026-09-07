-- this is the file is intended to edit to do changes
-- all the file specified should not be configured by hand
-- all the config values that people normally touch should be here


-- Section list of this file you can search:
-- 0.0 nvim global settings
-- 0.1 neovide global settings
-- 0.2 NovoVim parameters :
-- 0.3 NovoVim terminal
-- 0.4 NovoVim icons
-- 0.5 NovoVim Lsp

vim.g.c_language_server = "clangd"
vim.g.lua_language_server = "lua_ls"

-- 06 NovoVim Custom Command






-- 0.0 nvim global settings
-- Leader key modifier
vim.g.mapleader = " "

-- Disable the old newtr file manager plugin
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Show line number
vim.opt.number = true

-- Update Console title based on what file you have open
vim.opt.title = true

-- Enables 24‑bit truecolor
vim.opt.termguicolors = true

-- Use spaces instead of tablatures
vim.opt.expandtab = true

-- Indentation width
vim.opt.shiftwidth = 2
-- Tab width
vim.opt.tabstop = 2

-- Maintain indentation of the line (tip: don't turn this off)
vim.opt.autoindent = true

-- This setting makes autoindent smarter
vim.opt.smartindent = true

-- Hilight what you are searching
vim.opt.hlsearch = true

-- Mantain N lines from the cursor both up and down
vim.opt.scrolloff = 10


-- Keep N columns visible to the left and right of the cursor
vim.opt.sidescrolloff = 8

-- Line you see under cmd
vim.opt.cmdheight = 0

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- https://neovim.io/doc/user/options/
-- When nonempty, shows the effects of :substitute
vim.opt.inccommand = "split"

-- allows to search without case sensitivity if enabled
vim.opt.ignorecase = true
-- even if ignorecase is enabled filter result based on accuaracy
vim.opt.smartcase = true

-- Try to be more smart when you are in the start of a line adding more spaces
-- to match indentation
vim.opt.smarttab = true

-- Divide long lines in more lines
vim.opt.wrap = true

-- Preserve indentation when wrapping long lines
vim.opt.breakindent = true

-- Wrap lines at word boundaries
vim.opt.linebreak = true

-- Force vertical split on the right window
vim.opt.splitright = true
-- Force split below window
vim.opt.splitbelow = true

-- Don't change cursor position while splitting
vim.opt.splitkeep = "cursor"

-- Enable mouse 
vim.opt.mouse = "a"

-- https://neovim.io/doc/user/options/#'backspace'
vim.opt.backspace = { "start", "eol", "indent" }

-- Enable nvim to search recursively
vim.opt.path:append({ "**" })

-- copy on system clipboard
vim.opt.clipboard = "unnamedplus"

-- use utf-8 encoding for files
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Limit the number of completion items shown
vim.opt.pumheight = 10

-- Configure the completion menu behavior
vim.opt.completeopt = { "menu", "menuone", "noselect" }


-- 0.1 neovide global settings
if vim.g.neovide then
  vim.o.guifont = "Iosevka Nerd Font Mono:14"
  vim.g.neovide_title_background_color = string.format(
    "%x",
    vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name("Normal")}).bg
)
vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0.02
vim.g.neovide_cursor_trail_size = 0.02
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.1

-- Ctrl+Shift+V for system clipboard
vim.keymap.set("i", "<C-S-v>", "<C-r>+", { desc = "Paste system clipboard" })
vim.keymap.set("c", "<C-S-v>", "<C-r>+", { desc = "Paste system clipboard" })
vim.keymap.set("t", "<C-S-v>", [[<C-\><C-n>"+pi]], { desc = "Paste system clipboard" })
end


-- 0.2 NovoVim parameters :

-- 0.3 NovoVim terminal
-- Terminal to use under windows settings
vim.g.windows_terminal = "pwsh"

-- Terminal to use under posix systems (es. freebsd, linux distros, macos)
vim.g.posix_terminal = "bash"


-- 0.4 NovoVim icons

vim.g.Mason_Icon_package_installed   = "I"
vim.g.Mason_Icon_package_pending     = "P"
vim.g.Mason_Icon_package_package_uninstalled = "R"
vim.g.nvim_cmp_Icon_Text = "󰉿"
vim.g.nvim_cmp_Icon_Method = "󰆧"
vim.g.nvim_cmp_Icon_Function = "󰊕"
vim.g.nvim_cmp_Icon_Constructor = "󰒓"
vim.g.nvim_cmp_Icon_Field = "󰜢"
vim.g.nvim_cmp_Icon_Variable = "󰀫"
vim.g.nvim_cmp_Icon_Class = "󰠱"
vim.g.nvim_cmp_Icon_Interface = "󰕘"
vim.g.nvim_cmp_Icon_Module = "󰕳"
vim.g.nvim_cmp_Icon_Property = "󰓹"
vim.g.nvim_cmp_Icon_Unit = "󰑭"
vim.g.nvim_cmp_Icon_Value = "󰎠"
vim.g.nvim_cmp_Icon_Enum = "󰎦"
vim.g.nvim_cmp_Icon_Keyword = "󰌋"
vim.g.nvim_cmp_Icon_Snippet = "󰘍"
vim.g.nvim_cmp_Icon_Color = "󰏘"
vim.g.nvim_cmp_Icon_File = "󰈙"
vim.g.nvim_cmp_Icon_Reference = "󰈇"
vim.g.nvim_cmp_Icon_Folder = "󰉋"
vim.g.nvim_cmp_Icon_EnumMember = "󰜶"
vim.g.nvim_cmp_Icon_Constant = "󰏿"
vim.g.nvim_cmp_Icon_Struct = "󰙅"
vim.g.nvim_cmp_Icon_Event = "󰉁"
vim.g.nvim_cmp_Icon_Operator = "󰆕"
vim.g.nvim_cmp_Icon_TypeParameter = "󰅲"

-- 0.5 NovoVim Lsp

vim.g.c_language_server = "clangd"
vim.g.lua_language_server = "lua_ls"

-- 06 NovoVim Custom Command








