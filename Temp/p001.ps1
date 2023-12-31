<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
============================================================================================#>

Write-Host "`nInstalling Chocolatey Package Manager ..." -ForegroundColor Yellow
iex "& { $(irm bonguides.com/choco) } -HideOutput"
choco feature enable -n allowGlobalConfirmation

$i = 1
$apps = @('telegram', 'firefox','winscp', 'zoom', 'vscode', 'github-desktop')

$apps | ForEach-Object {
    Write-Host
    Write-Host "($i/$($apps.Count)) Installing $_..." -ForegroundColor Green
    choco install $_ -y | Out-Null
    $i++
}

Write-Host "`nDone." -ForegroundColor Green