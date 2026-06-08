-- Searches nvim's cwd (up to 5 levels deep),
-- generates compile_commands.json via bear or native export.
--
-- Supported: CMakeLists.txt, meson.build, Makefile/GNUmakefile, build.ninja, SConstruct, wscript
--
-- Uses Telescope to let you pick which build file to use if multiple are found.

local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Priority order: native exporters first, then bear-wrapped builders
local BUILD_FILES = {
	{ name = "CMakeLists.txt", kind = "cmake" },
	{ name = "meson.build", kind = "meson" },
	{ name = "Makefile", kind = "make" },
	{ name = "GNUmakefile", kind = "make" },
	{ name = "makefile", kind = "make" },
	{ name = "build.ninja", kind = "ninja" },
	{ name = "SConstruct", kind = "scons" },
	{ name = "wscript", kind = "waf" },
}

local function notify(msg, level)
	vim.notify("[bearfind] " .. msg, level or vim.log.levels.INFO)
end

local function restart_clangd()
	vim.defer_fn(function()
		for _, client in ipairs(vim.lsp.get_clients({ name = "clangd" })) do
			client:stop(true)
		end
		vim.cmd("edit")
		notify("clangd restarted with new compile_commands.json")
	end, 1500)
end

local function run_job(cmd, dir, on_success)
	notify("Running: " .. table.concat(cmd, " "))
	vim.fn.jobstart(cmd, {
		cwd = dir,
		on_exit = function(_, code)
			vim.schedule(function()
				if code == 0 then
					on_success()
				else
					notify(table.concat(cmd, " ") .. " failed (exit " .. code .. ")", vim.log.levels.ERROR)
				end
			end)
		end,
	})
end

local handlers = {
	cmake = function(dir)
		local build_dir = dir .. "/build"
		run_job({ "cmake", "-S", dir, "-B", build_dir, "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" }, dir, function()
			vim.fn.system("ln -sf " .. build_dir .. "/compile_commands.json " .. dir .. "/compile_commands.json")
			notify("compile_commands.json linked at " .. dir)
			restart_clangd()
		end)
	end,

	meson = function(dir)
		local build_dir = dir .. "/build"
		run_job({ "meson", "setup", "--wipe", build_dir, dir }, dir, function()
			vim.fn.system("ln -sf " .. build_dir .. "/compile_commands.json " .. dir .. "/compile_commands.json")
			notify("compile_commands.json linked at " .. dir)
			restart_clangd()
		end)
	end,

	make = function(dir)
		-- -B forces rebuild so bear intercepts all compiler calls even if already built
		-- -k keeps going if a target fails (e.g. missing linker libs on embedded)
		notify("Running: bear -- make -B -k -C " .. dir)
		vim.fn.jobstart({ "bear", "--", "make", "-B", "-k", "-C", dir }, {
			cwd = dir,
			on_exit = function(_, code)
				vim.schedule(function()
					local json = dir .. "/compile_commands.json"
					if vim.fn.filereadable(json) == 1 then
						if code ~= 0 then
							notify(
								"make exited " .. code .. " but compile_commands.json was written (partial build ok)"
							)
						else
							notify("compile_commands.json generated at " .. dir)
						end
						restart_clangd()
					else
						notify("bear produced no compile_commands.json (exit " .. code .. ")", vim.log.levels.ERROR)
					end
				end)
			end,
		})
	end,

	ninja = function(dir)
		run_job({ "bear", "--", "ninja", "-C", dir }, dir, function()
			notify("compile_commands.json generated at " .. dir)
			restart_clangd()
		end)
	end,

	scons = function(dir)
		run_job({ "bear", "--", "scons" }, dir, function()
			notify("compile_commands.json generated at " .. dir)
			restart_clangd()
		end)
	end,

	waf = function(dir)
		run_job({ "bear", "--", "python", "waf", "build" }, dir, function()
			notify("compile_commands.json generated at " .. dir)
			restart_clangd()
		end)
	end,
}

-- Find all build files and return them with metadata
local function find_all_build_files(max_depth)
	local cwd = vim.fn.getcwd()
	local found_files = {}

	for _, entry in ipairs(BUILD_FILES) do
		local results = vim.fn.systemlist(
			"find "
				.. vim.fn.shellescape(cwd)
				.. " -maxdepth "
				.. max_depth
				.. " -name "
				.. vim.fn.shellescape(entry.name)
				.. " 2>/dev/null"
		)

		for _, path in ipairs(results) do
			if path ~= "" then
				local dir = vim.fn.fnamemodify(path, ":h")
				local depth = select(2, path:gsub("/", "")) - select(2, cwd:gsub("/", ""))
				table.insert(found_files, {
					path = path,
					dir = dir,
					name = entry.name,
					kind = entry.kind,
					depth = depth,
				})
			end
		end
	end

	-- Sort by depth (shallower first), then by name
	table.sort(found_files, function(a, b)
		if a.depth == b.depth then
			return a.name < b.name
		end
		return a.depth < b.depth
	end)

	return found_files
end

-- Show Telescope picker with all found build files
local function show_picker(build_files)
	pickers
		.new({}, {
			prompt_title = "Select Build File",
			finder = finders.new_table({
				results = build_files,
				entry_maker = function(entry)
					local display = string.format(
						"[%s] %s (depth: %d)",
						entry.kind,
						vim.fn.fnamemodify(entry.path, ":."),
						entry.depth
					)
					return {
						value = entry,
						display = display,
						ordinal = entry.path,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						local entry = selection.value
						notify("Selected " .. entry.name .. " → using " .. entry.kind)
						handlers[entry.kind](entry.dir)
					end
				end)
				return true
			end,
		})
		:find()
end

function M.run(opts)
	opts = opts or {}
	local max_depth = opts.max_depth or 5

	local build_files = find_all_build_files(max_depth)

	if #build_files == 0 then
		notify("No supported build file found (max depth: " .. max_depth .. ")", vim.log.levels.WARN)
		return
	end

	if #build_files == 1 then
		-- Only one found, use it directly
		local entry = build_files[1]
		notify("Found " .. entry.name .. " → using " .. entry.kind)
		handlers[entry.kind](entry.dir)
	else
		-- Multiple found, show picker
		show_picker(build_files)
	end
end

vim.api.nvim_create_user_command("BearFind", function()
	M.run()
end, { desc = "Find build system and generate compile_commands.json, then restart clangd" })

return M
