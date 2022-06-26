local filesystem = {}

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

filesystem.get_file_info = function()
	local file = get_file()
	local file_name = get_file_name(file)
	local extension = get_file_extension(file)
	return { file_name = file_name, extension = extension }
end

return filesystem
