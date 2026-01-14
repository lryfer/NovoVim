return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"rafamadriz/friendly-snippets",
		{
			"tzachar/cmp-tabnine",
			build = "./install.sh",
			enabled = false,
		},
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		-- Define icons and colors for different completion types
		local kind_icons = {
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "󰒓",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "󰕘",
			Module = "󰕳",
			Property = "󰓹",
			Unit = "󰑭",
			Value = "󰎠",
			Enum = "󰎦",
			Keyword = "󰌋",
			Snippet = "󰘍",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "󰜶",
			Constant = "󰏿",
			Struct = "󰙅",
			Event = "󰉁",
			Operator = "󰆕",
			TypeParameter = "󰅲",
		}

		local function safe(v, fallback)
			return (v == nil or v == "") and fallback or v
		end

		local function readable_fg(bg)
			if not bg or #bg < 7 then
				return "#000000"
			end
			local r = tonumber(bg:sub(2, 3), 16)
			local g = tonumber(bg:sub(4, 5), 16)
			local b = tonumber(bg:sub(6, 7), 16)
			local luminance = (0.299 * r + 0.587 * g + 0.114 * b)
			if luminance > 160 then
				return "#000000" -- sfondo chiaro → testo nero
			else
				return "#ffffff" -- sfondo scuro → testo bianco
			end
		end
		local FIXED_WIDTH = 12 -- larghezza totale del box

		local FIXED_WIDTH = 14 -- aumenta per fare spazio all'icona

		local function darken(color, percent)
			local r = tonumber(color:sub(2, 3), 16)
			local g = tonumber(color:sub(4, 5), 16)
			local b = tonumber(color:sub(6, 7), 16)

			r = math.floor(r * (1 - percent))
			g = math.floor(g * (1 - percent))
			b = math.floor(b * (1 - percent))

			return string.format("#%02x%02x%02x", r, g, b)
		end
		local function format_kind(entry, vim_item)
			local kind = vim_item.kind

			local icon = kind_icons[kind] or "?" -- icona
			local label = string.lower(kind) -- testo

			local content = icon .. " " .. label -- "󰊕 function"

			-- padding per larghezza uniforme
			local padding = FIXED_WIDTH - vim.fn.strdisplaywidth(content)
			if padding < 0 then
				padding = 0
			end
			local left = 1
			local right = padding - left

			vim_item.kind = string.rep(" ", left) .. content .. string.rep(" ", right)

			vim_item.kind_hl_group = "CmpItemKind" .. kind

			return vim_item
		end

		-- Setup formatting with icons and colors
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			view = {
				entries = {
					name = "custom",
					selection_order = "near_cursor",
				},
				docs = {
					auto_open = true,
				},
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-u>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			completion = {
				autocomplete = { require("cmp").TriggerEvent.TextChanged },
			},
			formatting = {
				format = format_kind,
				fields = { "kind", "abbr" },
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
			}),
			window = {
				completion = {
					border = "none",
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSelection,Search:None",
					col_offset = 0,
					side_padding = 1,
					scrollbar = true,
				},
				documentation = {
					border = "none",
					winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder",
					max_height = 10,
					max_width = 50,
				},
			},
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("cmp_highlights", { clear = true }),
			callback = function()
				local function hl_fg(name)
					return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "fg#")
				end

				local function hl_bg(name)
					return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "bg#")
				end

				local normal_bg = hl_bg("Normal") or "#1e1e1e"

				vim.api.nvim_set_hl(0, "CmpNormal", {
					bg = darken(normal_bg, 0.15), -- 15% più scuro
					fg = hl_fg("Normal") or "#ffffff",
				})

				local palette = {
					Text = hl_fg("Normal"),
					Method = hl_fg("Function"),
					Function = hl_fg("Function"),
					Constructor = hl_fg("Function"),
					Field = hl_fg("Identifier"),
					Variable = hl_fg("Identifier"),
					Class = hl_fg("Type"),
					Interface = hl_fg("Type"),
					Module = hl_fg("Type"),
					Property = hl_fg("Identifier"),
					Unit = hl_fg("Number"),
					Value = hl_fg("Number"),
					Enum = hl_fg("Type"),
					Keyword = hl_fg("Keyword"),
					Snippet = hl_fg("String"),
					Color = hl_fg("Special"),
					File = hl_fg("Directory"),
					Reference = hl_fg("Identifier"),
					Folder = hl_fg("Directory"),
					EnumMember = hl_fg("Constant"),
					Constant = hl_fg("Constant"),
					Struct = hl_fg("Type"),
					Event = hl_fg("Type"),
					Operator = hl_fg("Operator"),
					TypeParameter = hl_fg("Type"),
				}

				for k, v in pairs(palette) do
					if not v or v == "" then
						palette[k] = hl_fg("Normal") or "#cccccc"
					end
				end

				local function readable(bg)
					local r = tonumber(bg:sub(2, 3), 16)
					local g = tonumber(bg:sub(4, 5), 16)
					local b = tonumber(bg:sub(6, 7), 16)
					if (0.299 * r + 0.587 * g + 0.114 * b) > 140 then
						return "#000000"
					else
						return "#ffffff"
					end
				end

				-- crea highlight dinamici
				for kind, color in pairs(palette) do
					local fg = readable(color)

					vim.api.nvim_set_hl(0, "CmpItemKind" .. kind, {
						fg = fg,
						bg = color,
					})

					vim.api.nvim_set_hl(0, "CmpItemKind" .. kind .. "Selected", {
						fg = color,
						bg = fg,
						bold = true,
					})
				end

				-- riga selezionata CMP
				vim.api.nvim_set_hl(0, "CmpSelection", {
					bg = hl_bg("Visual") or "#444444",
				})
			end,
		})
		-- Setup cmp highlights with theme colors
		vim.cmd("doautocmd ColorScheme")
	end,
}
