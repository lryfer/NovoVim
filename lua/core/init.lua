require("core.options")
require("core.lazy")
require("core.diagnostic")

-- Import everything in custom_utility folder
for _, file in ipairs(vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/custom_utility", "*.lua", false, true)) do
	local mod = file:match(".+/lua/(.+)%.lua$"):gsub("/", ".")
	require(mod)
end
