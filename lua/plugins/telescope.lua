return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      "<leader>ff",
      function() require('telescope.builtin').find_files() end,
      desc = "Find files"
    },
    {
      "<leader>fg",
      function() require('telescope.builtin').live_grep() end,
      desc = "Live grep"
    },
    {
      "<leader>fb",
      function() require('telescope.builtin').buffers() end,
      desc = "Find buffers"
    },
    {
      "<leader>fh",
      function() require('telescope.builtin').help_tags() end,
      desc = "Help tags"
    },
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup({
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
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          i = {
            ["<C-h>"] = "which_key",
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type=file" },
        },
      },
    })
  end,
}

