<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
============================================================================================#>

Write-Host "`nInstalling Chocolatey Package Manager..." -ForegroundColor Green
iex "& { $(irm bonguides.com/choco) } -HideOutput"

$apps = @('telegram', 'firefox','winscp', 'zoom', 'vscode', 'github-desktop')
choco feature enable -n allowGlobalConfirmation

Write-Host
$apps | ForEach-Object {
    Write-Host "Installing $_..." -ForegroundColor Green
    choco install $_ -y | Out-Null
}

Write-Host "`nDone." -ForegroundColor Green
