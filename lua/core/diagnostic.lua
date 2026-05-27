-- Per-client context state: true = full LSP, false = minimal LSP
local client_context = {}

-- Project files that signal a real compilation context exists.
-- For clangd: only compile_commands.json / compile_flags.txt / .clangd count.
-- CMakeLists.txt and Makefile alone are NOT enough (Eclipse, partial setups, etc.)
local context_signals = {
	clangd = { "compile_commands.json", "compile_flags.txt", ".clangd" },
	pyright = { "requirements.txt", "pyproject.toml", "setup.py", "setup.cfg", ".venv", "venv" },
	rust_analyzer = { "Cargo.toml" },
	svelte = { "package.json" },
	html = {}, -- always full
	cssls = {}, -- always full
	lua_ls = {}, -- always full
}

local function has_compilation_context(root_dir, server_name)
	local signals = context_signals[server_name]
	if signals == nil then
		return true
	end -- unknown server: assume full
	if #signals == 0 then
		return true
	end -- server needs no context file

	for _, name in ipairs(signals) do
		local path = root_dir .. "/" .. name
		if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
			return true
		end
	end
	return false
end

-- Patterns that indicate the LSP failed to resolve external dependencies
local resolution_patterns = {
	"cannot be resolved",
	"import could not",
	"no module named",
	"cannot find module",
	"file not found",
	"module not found",
	"failed to resolve",
	"unable to resolve",
	"could not be imported",
	"unknown import",
	"unresolved import",
	"include file not found",
	"cannot open source file",
}

local function is_resolution_error(msg)
	local lower = msg:lower()
	for _, pat in ipairs(resolution_patterns) do
		if lower:find(pat, 1, true) then
			return true
		end
	end
	return false
end

-- Called from on_attach in mason-lspconfig.lua
local function register_client(client, root_dir)
	local ok = has_compilation_context(root_dir, client.name)
	client_context[client.id] = ok
	if not ok then
		vim.notify("[LSP] " .. client.name .. ": no context found — minimal diagnostics", vim.log.levels.INFO)
	end
end

-- Servers where ALL diagnostics are unreliable without proper context.
-- clangd without compile_commands.json produces cascade errors from missing
-- headers/flags — none of them can be trusted.
local full_suppress_without_context = { clangd = true }

-- Filter diagnostics when context is missing
local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
	if result and result.diagnostics then
		-- Lazy-register if LspAttach hasn't fired yet for this client
		if client_context[ctx.client_id] == nil then
			local c = vim.lsp.get_client_by_id(ctx.client_id)
			if c then
				register_client(c, c.config.root_dir or vim.fn.getcwd())
			end
		end
	end
	if result and result.diagnostics and client_context[ctx.client_id] == false then
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if client and full_suppress_without_context[client.name] then
			result.diagnostics = {}
		else
			local filtered = {}
			for _, d in ipairs(result.diagnostics) do
				if not is_resolution_error(d.message) then
					if #d.message > 80 then
						d.message = d.message:sub(1, 77) .. "..."
					end
					filtered[#filtered + 1] = d
				end
			end
			result.diagnostics = filtered
		end
	end
	orig_handler(err, result, ctx, config)
end

vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
		prefix = "",
	},
	signs = { severity = { min = vim.diagnostic.severity.HINT } },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

local function toggle_diagnostics()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		vim.notify("[LSP] no clients attached to this buffer", vim.log.levels.WARN)
		return
	end

	for _, client in ipairs(clients) do
		local current = client_context[client.id]
		if current == nil then
			current = true
		end
		client_context[client.id] = not current
	end

	-- Clear existing diagnostics; next LSP push will apply the new state
	vim.diagnostic.reset(nil, bufnr)

	local new_state = client_context[clients[1].id]
	vim.notify("[LSP] diagnostics " .. (new_state and "FULL" or "MINIMAL"), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("LspToggle", toggle_diagnostics, { desc = "Toggle LSP diagnostics (full/minimal)" })

vim.keymap.set("n", "<leader>ld", "<cmd>LspToggle<cr>", { desc = "Toggle LSP diagnostics (full/minimal)" })

return {
	register_client = register_client,
	toggle_diagnostics = toggle_diagnostics,
}
