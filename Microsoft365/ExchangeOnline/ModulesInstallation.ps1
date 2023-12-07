# Required running with elevated right.
if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
 }

# Configure Execution Policy
if ((Get-ExecutionPolicy) -notmatch "RemoteSigned") {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
}

# Update the PowerShellGet if needed.
$PSGetCurrentVersion = (Get-PackageProvider -Name 'PowerShellGet').Version
$PSGetLatestVersion = (Find-Module PowerShellGet).Version
if ($PSGetCurrentVersion -lt $PSGetLatestVersion) {
    Write-Host "`nUpdating PowerShellGet Module from $PSGetCurrentVersion to $PSGetLatestVersion..."
    Install-Module -Name 'PowerShellGet' -Force
}

# We're installing from the PowerShell Gallery so make sure that it's trusted.
$InstallationPolicy = (Get-PSRepository -Name PSGallery).InstallationPolicy
if ($InstallationPolicy -match "Untrusted") {
   Write-host "`nConfiguring the PowerShell Gallery Repository..."
   Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
}

# Update the NuGet Provider if needed.
$nuGetPath = "C:\Program Files\PackageManagement\ProviderAssemblies\nuget\*\Microsoft.PackageManagement.NuGetProvider.dll"
$testPath = Test-Path -Path $nuGetPath
if ($testPath -match 'false') {
    Write-Host "`nInstalling NuGet Provider..."
    Install-PackageProvider -Name NuGet -Force | Out-Null
}

$ExchangeOnlineModule =  Get-Module ExchangeOnlineManagement -ListAvailable
if($null -eq $ExchangeOnlineModule)
{ 
    Write-host "Important: Exchange Online module is unavailable. It is mandatory to have this module installed in the system to run the script successfully." 
    $confirm = Read-Host Are you sure you want to install Exchange Online module? [Y] Yes [N] No  
    if($confirm -match "[yY]") 
    { 
        Write-host "Installing Exchange Online module..."
        Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser
        Write-host "Exchange Online Module is installed in the machine successfully" -ForegroundColor Magenta 
    } 
    else
    { 
        Write-host "Exiting. `nNote: Exchange Online module must be available in your system to run the script" 
        Exit 
    } 
}