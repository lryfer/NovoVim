local CrLf_Module = {}

local function notify(msg, level)
	vim.notify("[crlf] " .. msg, level or vim.log.levels.INFO)
end

function CrLf_Module.strip()
	local current_buffer = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)
	local changed = 0
	for i, l in ipairs(lines) do
		local s = l:gsub("\r", "")
		if s ~= l then
			lines[i] = s
			changed = changed + 1
		end
	end
	if changed > 0 then
		vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, lines)
	end
	vim.bo[current_buffer].fileformat = "unix"
	if changed == 0 then
		notify("already LF nothing changed")
	else
		notify(string.format("removed \\r from %d line(s) -> fileformat=unix", changed))
	end
end

function CrLf_Module.add()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	-- This prevents if you save on windows you should avoid /r/r
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
	-- fileformat=dos allows Neovim to append \r\n without destroying buffer content
	vim.bo[bufnr].fileformat = "dos"
	notify(string.format("fileformat=dos -> %d line(s) will be written as CRLF on save", #lines))
end

vim.api.nvim_create_user_command("CrlfStripper", CrLf_Module.strip, { desc = "CRLF->LF: remove \\r from every line, fileformat=unix" })
vim.api.nvim_create_user_command("CrlfAdder",    CrLf_Module.add,   { desc = "LF->CRLF: set fileformat=dos, Neovim appends \\r on save" })

return CrLf_Module
