Properties `
{
    $Configuration = $null
    $WebServer = $null
    $SiteName = $null


    $DeployUsername = $null
    $DeployPassword = $null

}

$root = $PSScriptRoot
$src = Resolve-Path "$root\..\src"
$workspace = Resolve-Path "$root\.."


Task pre-publish -depends pre-build -description 'Set common publish settings for all deployments.' `
    -requiredVariables @('DeployUsername') `
{
    if (!$IsLinux)
    {
        $credential = New-Object System.Management.Automation.PSCredential($DeployUsername, (ConvertTo-SecureString $DeployPassword -AsPlainText -Force))
        Initialize-WebDeploy -Credential $credential
    }
}

Task package-web -depends pre-build -description 'Package web app to ZIP archive.' `
    -requiredVariables @('Configuration') `
{
    $buildParams = @("/p:Environment=$Environment")

    $outDir = "$workspace\out"
    New-Item -ItemType Directory $outDir -ErrorAction SilentlyContinue

    $projectName = 'DeployDemo.Web'
    $packagePath = "$outDir\$projectName.zip"
    Invoke-PackageBuild -ProjectPath "$src\$projectName\$projectName.csproj" `
        -PackagePath $packagePath -Configuration $Configuration -BuildParams $buildParams
}

Task publish-web -depends pre-publish, package-web -description '* Publish all web apps to specified server.' `
    -requiredVariables @('Configuration', 'WebServer', 'SiteName') `
{
    $projectName = 'DeployDemo.Web'
    $packagePath = "$workspace\out\$projectName.zip"
    Invoke-WebDeployment -PackagePath $packagePath -ServerHost $WebServer `
        -SiteName $SiteName -Application ''
}
