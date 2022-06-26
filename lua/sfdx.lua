local filesystem = require("filesystem")
local sfdx = {}
local terminal_method = ":terminal "
sfdx.command_string = function(cmd, extension, file_name)
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
		else
			return "echo 'error: command for this filetype not supported'"
		end
		post_file = ":" .. file_name
	end
	return "sfdx " .. cmd .. pre_file .. filetype .. post_file
end

sfdx.execute_command = function(cmd)
	local file_info = filesystem.get_file_info()
	local cmd_string = sfdx.command_string(cmd, file_info.extension, file_info.file_name)
	vim.api.nvim_exec(terminal_method .. cmd_string, true)
end

sfdx.get_default_username = function(name)
	vim.api.nvim_exec(terminal_method .. "sfdx config:set defaultusername=" .. name, false)
end

sfdx.deploy = function()
	sfdx.execute_command("force:source:deploy")
end

sfdx.test = function()
	sfdx.execute_command("force:apex:test:run")
end

return sfdx
