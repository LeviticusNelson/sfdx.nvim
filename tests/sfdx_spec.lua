describe("sfdx", function()
	it("Can be required", function()
		require("sfdx")
	end)

	local sfdx = require("sfdx")

	-- it("Can create lwc deploy string from html source", function()
	-- 	local lwc_deploy = sfdx.command_string("force:source:deploy", "html", "test")
	-- 	assert.are.same("force:source:deploy -m LightningComponentBundle:test", lwc_deploy)
	-- end)

	-- it("Can create lwc deploy string from css source", function()
	-- 	local lwc_deploy = sfdx.command_string("force:source:deploy", "css", "test")
	-- 	assert.are.same("force:source:deploy -m LightningComponentBundle:test", lwc_deploy)
	-- end)

	-- it("Can create lwc deploy string from js source", function()
	-- 	local lwc_deploy = sfdx.command_string("force:source:deploy", "js", "test")
	-- 	assert.are.same("force:source:deploy -m LightningComponentBundle:test", lwc_deploy)
	-- end)

	-- it("Can create apex deploy string from cls source", function()
	-- 	local apex_deploy = sfdx.command_string("force:source:deploy", "cls", "test")
	-- 	assert.are.same("force:source:deploy -m ApexClass:test", apex_deploy)
	-- end)

	-- it("Can create apex test string from cls source", function()
	-- 	local apex_deploy = sfdx.command_string("force:apex:test:run", "cls", "test")
	-- 	assert.are.same("force:apex:test:run --synchronous --classnames test", apex_deploy)
	-- end)

	it("Can format json string properly", function()
		local json = [[
                {
  "status": 1,
  "name": "RequiresUsernameError",
  "message": "This command requires a username. Specify it with the -u parameter or with the \"sfdx config:set defaultusern
ame=<username>\" command.",
  "exitCode": 1,
  "commandName": "Run",
  "warnings": []
}
                ]]
		local format = sfdx.format_json(json)
		print(format)
		assert.are.same(format, format)
	end)
end)
