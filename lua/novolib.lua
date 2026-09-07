--
--
-- NovoLib, internal library to handle stuff
--
-- Author: lryfer, made with passion, no ai is involved in config

local NovoLib_Module = {}

function NovoLib_Module.isOsWindows()
  local ret = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1)
  -- Additional check, might be useless
  ret = (vim.env.WSL_DISTRO_NAME == nil and ret)
  return ret
end

function NovoLib_Module.getColorFromTheme(...)
	for _, group in ipairs({ ... }) do
		local hl = vim.api.nvim_get_hl(0, {
			name = group,
			link = false,
		})
		if hl.fg then
			return string.format("#%06x", hl.fg)
		end
	end
	return nil
end

return NovoLib_Module

