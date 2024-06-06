# Required running with elevated right
if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "`nYou need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm  | iex"
    break
}

# Configure Execution Policy
Set-ExecutionPolicy RemoteSigned -Force | Out-Null

# Update the NuGet Provider if needed
$nuGetPath = "C:\Program Files\PackageManagement\ProviderAssemblies\nuget\*\Microsoft.PackageManagement.NuGetProvider.dll"
$testPath = Test-Path -Path $nuGetPath
if ($testPath -match 'false') {
    Install-PackageProvider -Name NuGet -Force | Out-Null
}

# Update the PowerShellGet if needed
$PSGetCurrentVersion = (Get-PackageProvider -Name 'PowerShellGet').Version
$PSGetLatestVersion = (Find-Module PowerShellGet).Version
if ($PSGetCurrentVersion -lt $PSGetLatestVersion) {
    Install-Module -Name 'PowerShellGet' -Force
}

# We're installing from the PowerShell Gallery so make sure that it's trusted
$InstallationPolicy = (Get-PSRepository -Name PSGallery).InstallationPolicy
if ($InstallationPolicy -match "Untrusted") {
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

