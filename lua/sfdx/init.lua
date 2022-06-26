local filesystem = require("filesystem")
local M = {}

local function command_string(cmd, extension, file_name)
	local filetype = ""
	local pre_file = ""
	local post_file = ""
	if cmd == "force:apex:test:run" then
		pre_file = " --synchronous --classnames "
		filetype = file_name
	else
		pre_file = " -m "
		if extension == "cls" then
			filetype = "ApexClass"
		elseif extension == "html" or extension == "js" or extension == "css" then
			filetype = "LightningComponentBundle"
		end
		post_file = ":" .. file_name
	end
	return "sfdx " .. cmd .. pre_file .. filetype .. post_file
end

local function execute_command(cmd)
	local file_info = filesystem.get_file_info()
	local extension = file_info.extension
	local file_name = file_info.file_name
	local cmd_string = command_string(cmd, extension, file_name)
	vim.api.nvim_exec(":terminal " .. cmd_string, true)
end

M.get_default_username = function(name)
	vim.api.nvim_exec(":terminal sfdx config:set defaultusername=" .. name, false)
end

M.deploy = function()
	execute_command("force:source:deploy")
end

M.test = function()
	execute_command("force:apex:test:run")
end

return M
