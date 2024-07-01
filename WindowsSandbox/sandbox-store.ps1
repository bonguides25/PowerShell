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
Write-Host "`nInstalling Microsoft Store..." -ForegroundColor Yellow

# Install C++ Runtime framework packages for Desktop Bridge
    $ProgressPreference='Silent'
    irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/msvclibs.ps1 | iex

# Install Microsoft.UI.Xaml
    $ProgressPreference='Silent'
    irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/microsoft.ui.xaml.ps1 | iex

# Install the dependency packages
    $ProgressPreference='Silent'
    irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/sideloaddeps.ps1 | iex

# Installe Microsoft Store
    Invoke-WebRequest -Uri 'https://s3.amazonaws.com/s3.bonben365.com/files/shared/StoreApps/Microsoft.WindowsStore_12107.1001.15.0_neutral_~_8wekyb3d8bbwe.AppxBundle' -OutFile 'Microsoft.WindowsStore_12107.1001.15.0_neutral_~_8wekyb3d8bbwe.AppxBundle'
    Add-AppxPackage 'Microsoft.WindowsStore_12107.1001.15.0_neutral_~_8wekyb3d8bbwe.AppxBundle'

# Downlaod and install Windows Package Manager to install Store apps
    Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
    Add-AppxPackage 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
    
Get-AppxPackage | Where-Object { $_.name -like "*Store*" -or $_.name -like "*UI.Xaml*" -or $_.name -like "*DesktopAppInstaller*" -or $_.name -like "*Native.Framework*"} | Select-Object Name, Version -ErrorAction SilentlyContinue
Write-Host "Done.`n" -ForegroundColor Yellow

# Open the Microsoft Store
start ms-windows-store:

