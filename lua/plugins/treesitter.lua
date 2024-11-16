return {
        'nvim-treesitter/nvim-treesitter',
        opts = {
          true
        },
        run = ':TSUpdate',
        event = "BufRead",
        config = function()
        require'nvim-treesitter.configs'.setup {
        ensure_installed = {"c", "cpp", "rust", "lua", "markdown"},
        auto_install = true,
        highlight = {
          enable = true,
        },
      }
    end,
}

