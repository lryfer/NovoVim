-- :EmbeddedServer <cmd>  — start a GDB server in a floating terminal.
-- A second call closes the previous terminal before opening a new one.
-- Examples:
--   :EmbeddedServer openocd -f board/st_nucleo_f4.cfg
--   :EmbeddedServer JLinkGDBServer -device STM32F4 -if SWD -speed 4000

local term_buf = nil
local term_win = nil

local function close_existing()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
	end
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.api.nvim_buf_delete(term_buf, { force = true })
	end
	term_buf = nil
	term_win = nil
end

local function open_server(cmd_args)
	close_existing()

	local width  = math.floor(vim.o.columns * 0.7)
	local height = math.floor(vim.o.lines * 0.3)
	local row    = math.floor((vim.o.lines - height) / 2)
	local col    = math.floor((vim.o.columns - width) / 2)

	term_buf = vim.api.nvim_create_buf(false, true)
	term_win = vim.api.nvim_open_win(term_buf, true, {
		relative = "editor",
		width    = width,
		height   = height,
		row      = row,
		col      = col,
		style    = "minimal",
		border   = "rounded",
		title    = " GDB Server ",
		title_pos = "center",
	})

	local shell_cmd = table.concat(cmd_args, " ")
	vim.fn.termopen(shell_cmd, {
		on_exit = function(_, code)
			vim.schedule(function()
				vim.notify(
					"[EmbeddedServer] process exited (code " .. code .. ")",
					code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
				)
			end)
		end,
	})

	-- Return to normal window so the user can keep editing
	vim.cmd("wincmd p")
	vim.notify("[EmbeddedServer] started: " .. shell_cmd, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("EmbeddedServer", function(opts)
	if opts.args == "" then
		vim.notify("[EmbeddedServer] usage: :EmbeddedServer <command>", vim.log.levels.WARN)
		return
	end
	open_server(vim.split(opts.args, " ", { plain = true, trimempty = true }))
end, {
	nargs = "+",
	desc  = "Start a GDB server in a floating terminal (:EmbeddedServer openocd -f ...)",
})

vim.api.nvim_create_user_command("EmbeddedServerClose", close_existing, {
	desc = "Close the GDB server terminal",
})
