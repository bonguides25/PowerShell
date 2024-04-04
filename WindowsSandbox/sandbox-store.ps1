<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Install Microsoft Store on Windows Sandbox.
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}

Set-Location "$env:temp"
Write-Host "`nInstalling Microsoft Store..." -ForegroundColor Green

# Install C++ Runtime framework packages for Desktop Bridge
    $ProgressPreference='Silent'
    irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/msvclibs.ps1 | iex

# Install Microsoft.UI.Xaml through Nuget.
    $ProgressPreference='Silent'
    irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/microsoft.ui.xaml.ps1 | iex

# Install the dependency packages.
    $ProgressPreference='Silent'
    irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/sideloaddeps.ps1 | iex

# Installe Microsoft Store
    Invoke-WebRequest -Uri 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Files/StoreApps/Microsoft.WindowsStore_11809.1001.713.0_neutral_~_8wekyb3d8bbwe.AppxBundle' -OutFile 'Microsoft.WindowsStore_11809.1001.713.0_neutral_~_8wekyb3d8bbwe.AppxBundle'
    Add-AppxPackage 'Microsoft.WindowsStore_11809.1001.713.0_neutral_~_8wekyb3d8bbwe.AppxBundle'

# Downlaod and install Windows Package Manager to install Store apps
    Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
    Add-AppxPackage 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'

Get-AppxPackage | Where-Object { $_.name -like "*Store*" -or $_.name -like "*UI.Xaml*" -or $_.name -like "*DesktopAppInstaller*" } | Select-Object Name, Version -ErrorAction SilentlyContinue
Write-Host "Done.`n" -ForegroundColor Green

