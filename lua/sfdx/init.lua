print("Hey it worked!")
local M = {}

M.deploy = function()
	local file = vim.cmd(":file")
	print(file)
end

return M
