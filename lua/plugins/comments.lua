return {
  {
    "numToStr/Comment.nvim",
    opts = {},
    config = function(_, opts)
      require("Comment").setup(opts)

      vim.keymap.set("n", vim.g.command_comment_toggle_comment, "gcc", {
        remap = true,
        desc = "Toggle comment",
      })

      vim.keymap.set("v", vim.g.command_comment_toggle_comment, "gc", {
        remap = true,
        desc = "Toggle comment",
      })
    end,
  },
}
