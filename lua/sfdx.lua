local filesystem = require("filesystem")
local Job = require("plenary.job")

local sfdx = {}
sfdx.cmd_args = function(cmd, extension, file_name)
	local filetype = ""
  local valuesToRemove = {"Controller", "Helper", "Renderer"}
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

    elseif (originalFileName == file_name and extension == "js") and extension == "html" or extension == "css" then
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

local function print_json(json_str)
	if json_str == nil or json_str == "" then
		print("Failed: invalid jq")
		return
	end
	local json_table = vim.fn.json_decode(json_str)
	if json_table.status == 1 and not json_table.message == nil then
		print("Failed: " .. json_table.message)
		return
	end
	if json_table.status == 1 and not json_table.result == nil then
		local failures = json_table.result.details.componentFailures
		for _, value in next, failures do
			print(value.problem)
		end
	end
	for key, value in next, json_table do
		if value == nil or value == "" or value == vim.NIL or key == nil or key == "" then
			goto continue
		end
		if key == "status" then
			if value == 0 then
				print("Success")
			end
			goto continue
		end
		if type(value) == "table" then
			value = table.concat(value)
		end
		print(value)
		::continue::
	end
end

local function terminal_exec(args, result_filter)
	-- local stdout_results = ""
	if next(args) == nil then
		print("Failure: Entered wrong command for wrong buffer")
		return
	end

	local cmd_string = "sfdx "

	for _, value in next, args do
		cmd_string = cmd_string .. value .. " "
	end

	vim.api.nvim_exec(":terminal " .. cmd_string, true)

	-- local job = Job:new({
	-- 	writer = Job:new({
	-- 		command = "sfdx",
	-- 		args = args,
	-- 		cwd = vim.loop.cwd(),
	-- 		enabled_recording = true,
	-- 	}),
	-- 	command = "jq",
	-- 	args = { "-c", result_filter },
	-- 	on_stdout = function(_, line)
	-- 		stdout_results = stdout_results .. line
	-- 	end,
	-- 	on_exit = function() end,
	-- })
	-- job:start()
	-- job:wait(20000, 50)
	-- job:after_success(print_json(stdout_results))
end

sfdx.execute_command = function(cmd, result_filter)
	local file_info = filesystem.get_file_info()
	local args = sfdx.cmd_args(cmd, file_info.extension, file_info.file_name)

	terminal_exec(args, result_filter)
end

sfdx.set_default_username = function(name)
	terminal_exec(
		{ "config:set", "defaultusername=" .. name, "--json" },
		"{status: .status,name: .result.successes[0].value?, message: .message?}"
	)
end

sfdx.deploy = function()
	sfdx.execute_command("project deploy start --ignore-conflicts", ".")
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
