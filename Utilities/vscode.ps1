<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Install Microsoft Store on Windows Sandbox (winget).
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}

# Create temporary directory
$null = New-Item -Path $env:temp\temp -ItemType Directory -Force
Set-Location $env:temp\temp

$progressPreference = 'silentlyContinue'
Write-Host "`nInstalling Visual Studio Code (VSCode)..." -ForegroundColor Yellow

Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?LinkID=623230" -OutFile 'vscode-install.exe'

# Install Options
# I'm using /silent, use /verysilent for no UI
# Install with the context menu, file association, and add to path options (and don't run code after install: 
$installerArguments = "/silent /mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"

#Install with default options, and don't run code after install.
#$installerArguments = "/silent /mergetasks='!runcode'"

Start-Process vscode-install.exe -ArgumentList $installerArguments -Wait

# Cleanup
Write-Host "Cleanup the downloaded file." -ForegroundColor Yellow
Set-Location "$env:temp"
Remove-Item $env:temp\temp -Recurse -Force
