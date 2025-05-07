return{
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      {
        'tzachar/cmp-tabnine',
        build = './install.sh',
        dependencies = 'hrsh7th/nvim-cmp',
      },
      'rafamadriz/friendly-snippets',
    },
    opts = {
      sources = {
        {
          name = 'path',
          option = {
            trailing_slash = true,
          },
        },
      },
    },
    config = function()
    local cmp = require'cmp'

    cmp.setup({
      sources = {
        { name = 'nvim_lsp' }, 
        { name = 'buffer' },   
        { name = 'path' },     
        { name = 'luasnip' },   
      },
      completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged, cmp.TriggerEvent.InsertEnter },
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),   
        ['<C-p>'] = cmp.mapping.select_prev_item(),   
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),      
        ['<C-u>'] = cmp.mapping.scroll_docs(4),       
        ['<C-Space>'] = cmp.mapping.complete(),       
        ['<CR>'] = cmp.mapping.confirm({ select = true }),  
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),  
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),  
      },

      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)  
        end,
      },
    })

    local lspconfig = require('lspconfig')
    lspconfig.pyright.setup({
      on_attach = function(client, bufnr)
      end
    })

    end,
  }
