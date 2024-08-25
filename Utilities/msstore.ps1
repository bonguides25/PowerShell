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

# Installing the Microsoft Store on Windows Sandbox only
    if (Test-Path 'C:\Users\WDAGUtilityAccount') {
        Write-Host "`nYou're using Windows Sandbox" -ForegroundColor Yellow
        irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/WindowsSandbox/sandbox-store.ps1 | iex
        exit
    }

# Installing the Microsoft Store on Windows LTSC only
    $edition = (Get-CimInstance Win32_OperatingSystem).Caption
    if ($edition -like "*LTSC*"){
        Write-Host "`nYou're using $edition" -ForegroundColor Yellow
        irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/WindowsLTSC/ltsc-store.ps1 | iex
        exit
    }

