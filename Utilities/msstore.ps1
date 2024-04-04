<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
# Install Microsoft Store on Windows 10, 11
# Including Windows Sandbox and Windows LTSC systems
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}

# Installing the Microsoft Store on Windows Sandbox
    if (Test-Path 'C:\Users\WDAGUtilityAccount') {
        Write-Host "`nYou're using Windows Sandbox." -ForegroundColor Yellow
        https://raw.githubusercontent.com/bonguides25/PowerShell/main/WindowsSandbox/sandbox-store.ps1
        exit
    }

# Installing the Microsoft Store on Windows LTSC
    $edition = (Get-CimInstance Win32_OperatingSystem).Caption
    if ($edition -like "*LTSC*"){
        Write-Host "`nYou're using $edition." -ForegroundColor Yellow
        irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/WindowsLTSC/ltsc-store.ps1 | iex
        exit
    }



# Create temporary directory
$null = New-Item -Path $env:temp\temp -ItemType Directory -Force
Set-Location $env:temp\temp

$progressPreference = 'silentlyContinue'
Write-Host "`nInstalling Microsoft Store..." -ForegroundColor Green

Invoke-WebRequest -Uri 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx' -OutFile 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
# Invoke-WebRequest -Uri 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx' -OutFile 'Microsoft.UI.Xaml.2.7.x64.appx'
Invoke-WebRequest -Uri 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.5/Microsoft.UI.Xaml.2.8.x64.appx' -OutFile 'Microsoft.UI.Xaml.2.8.x64.appx'

Invoke-WebRequest -Uri 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Files/StoreApps/Microsoft.WindowsStore_11809.1001.713.0_neutral_~_8wekyb3d8bbwe.AppxBundle' -OutFile 'Microsoft.WindowsStore_11809.1001.713.0_neutral_~_8wekyb3d8bbwe.AppxBundle'
Invoke-WebRequest -Uri 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Files/StoreApps/Microsoft.NET.Native.Runtime.1.6_1.6.24903.0_x64__8wekyb3d8bbwe.Appx' -OutFile 'Microsoft.NET.Native.Runtime.1.6_1.6.24903.0_x64__8wekyb3d8bbwe.Appx'
Invoke-WebRequest -Uri 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Files/StoreApps/Microsoft.NET.Native.Framework.1.6_1.6.24903.0_x64__8wekyb3d8bbwe.Appx' -OutFile 'Microsoft.NET.Native.Framework.1.6_1.6.24903.0_x64__8wekyb3d8bbwe.Appx'
Invoke-WebRequest -Uri 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Files/StoreApps/Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.Appx' -OutFile 'Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.Appx'


Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'

Add-AppxPackage 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
Add-AppxPackage 'Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.Appx'
# Add-AppxPackage 'Microsoft.UI.Xaml.2.7.x64.appx'
Add-AppxPackage 'Microsoft.UI.Xaml.2.8.x64.appx'
Add-AppxPackage 'Microsoft.NET.Native.Framework.1.6_1.6.24903.0_x64__8wekyb3d8bbwe.Appx'
Add-AppxPackage 'Microsoft.NET.Native.Runtime.1.6_1.6.24903.0_x64__8wekyb3d8bbwe.Appx'
Add-AppxPackage 'Microsoft.WindowsStore_11809.1001.713.0_neutral_~_8wekyb3d8bbwe.AppxBundle'

Add-AppxPackage 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'

# Cleanup
Set-Location "$env:temp"
Remove-Item $env:temp\temp -Recurse -Force

Write-Host "Done.`n" -ForegroundColor Green
