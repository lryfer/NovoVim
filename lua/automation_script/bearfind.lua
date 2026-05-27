-- Searches nvim's cwd (up to 5 levels deep),
-- generates compile_commands.json via bear or native export.
--
-- Supported: CMakeLists.txt, meson.build, Makefile/GNUmakefile, build.ninja, SConstruct, wscript

local M = {}

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

function M.run()
	local cwd = vim.fn.getcwd()

	for _, entry in ipairs(BUILD_FILES) do
		local results = vim.fn.systemlist(
			"find "
				.. vim.fn.shellescape(cwd)
				-- TODO configurable depth
				.. " -maxdepth 5 -name "
				.. vim.fn.shellescape(entry.name)
				.. " 2>/dev/null | head -1"
		)
		local found = results and results[1] or ""
		if found ~= "" then
			local dir = vim.fn.fnamemodify(found, ":h")
			notify("Found " .. entry.name .. " → using " .. entry.kind)
			handlers[entry.kind](dir)
			return
		end
	end

	notify("No supported build file found under " .. cwd, vim.log.levels.WARN)
end

vim.api.nvim_create_user_command("BearFind", function()
	M.run()
end, { desc = "Find build system and generate compile_commands.json, then restart clangd" })

return M
