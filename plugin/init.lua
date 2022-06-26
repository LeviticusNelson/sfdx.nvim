-- make sure this file is loaded only once
if vim.g.loaded_sfdx == 1 then
	return
end
vim.g.loaded_sfdx = 1

local sfdx = require("sfdx")

vim.api.nvim_create_user_command("SfdxDeploy", sfdx.deploy, {})
vim.api.nvim_create_user_command("SfdxTest", sfdx.test, {})
