
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "`nInstalling apps using Chocolatey (choco)..." -ForegroundColor Green
choco feature enable -n allowGlobalConfirmation
choco install Telegram -y
choco install firefox -y
choco install winscp -y
choco install zoom -y
choco install vscode -y
choco install github-desktop -y

Write-Host "`nDone." -ForegroundColor Green
