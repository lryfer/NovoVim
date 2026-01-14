-- Global diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
})

-- Utility function to display diagnostics
local function show_diagnostics()
  local diagnostics = vim.diagnostic.get(0, {
    severity = {
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.INFO,
    },
  })
  print(vim.inspect(diagnostics))
end

return {
  show_diagnostics = show_diagnostics,
}
