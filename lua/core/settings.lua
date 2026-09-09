-- this is the file is intended to edit to do changes
-- all the file specified should not be configured by hand
-- all the config values that people normally touch should be here


-- Section list of this file you can search:
-- 0.0 Neovim global settings
-- 0.1 Neovide global settings
-- 0.2 NovoVim parameters :
-- 0.3 NovoVim terminal
-- 0.4 NovoVim icons
-- 0.5 NovoVim Lsp
-- 0.6 NovoVim Custom Command



-- 0.0 Neovim global settings
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


-- 0.1 Neovide global settings
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
vim.g.rust_language_server = "rust_analyzer"
vim.g.javascript_language_server = "ts_ls"
vim.g.html_language_server = "html"
vim.g.css_language_server = "cssls"

-- 0.6 NovoVim Custom Command
vim.g.command_nvim_tree_toggle = "<leader>tt"
vim.g.command_fterm_quickcommand = "<leader>xo"
vim.g.command_fterm_open = "<A-i>"
vim.g.command_conform_format_buffer = "<leader>cf"
vim.g.command_telescope_find_file = "<C-f>"
vim.g.command_telescope_live_grep = "<C-g>"
vim.g.command_telescope_find_buffer = "<C-b>"
vim.g.command_telescope_help_tags = "<C-h>"
vim.g.command_telescope_notify = "<C-n>"
vim.g.command_telescope_git_diff = "<leader>gd"
vim.g.command_telescope_git_commits = "<leader>gc"
vim.g.command_telescope_git_branches = "<leader>gb"
vim.g.command_telescope_git_stash = "<leader>gs"
vim.g.command_gitsigns_next_hunk = "]h"
vim.g.command_gitsigns_prev_hunk = "[h"
vim.g.command_gitsigns_stage_hunk = "<leader>hs"
vim.g.command_gitsigns_reset_hunk = "<leader>hr"
vim.g.command_gitsigns_undo_stage_hunk = "<leader>hu"
vim.g.command_gitsigns_stage_buffer = "<leader>hS"
vim.g.command_gitsigns_preview_hunk = "<leader>hp"
vim.g.command_gitsigns_blame_line = "<leader>hb"
vim.g.command_gitsigns_diff_this = "<leader>hd"
vim.g.command_gitsigns_git_status = "<leader>gs"
vim.g.command_gitsigns_git_branches = "<leader>gb"
vim.g.command_lsp_hover = "K"
vim.g.command_lsp_definition = "gd"
vim.g.command_lsp_declaration = "gD"
vim.g.command_lsp_implementation = "gi"
vim.g.command_lsp_references = "gr"
vim.g.command_lsp_type_definition = "gt"
vim.g.command_lsp_code_action = "<leader>ca"
vim.g.command_lsp_rename = "<leader>rn"
vim.g.command_lsp_signature_help = "<leader>sh"
vim.g.command_lsp_diagnostic_prev = "[d"
vim.g.command_lsp_diagnostic_next = "]d"
vim.g.command_lsp_diagnostic_float = "<leader>e"
vim.g.command_lsp_diagnostic_loclist = "<leader>q"
vim.g.command_cmp_select_next = "<C-n>"
vim.g.command_cmp_select_prev = "<C-p>"
vim.g.command_cmp_scroll_docs_down = "<C-d>"
vim.g.command_cmp_scroll_docs_up = "<C-u>"
vim.g.command_cmp_complete = "<C-Space>"
vim.g.command_cmp_confirm = "<CR>"
vim.g.command_cmp_next_or_fallback = "<Tab>"
vim.g.command_cmp_prev_or_fallback = "<S-Tab>"
vim.g.command_refactoring_extract_function = "<leader>re"
vim.g.command_refactoring_extract_to_file = "<leader>rf"
vim.g.command_refactoring_extract_variable = "<leader>rv"
vim.g.command_refactoring_inline_variable = "<leader>ri"
vim.g.command_refactoring_inline_function = "<leader>rI"
vim.g.command_refactoring_extract_block = "<leader>rb"
vim.g.command_refactoring_extract_block_to_file = "<leader>rbf"
vim.g.command_lspsignature_togglekey = "<C-k>"
vim.g.command_trouble_diagnostics = "<leader>xx"
vim.g.command_trouble_buffer_diagnostics = "<leader>xX"
vim.g.command_trouble_symbols = "<leader>cs"
vim.g.command_trouble_lsp = "<leader>cl"
vim.g.command_trouble_loclist = "<leader>xL"
vim.g.command_trouble_qflist = "<leader>xQ"










