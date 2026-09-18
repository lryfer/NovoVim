require("core.settings")
require("core.lazy")

-- todo find a better place 
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
	underline = true,
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
	underline = true,
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
	underline = true,
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
	underline = true,
})

vim.diagnostic.config({
-- add somewhere the keybind to activate this
	virtual_text = false,
	underline = true,
	float = {
		border = "rounded",
		focusable = true,
	},
})

-- Import everything in custom_utility folder
local lua_dir = vim.fn.stdpath("config") .. "/lua/tools"
for _, file in ipairs(vim.fn.globpath(lua_dir, "**/*.lua", false, true)) do
	local relative = file:sub(#lua_dir + 2)
	local module = relative:gsub("[/\\]", "."):gsub("%.lua$", "")
	require("tools." .. module)
end

