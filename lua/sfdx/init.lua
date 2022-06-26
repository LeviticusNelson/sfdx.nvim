local M = {}

local function get_file()
	local file = vim.api.nvim_buf_get_name(0)
	return file:match("[^%/]*$")
end

local function get_file_name(file)
	return file:match("[^%.]*")
end

local function get_file_extension(file)
	return file:match("[^%.]*$")
end

local function get_file_info()
	local file = get_file()
	local file_name = get_file_name(file)
	local extension = get_file_extension(file)
	return { file_name = file_name, extension = extension }
end

local function execute_command(cmd)
	local file_info = get_file_info()
	local extension = file_info.extension
	local file_name = file_info.file_name
	local filetype = ""
	local pre_opts = ""
	local post_opts = ""
	if cmd == "force:apex:test:run" then
		pre_opts = " --synchronous --classnames "
		filetype = file_name
	else
		pre_opts = " -m "
		if extension == "cls" then
			filetype = "ApexClass"
		elseif extension == "html" or extension == "js" or extension == "css" then
			filetype = "LightningComponentBundle"
		end
		post_opts = ":" .. file_name
	end
	vim.api.nvim_exec(":terminal sfdx " .. cmd .. pre_opts .. filetype .. post_opts, true)
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
