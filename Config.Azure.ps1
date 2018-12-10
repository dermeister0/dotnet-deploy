Expand-PsakeConfiguration `
@{
    Configuration = 'Release'
    WebServer = 'dotnet-deploy-fork.scm.azurewebsites.net'
    SiteName = 'dotnet-deploy-fork'
}

# Secret Config Example

<#
Expand-PsakeConfiguration `
@{
    DeployUsername = $env:DeployUsername
    DeployPassword = $env:DeployPassword
}
#>