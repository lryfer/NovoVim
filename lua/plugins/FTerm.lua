return {
  {
    "numToStr/FTerm.nvim",
    config = function()
      local fterm = require("FTerm")

      local nvlib = require("novolib")

      local shell = nvlib.isOsWindows() and vim.g.windows_terminal or vim.g.posix_terminal

--      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e", fg = "#ffffff" })
--      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e1e", fg = "#444444" })

      fterm.setup({
        border = "single",
        dimensions = { height = 0.9, width = 0.9 },
        cmd = shell,
        win_opts = {
          winblend = 0,
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      })
        vim.keymap.set("n", vim.g.command_fterm_open, '<CMD>lua require("FTerm").toggle()<CR>')
      vim.keymap.set("t", vim.g.command_fterm_open, '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

      local command_output = fterm:new({
        border = "double",
        dimensions = { height = 0.8, width = 0.8 },
        cmd = shell,
      })

      _G.quick_command = function()
        vim.ui.input({ prompt = "Command: ", default = "" }, function(cmd)
          if not cmd or cmd == "" then
            return
          end

          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
          vim.api.nvim_set_option_value("filetype", "text", { buf = buf })

          local width = math.floor(vim.o.columns * 0.8)
          local height = math.floor(vim.o.lines * 0.8)
          local row = math.floor((vim.o.lines - height) / 2)
          local col = math.floor((vim.o.columns - width) / 2)

          vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            row = row,
            col = col,
            style = "minimal",
            border = "double",
          })

          vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Running: " .. cmd, "", "---", "" })

          local exec_cmd
          if nvlib.isOsWindows() then
            exec_cmd = { shell, "-NoProfile", "-Command", cmd }
          else

            exec_cmd = { shell, "-lc", cmd }
          end
          vim.fn.jobstart(exec_cmd, {
            stdout_buffered = false,
            stderr_buffered = false,
            on_stdout = function(_, data)
              if data then
                vim.schedule(function()
                  vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
                end)
              end
            end,
            on_stderr = function(_, data)
              if data then
                vim.schedule(function()
                  vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
                end)
              end
            end,
            on_exit = function(_, exit_code)
              vim.schedule(function()
                vim.api.nvim_buf_set_lines(buf, -1, -1, false,
                  { "", "---", "Exit code: " .. exit_code, "", "Press 'q' to close" })
              end)
            end,
          })

          vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
          vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true })
        end)
      end

      vim.keymap.set("n", vim.g.command_fterm_quickcommand, quick_command, { desc = "Quick command", silent = true })
    end,
  },
}
