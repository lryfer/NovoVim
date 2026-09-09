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
for _, file in ipairs(vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/tools", "*.lua", false, true)) do
	local mod = file:match(".+/lua/(.+)%.lua$"):gsub("/", ".")
	require(mod)
end
