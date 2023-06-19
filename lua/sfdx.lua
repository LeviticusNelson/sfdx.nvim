local filesystem = require("filesystem")
local Job = require("plenary.job")
require("nvterm").setup()

local sfdx = {}
local function cmd_args(cmd, extension, file_name)
	local filetype = ""
	local valuesToRemove = { "Controller", "Helper", "Renderer" }
	local originalFileName = file_name
	local args = {}

	for _, value in ipairs(valuesToRemove) do
		file_name = string.gsub(file_name, value, "")
	end

	table.insert(args, cmd)
	if cmd == "apex run test" and extension == "cls" then
		table.insert(args, "--synchronous")
		table.insert(args, "--code-coverage")
		table.insert(args, "-n")
		table.insert(args, file_name)
	else
		table.insert(args, "-m")
		if extension == "cls" then
			filetype = "ApexClass:"
		elseif extension == "page" then
			filetype = "ApexPage:"
		elseif extension == "trigger" then
			filetype = "ApexTrigger"
		elseif (originalFileName == file_name and extension == "js") or extension == "html" or extension == "css" then
			filetype = "LightningComponentBundle:"
		elseif (originalFileName ~= file_name and extension == "js") or extension == "cmp" or extension == "design" then
			filetype = "AuraDefinitionBundle:"
		else
			args = {}
			return args
		end
		table.insert(args, filetype .. file_name)
	end
	-- table.insert(args, "--json")
	return args
end

local function terminal_exec(args, result_filter)
	if not args or #args == 0 then
		print("Failure: Entered wrong command for wrong buffer")
		return
	end

	local cmd_string = "sfdx "

	for _, value in ipairs(args) do
		cmd_string = cmd_string .. value .. " "
	end

	--vim.api.nvim_exec(":terminal " .. cmd_string, true)

  require("nvterm.terminal").send(cmd_string, "horizontal")
end

local function extractFilePath(filePath, fileType)
	local directory = filePath:match("(.-/default/)")

	if fileType == "LWC" then
		directory = directory .. "lwc/"
	elseif fileType == "Aura" then
		directory = directory .. "aura/"
	elseif fileType == "ApexPage" then
		directory = directory .. "pages/"
	elseif fileType == "ApexTrigger" then
		directory = directory .. "triggers/"
	else
		directory = directory .. "classes/"
	end

	return directory
end

local function ChooseClass(cmd, file_path)
	local file_types = {
		["1"] = { type = "ApexClass", cmd = cmd },
		["2"] = { type = "ApexTrigger", cmd = "apex generate trigger" },
		["3"] = { type = "ApexPage", cmd = "visualforce generate page" },
		["4"] = { type = "Aura", cmd = "force:lightning:component:create" },
		["5"] = { type = "LWC", cmd = "force:lightning:component:create" },
		["0"] = { type = "Cancel" },
	}

	local input_type
	while not file_types[input_type] do
		print("Select file type:")
		print("1. Apex Class")
		print("2. Apex Trigger")
		print("3. Visualforce Page")
		print("4. Aura")
		print("5. LWC")
		print("0. Cancel")
		input_type = vim.fn.input("Enter the file type number: \n")
	end

	if input_type == "0" then
		return nil
	end

	local selected_type = file_types[input_type].type
	local selected_cmd = file_types[input_type].cmd
	local class_name = vim.fn.input("Enter the class name: ")
	local directory = extractFilePath(file_path, selected_type)

	if selected_type == "LWC" then
		return { selected_cmd .. " --type lwc --componentname " .. class_name .. " -d " .. directory }
	elseif selected_type == "ApexPage" then
		return { selected_cmd .. " --name " .. class_name .. " --label " .. class_name .. " --outputdir " .. directory }
	elseif selected_type == "ApexTrigger" then
		return { selected_cmd .. " --name " .. class_name .. " --outputdir " .. directory }
	else
		return { selected_cmd .. " -n " .. class_name .. " -d " .. directory }
	end
end

local function authorizeOrg(cmd)
  local orgAlias = vim.fn.input("Enter an org alias: ")
  local orgUrl = vim.fn.input("Enter a custom login or leave blank to use the default: ")

local start_pos = vim.fn.getpos("'<")
local end_pos = vim.fn.getpos("'>")

local lines = {}
for i = start_pos[2], end_pos[2] do
  table.insert(lines, vim.fn.getline(i))
end

local selected_text = table.concat(lines, "\n")

print(selected_text)
  
  if orgUrl ~= nil and orgUrl ~= "" then
    return { cmd .. " -a " .. orgAlias .. " --instanceurl " .. orgUrl}
  else
    return { cmd .. " -a " .. orgAlias}
  end
end

local function createProject(cmd)
  local projectName = vim.fn.input("Enter a project name: ")
  local projectDir = vim.fn.input("Enter a directory to create: ")
  
  if projectDir ~= nil and projectDir ~= "" then
    return { cmd .. " -n " .. projectName .. " --manifest -d " .. projectDir}
  else
    return { cmd .. " -n " .. projectName .. " --manifest"}
  end
end

sfdx.execute_command = function(cmd, result_filter)
	local file_info = filesystem.get_file_info()
	local args
	
  if cmd == "force:apex:class:create" then
		args = ChooseClass(cmd, file_info.file_path)
	elseif cmd == "org login web" then
    args = authorizeOrg(cmd)
  elseif cmd =="project generate" then 
    args = createProject(cmd)
  elseif cmd == "" then
    args = execute()
  else
		args = cmd_args(cmd, file_info.extension, file_info.file_name)
	end

	terminal_exec(args, result_filter)
end

sfdx.createClass = function()
	sfdx.execute_command("force:apex:class:create", ".")
end

sfdx.set_default_username = function(name)
	terminal_exec(
		{ "config:set", "defaultusername=" .. name, "--json" },
		"{status: .status,name: .result.successes[0].value?, message: .message?}"
	)
end

sfdx.authorize = function()
  sfdx.execute_command("org login web", ".")
end

sfdx.createProject = function()
  sfdx.execute_command("project generate", ".")
end

sfdx.deploy = function()
	sfdx.execute_command("project deploy start --ignore-conflicts", ".")
end

sfdx.execute = function()
  sfdx.execute_command("", ".")
end

sfdx.retrieve = function()
	sfdx.execute_command("project retrieve start --ignore-conflicts", ".")
end

sfdx.test = function()
	sfdx.execute_command(
		"apex run test",
		"{status: .status, coverage: .result.summary.coverage?, outcome: .result.summary.outcome?, testsRan: .result.summary.testsRan?, passing: .result.summary.passing?, failing: .result.summary.failing?, skipped: .result.summary.skipped?, passRate: .result.summary.passRate?,failRate: .result.summary.failRate?}"
	)
end


return sfdx

