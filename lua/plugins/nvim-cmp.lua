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

		local kind_icons = {
			Text = vim.g.nvim_cmp_Icon_Text,
			Method = vim.g.nvim_cmp_Icon_Method,
			Function = vim.g.nvim_cmp_Icon_Function,
			Constructor = vim.g.nvim_cmp_Icon_Constructor,
			Field = vim.g.nvim_cmp_Icon_Field,
			Variable = vim.g.nvim_cmp_Icon_Variable,
			Class = vim.g.nvim_cmp_Icon_Class,
			Interface = vim.g.nvim_cmp_Icon_Interface,
			Module = vim.g.nvim_cmp_Icon_Module,
			Property = vim.g.nvim_cmp_Icon_Property,
			Unit = vim.g.nvim_cmp_Icon_Unit,
			Value = vim.g.nvim_cmp_Icon_Value,
			Enum = vim.g.nvim_cmp_Icon_Enum,
			Keyword = vim.g.nvim_cmp_Icon_Keyword,
			Snippet = vim.g.nvim_cmp_Icon_Snippet,
			Color = vim.g.nvim_cmp_Icon_Color,
			File = vim.g.nvim_cmp_Icon_File,
			Reference = vim.g.nvim_cmp_Icon_Reference,
			Folder = vim.g.nvim_cmp_Icon_Folder,
			EnumMember = vim.g.nvim_cmp_Icon_EnumMember,
			Constant = vim.g.nvim_cmp_Icon_Constant,
			Struct = vim.g.nvim_cmp_Icon_Struct,
			Event = vim.g.nvim_cmp_Icon_Event,
			Operator = vim.g.nvim_cmp_Icon_Operator,
			TypeParameter = vim.g.nvim_cmp_Icon_TypeParameter,
		}

		local FIXED_WIDTH = 14

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
			local icon = kind_icons[kind] or "?"
			local label = string.lower(kind)
			local content = icon .. " " .. label
			local padding = FIXED_WIDTH - vim.fn.strdisplaywidth(content)

			if padding < 0 then
				padding = 0
			end

			local left = 1
			local right = padding - left

			vim_item.kind =
				string.rep(" ", left)
				.. content
				.. string.rep(" ", right)

			vim_item.kind_hl_group = "CmpItemKind" .. kind

			return vim_item
		end

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
				[vim.g.command_cmp_select_next] =
					cmp.mapping.select_next_item(),

				[vim.g.command_cmp_select_prev] =
					cmp.mapping.select_prev_item(),

				[vim.g.command_cmp_scroll_docs_down] =
					cmp.mapping.scroll_docs(-4),

				[vim.g.command_cmp_scroll_docs_up] =
					cmp.mapping.scroll_docs(4),

				[vim.g.command_cmp_complete] =
					cmp.mapping.complete(),

				[vim.g.command_cmp_confirm] =
					cmp.mapping.confirm({ select = true }),

				[vim.g.command_cmp_next_or_fallback] =
					cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),

				[vim.g.command_cmp_prev_or_fallback] =
					cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
			}),

			completion = {
				autocomplete = {
					cmp.TriggerEvent.TextChanged,
				},
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
					winhighlight =
						"Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSelection,Search:None",
					col_offset = 0,
					side_padding = 1,
					scrollbar = true,
				},

				documentation = {
					border = "none",
					winhighlight =
						"Normal:CmpNormal,FloatBorder:CmpBorder",
					max_height = 10,
					max_width = 50,
				},
			},
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup(
				"cmp_highlights",
				{ clear = true }
			),

			callback = function()
				local function hl_fg(name)
					return vim.fn.synIDattr(
						vim.fn.synIDtrans(vim.fn.hlID(name)),
						"fg#"
					)
				end

				local function hl_bg(name)
					return vim.fn.synIDattr(
						vim.fn.synIDtrans(vim.fn.hlID(name)),
						"bg#"
					)
				end

				local normal_bg = hl_bg("Normal") or "#1e1e1e"

				vim.api.nvim_set_hl(0, "CmpNormal", {
					bg = darken(normal_bg, 0.15),
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

				for kind, color in pairs(palette) do
					local fg = readable(color)

					vim.api.nvim_set_hl(0, "CmpItemKind" .. kind, {
						fg = fg,
						bg = color,
					})

					vim.api.nvim_set_hl(
						0,
						"CmpItemKind" .. kind .. "Selected",
						{
							fg = color,
							bg = fg,
							bold = true,
						}
					)
				end

				vim.api.nvim_set_hl(0, "CmpSelection", {
					bg = hl_bg("Visual") or "#444444",
				})
			end,
		})

		vim.cmd("doautocmd ColorScheme")
	end,
}

