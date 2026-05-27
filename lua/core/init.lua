require("core.options")
require("core.lazy")
require("core.diagnostic")

-- Import everything in automation_script folder
for _, file in ipairs(vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/automation_script", "*.lua", false, true)) do
	local mod = file:match(".+/lua/(.+)%.lua$"):gsub("/", ".")
	require(mod)
end
