require("core.settings")
require("core.lazy")

-- Import everything in custom_utility folder
for _, file in ipairs(vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/tools", "*.lua", false, true)) do
	local mod = file:match(".+/lua/(.+)%.lua$"):gsub("/", ".")
	require(mod)
end
