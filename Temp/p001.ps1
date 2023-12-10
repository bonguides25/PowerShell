
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Write-Host "`nInstalling using Chocolatey (choco)..." -ForegroundColor Cyan
choco feature enable -n allowGlobalConfirmation
choco.exe install Telegram -y