return {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    dependencies = {{ 'nvim-lua/plenary.nvim' } , {'BurntSushi/ripgrep'} , {'sharkdp/fd'}},
    config = function()
    require('telescope').setup{
        defaults = {
            vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            },
	    mappings = {
      		i = {
        	["<C-h>"] = "which_key",
      	    	}	
            }    
        },
        pickers = {
            find_files = {
                find_command = {"fd", "--type=file"},
            },
        },  
    }    
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end,

}
