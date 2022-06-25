local function sfdx_deploy()
        local file = vim.cmd(":file")
        print(file)
end

return {
        sfdx_deploy = sfdx_deploy
}
