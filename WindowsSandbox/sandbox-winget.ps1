<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Install Windows Package Manager on Windows Sandbox (winget).
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    # Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm bonguides.com/wsb/msstore.com | iex"
    break
}

$progressPreference = 'silentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery..." -ForegroundColor Yellow
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..." -ForegroundColor Yellow
Repair-WinGetPackageManager | Out-Null
Write-Host "Winget version: $(winget -v)" -ForegroundColor Green
Write-Host "Done."

# Write-Host "`nInstalling Windows Package Manager (winget)..." -ForegroundColor Yellow


# # Install C++ Runtime framework packages for Desktop Bridge
#     $ProgressPreference='Silent'
#     irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/msvclibs.ps1 | iex

# # Install Microsoft.UI.Xaml through Nuget.
#     $ProgressPreference='Silent'
#     irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/microsoft.ui.xaml.ps1 | iex

# # Install Windows Package Managet for install apps from Microsoft Store.
#     $progressPreference = 'silentlyContinue'
#     Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
#     Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

# Write-Host "Winget version: $(winget -v)"
# winget




    

