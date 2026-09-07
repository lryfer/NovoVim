local function lsp_shut()
	local cwd = vim.fn.getcwd()
	local stopped = 0

	for _, client in ipairs(vim.lsp.get_clients()) do
		local root_dir = client.config.root_dir

		if root_dir and vim.fs.normalize(root_dir) == vim.fs.normalize(cwd) then
			vim.lsp.stop_client(client.id)
			client_context[client.id] = nil
			stopped = stopped + 1
		end
	end

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) then
			local path = vim.api.nvim_buf_get_name(bufnr)

			if path ~= "" and vim.startswith(
				vim.fs.normalize(path),
				vim.fs.normalize(cwd) .. "/"
			) then
				vim.diagnostic.reset(nil, bufnr)
			end
		end
	end

	vim.notify(
		"[LSP] shut down " .. stopped .. " client(s) in " .. cwd,
		vim.log.levels.INFO
	)
end

vim.api.nvim_create_user_command("LspShut", lsp_shut, {
	desc = "Shut down LSP in the current directory",
})
