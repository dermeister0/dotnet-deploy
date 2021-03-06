Framework 4.6
$InformationPreference = 'Continue'
$env:PSModulePath += [IO.Path]::PathSeparator + [IO.Path]::Combine($PSScriptRoot, 'scripts', 'modules')

. .\scripts\Saritasa.PsakeExtensions.ps1
. .\scripts\Saritasa.BuildTasks.ps1
. .\scripts\Saritasa.PsakeTasks.ps1

. .\scripts\AzureTasks.ps1
. .\scripts\BuildTasks.ps1
. .\scripts\PublishTasks.ps1

Properties `
{
    $Environment = $env:Environment
    $SecretConfigPath = $env:SecretConfigPath
}

TaskSetup `
{
    if ($ConfigInitialized)
    {
        return
    }
    Expand-PsakeConfiguration @{ ConfigInitialized = $true; IsLocalDevelopment = !$Environment }

    if (!$Environment)
    {
        Expand-PsakeConfiguration @{ Environment = 'Development' }
    }
    Import-PsakeConfigurationFile ".\Config.$Environment.ps1"
    Import-PsakeConfigurationFile $SecretConfigPath
}
