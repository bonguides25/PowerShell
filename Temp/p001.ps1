
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$apps = @('telegram', 'firefox','winscp', 'zoom', 'vscode', 'github-desktop')
choco feature enable -n allowGlobalConfirmation

Write-Host
$apps | ForEach-Object {
    Write-Host "Installing $_..." -ForegroundColor Green
    choco install $_ -y | Out-Null
}

Write-Host "`nDone." -ForegroundColor Green
