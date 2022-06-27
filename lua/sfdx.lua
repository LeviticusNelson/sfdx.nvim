local filesystem = require("filesystem")
local Job = require("plenary.job")
local Json = require("plenary.json")
local sfdx = {}
sfdx.cmd_args = function(cmd, extension, file_name)
	local filetype = ""
	local args = {}
	table.insert(args, cmd)
	if cmd == "force:apex:test:run" then
		table.insert(args, "--synchronous")
		table.insert(args, "--classnames")
		table.insert(args, file_name)
		table.insert(args, "--json")
	else
		table.insert(args, "-m")
		if extension == "cls" then
			filetype = "ApexClass"
		elseif extension == "html" or extension == "js" or extension == "css" then
			filetype = "LightningComponentBundle"
		else
			return "echo 'error: command for this filetype not supported'"
		end
		table.insert(args, filetype .. file_name)
	end
	return args
end

local function terminal_exec(args, display_stdout)
	local stdout_results = ""
	local job = Job:new({
		command = "sfdx",
		args = args,
		-- TODO: Redirect the cwd to the buffers pwd
		cwd = "~/salesforcedev/",
		enabled_recording = true,
		on_stdout = function(_, line)
			stdout_results = stdout_results .. line
		end,
		on_exit = function()
			if display_stdout then
				print(stdout_results)
			end
		end,
	})
	job:start()
end

sfdx.execute_command = function(cmd, on_start_str, on_exit_str, display_stdout)
	local file_info = filesystem.get_file_info()
	local args = sfdx.cmd_args(cmd, file_info.extension, file_info.file_name)
	print(on_start_str)

	terminal_exec(args, display_stdout)
	print(on_exit_str)
end

sfdx.set_default_username = function(name)
	terminal_exec({ "config:set", "defaultusername=" .. name, "--json" }, true)
end

sfdx.deploy = function()
	sfdx.execute_command("force:source:deploy", "Deploying...", "Successfully Deployed", false)
end

sfdx.test = function()
	sfdx.execute_command("force:apex:test:run", "Testing...", "", true)
end

return sfdx
