-- Suppress deprecation warnings
local notify = vim.notify
vim.notify = function(msg, level, opts)
	if msg:match("is deprecated") then
		return
	end
	return notify(msg, level, opts)
end

require("core");
