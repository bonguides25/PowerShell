<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides
Description  : Install Exchange Online PowerShell modules
============================================================================================#>

# Required running with elevated right.
    if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "`nYou need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
        # Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm  | iex"
        break
    }

# Configure the system before install the module
    Function InstallDeps {

        # Configure Execution Policy
            Set-ExecutionPolicy Bypass -Scope Process -Force | Out-Null

        # Update the NuGet Provider if needed.
            $nuGetPath = "C:\Program Files\PackageManagement\ProviderAssemblies\nuget\*\Microsoft.PackageManagement.NuGetProvider.dll"
            $testPath = Test-Path -Path $nuGetPath
            if ($testPath -match 'false') {
                Write-Host "Installing NuGet Provider..." -ForegroundColor Yellow
                Install-PackageProvider -Name NuGet -Force | Out-Null
            }

        # Update the PowerShellGet if needed.
            $PSGetCurrentVersion = (Get-PackageProvider -Name 'PowerShellGet').Version
            $PSGetLatestVersion = (Find-Module PowerShellGet).Version
            if ($PSGetCurrentVersion -lt $PSGetLatestVersion) {
                Write-Host "Updating PowerShellGet Module from $PSGetCurrentVersion to $PSGetLatestVersion..." -ForegroundColor Yellow
                Install-Module -Name 'PowerShellGet' -Force
            }

        # We're installing from the PowerShell Gallery so make sure that it's trusted.
            $InstallationPolicy = (Get-PSRepository -Name PSGallery).InstallationPolicy
            if ($InstallationPolicy -match "Untrusted") {
                Write-host "Configuring the PowerShell Gallery Repository..." -ForegroundColor Yellow
                Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
            }
    }

# Install the PowerShell module
    $exoModule =  Get-Module ExchangeOnlineManagement -ListAvailable
    if($null -eq $exoModule)
    { 
        Write-host "Important: Exchange Online module is unavailable. `nIt is mandatory to have this module installed in the system to run the script successfully." -ForegroundColor Yellow
        $confirm = Read-Host Are you sure you want to install Exchange Online module? [Y] Yes [N] No  
        if($confirm -match "[yY]") 
        { 
            Write-host "Installing Exchange Online module..." -ForegroundColor Yellow
            Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser
            Write-host "Exchange Online Module is installed in the machine successfully" -ForegroundColor Magenta 
        } 
        else
        { 
            Write-host "Exiting. `nNote: Exchange Online module must be available in your system to run the script" 
            Exit 
        } 
}