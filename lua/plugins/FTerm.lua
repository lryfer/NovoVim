return {
	"numToStr/FTerm.nvim",
	config = function()
		local function hl_bg(name)
			return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "bg#") or "#1e1e1e"
		end

		local function hl_fg(name)
			return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "fg#") or "#ffffff"
		end

		local normal_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg#") or "#1e1e1e"
		local normal_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "fg#") or "#ffffff"

		local normal_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg#") or "#1e1e1e"
		local normal_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "fg#") or "#ffffff"
		local border_color = "#444444" -- just to see the line

		-- Uniform highlights
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg, fg = normal_fg })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = normal_bg, fg = border_color })

		require("FTerm").setup({
			border = "single", -- thin line
			dimensions = { height = 0.9, width = 0.9 },
			win_opts = {
				winblend = 0,
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
			},
		})

		vim.keymap.set("n", "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>')
		vim.keymap.set("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
	end,
}
