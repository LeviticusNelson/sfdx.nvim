describe("sfdx", function()
	it("Can be required", function()
		require("sfdx")
	end)

	-- local sfdx = require("sfdx")

	-- it("Can create lwc deploy args from html source", function()
	-- 	local lwc_deploy = sfdx.cmd_args("force:source:deploy", "html", "test")
	-- 	assert.are.same(
	-- 		vim.inspect.inspect({ "force:source:deploy", "-m", "LightningComponentBundle:test" }),
	-- 		vim.inspect.inspect(lwc_deploy)
	-- 	)
	-- end)

	-- it("Can create lwc deploy args from css source", function()
	-- 	local lwc_deploy = sfdx.cmd_args("force:source:deploy", "css", "test")
	-- 	assert.are.same({ "force:source:deploy", "-m", "LightningComponentBundle:test" }, lwc_deploy)
	-- end)

	-- it("Can create lwc deploy args from js source", function()
	-- 	local lwc_deploy = sfdx.cmd_args("force:source:deploy", "js", "test")
	-- 	assert.are.same({ "force:source:deploy", "-m", "LightningComponentBundle:test" }, lwc_deploy)
	-- end)

	-- it("Can create apex deploy args from cls source", function()
	-- 	local apex_deploy = sfdx.cmd_args("force:source:deploy", "cls", "test")
	-- 	assert.are.same({ "force:source:deploy", "-m", "ApexClass:test" }, apex_deploy)
	-- end)

	-- it("Can create apex test args from cls source", function()
	-- 	local apex_deploy = sfdx.cmd_args("force:apex:test:run", "cls", "test")
	-- 	assert.are.same({ "force:apex:test:run", "--synchronous", "--classnames", "test" }, apex_deploy)
	-- end)
end)
