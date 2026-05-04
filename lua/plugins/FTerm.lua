return {
  {
    "numToStr/FTerm.nvim",
    config = function()
      local fterm = require("FTerm")

      local function hl_bg(name)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "bg#") or "#1e1e1e"
      end

      local function hl_fg(name)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "fg#") or "#ffffff"
      end

      local normal_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg#") or "#1e1e1e"
      local normal_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "fg#") or "#ffffff"
      local border_color = "#444444"

      vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg, fg = normal_fg })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = normal_bg, fg = border_color })

      fterm.setup({
        border = "single",
        dimensions = { height = 0.9, width = 0.9 },
        win_opts = {
          winblend = 0,
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      })

      vim.keymap.set("n", "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>')
      vim.keymap.set("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

      local command_output = fterm:new({
        border = "double",
        dimensions = { height = 0.8, width = 0.8 },
        cmd = "bash",
      })

      _G.quick_command = function()
        vim.ui.input({ prompt = "Command: ", default = "" }, function(cmd)
          if not cmd or cmd == "" then
            return
          end

          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
          vim.api.nvim_buf_set_option(buf, "filetype", "bash")

          local width = math.floor(vim.o.columns * 0.8)
          local height = math.floor(vim.o.lines * 0.8)
          local row = math.floor((vim.o.lines - height) / 2)
          local col = math.floor((vim.o.columns - width) / 2)

          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            row = row,
            col = col,
            style = "minimal",
            border = "double",
          })

          vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Running: " .. cmd, "", "---", "" })

          vim.fn.jobstart(cmd, {
            stdout_buffered = false,
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
                vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "---", "Exit code: " .. exit_code, "", "Press 'q' to close" })
              end)
            end,
          })

          vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
        end)
      end

      vim.keymap.set("n", "<leader>x", ":lua quick_command()<CR>", { desc = "Quick command", silent = true })
    end,
  },
}
