return {
        'nvim-treesitter/nvim-treesitter',
        opts = {
          true
        },
        run = ':TSUpdate',
        event= "BufRead",
        config = function ()
        

        end,
}
