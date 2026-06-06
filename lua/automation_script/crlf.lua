-- :CrlfStripper — remove \r from every line (CRLF -> LF), set fileformat=unix
-- :CrlfAdder    — clean residual \r and set fileformat=dos (Neovim appends \r on save)

local M = {}

local function notify(msg, level)
	vim.notify("[crlf] " .. msg, level or vim.log.levels.INFO)
end

function M.strip()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local changed = 0
	for i, l in ipairs(lines) do
		local s = l:gsub("\r", "")
		if s ~= l then
			lines[i] = s
			changed = changed + 1
		end
	end
	if changed > 0 then
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	end
	vim.bo[bufnr].fileformat = "unix"
	if changed == 0 then
		notify("already LF — nothing changed")
	else
		notify(string.format("removed \\r from %d line(s) -> fileformat=unix", changed))
	end
end

function M.add()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	-- strip any \r already in buffer content to avoid \r\r on save
	local cleaned = 0
	for i, l in ipairs(lines) do
		local s = l:gsub("\r", "")
		if s ~= l then
			lines[i] = s
			cleaned = cleaned + 1
		end
	end
	if cleaned > 0 then
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	end
	-- fileformat=dos lets Neovim append \r\n on write without polluting buffer content
	vim.bo[bufnr].fileformat = "dos"
	notify(string.format("fileformat=dos -> %d line(s) will be written as CRLF on save", #lines))
end

vim.api.nvim_create_user_command("CrlfStripper", M.strip, { desc = "CRLF->LF: remove \\r from every line, fileformat=unix" })
vim.api.nvim_create_user_command("CrlfAdder",    M.add,   { desc = "LF->CRLF: set fileformat=dos, Neovim appends \\r on save" })

return M
