local M = {}
local _langs

local function langs()
	if not _langs then _langs = require("languages.language_configurations") end
	return _langs
end

function M.lsp_server_names()
	local names = {}
	for _, lang in ipairs(langs()) do
		if lang.lsp then names[#names + 1] = lang.lsp end
	end
	return names
end

function M.lsp_servers()
	local servers = {}
	for _, lang in ipairs(langs()) do
		if lang.lsp then
			servers[lang.lsp] = lang.lsp_opts or {}
		end
	end
	return servers
end

function M.mason_tools()
	local seen, tools = {}, {}
	for _, lang in ipairs(langs()) do
		for _, tool in ipairs(lang.mason or {}) do
			if not seen[tool] then
				seen[tool] = true
				tools[#tools + 1] = tool
			end
		end
	end
	return tools
end

function M.conform_formatters()
	local fmts = {}
	for _, lang in ipairs(langs()) do
		for ft, formatters in pairs(lang.fmt or {}) do
			fmts[ft] = formatters
		end
	end
	return fmts
end

function M.dap_tools()
	local seen, tools = {}, {}
	for _, lang in ipairs(langs()) do
		for _, tool in ipairs(lang.dap or {}) do
			if not seen[tool] then
				seen[tool] = true
				tools[#tools + 1] = tool
			end
		end
	end
	return tools
end

-- Returns { filetype = { configs... } }
-- "typescript" = "javascript" means copy the javascript configs
function M.dap_configs()
	local all = {}
	for _, lang in ipairs(langs()) do
		for ft, cfgs in pairs(lang.dap_configs or {}) do
			all[ft] = all[ft] or {}
			vim.list_extend(all[ft], cfgs)
		end
	end
	-- resolve string aliases (e.g. typescript = "javascript")
	for ft, cfgs in pairs(all) do
		if type(cfgs) == "string" then
			all[ft] = all[cfgs] or {}
		end
	end
	-- cpp inherits c if not explicitly defined
	if all["c"] and not all["cpp"] then
		all["cpp"] = all["c"]
	end
	return all
end

function M.treesitter_parsers()
	local seen, parsers = {}, {}
	for _, lang in ipairs(langs()) do
		for _, parser in ipairs(lang.ts or {}) do
			if not seen[parser] then
				seen[parser] = true
				parsers[#parsers + 1] = parser
			end
		end
	end
	return parsers
end

return M
