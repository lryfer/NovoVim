return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	keys = {
		{
			"<leader>ff",
			function()
				local ok = pcall(require("telescope.builtin").git_files, { show_untracked = true })
				if not ok then
					require("telescope.builtin").find_files()
				end
			end,
			desc = "Find files",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Live grep",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Help tags",
		},
		{
			"<leader>fn",
			function()
				require("telescope").extensions.notify.notify()
			end,
			desc = "Notification history",
		},
		-- Git commands
		{
			"<leader>gd",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "Git diff (changed files)",
		},
		{
			"<leader>gc",
			function()
				require("telescope.builtin").git_commits()
			end,
			desc = "Git commits",
		},
		{
			"<leader>gb",
			function()
				require("telescope.builtin").git_branches()
			end,
			desc = "Git branches",
		},
		{
			"<leader>gs",
			function()
				require("telescope.builtin").git_stash()
			end,
			desc = "Git stash",
		},
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--max-columns=150",
					"--max-columns-preview",
					"--max-filesize=300K",
					"--threads=6",
          "--glob=!**/.git/*",
					"--glob=!**/target/*",
					"--glob=!**/node_modules/*",
					"--glob=!**/.metadata/*",
					"--glob=!**/.settings/*",
					"--glob=!**/bin/*",
					"--glob=!**/dist/*",
					"--glob=!**/.cache/*",
					"--glob=!**/Debug/*",
					"--glob=!**/Release/*",
					"--glob=!**/*.o",
					"--glob=!**/*.d",
					"--glob=!**/*.elf",
					"--glob=!**/*.hex",
					"--glob=!**/*.map",
					"--glob=!**/*.lst",
					"--glob=!**/*.axf",
					"--glob=!*.min.js",
					"--glob=!*.min.css",
					"--glob=!*.lock",
					"--glob=!*.png",
					"--glob=!*.jpg",
					"--glob=!*.jpeg",
					"--glob=!*.gif",
					"--glob=!*.svg",
					"--glob=!*.pdf",
					"--glob=!*.zip",
					"--glob=!*.jar",
					"--glob=!*.class",
				},
				file_ignore_patterns = {
					"%.git/",
					"node_modules/",
					"target/",
					"build/",
					"bin/",
					"%.metadata/",
					"%.settings/",
					"%.classpath",
					"%.project",
					"Debug/",
					"Release/",
					"%.o$",
					"%.d$",
					"%.elf$",
					"%.hex$",
					"%.map$",
					"%.lst$",
					"%.axf$",
				},
				path_display = { "truncate" },
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					width = 0.87,
					height = 0.80,
				},
				preview = {
					filesize_limit = 0.3, -- MB: non preview file sopra 300KB
					timeout = 200,        -- ms: abbandona preview lenti
				},
				cache_picker = {
					num_pickers = 5,
					limit_entries = 300,
				},
				mappings = {
					i = {
						["<C-h>"] = "which_key",
					},
				},
			},
			pickers = {
				live_grep = {
					debounce = 150, -- ms: aspetta prima di lanciare rg, evita flood di processi
				},
				find_files = {
					find_command = {
						"fd",
						"--type=file",
						"--exclude", ".git",
						"--exclude", "target",
						"--exclude", "node_modules",
						"--exclude", ".metadata",
						"--exclude", ".settings",
						"--exclude", "bin",
						"--exclude", "Debug",
						"--exclude", "Release",
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("notify")
	end,
}
