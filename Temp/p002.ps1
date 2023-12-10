<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
============================================================================================#>
param (
    [switch]$UseChoco,
    [switch]$UseWinget
)

if($UseChoco.IsPresent) {
    $apps = @('telegram', 'firefox','winscp', 'zoom', 'vscode', 'github-desktop')
    Write-Host "`nInstalling Chocolatey (choco)..." -ForegroundColor Cyan
    iex "& { $(irm bonguides.com/choco) } -HideOutput"
    choco feature enable -n allowGlobalConfirmation
    $apps | ForEach-Object {
        Write-Host "`nInstalling $_ ..." -ForegroundColor Green
        choco install $_ -y | Out-Null
    }
}

if ($UseWinget.IsPresent) {
    Write-Host "`nInstalling using Windows Package Manager (winget)..." -ForegroundColor Green
    $apps = @(
        'Telegram.TelegramDesktop', 
        'Mozilla.Firefox',
        'WinSCP.WinSCP',
        'Zoom.Zoom',
        'Microsoft.VisualStudioCode',
        'GitHub.GitHubDesktop'
    )

    $apps | ForEach-Object {
        Write-Host "`nInstalling $_ ..." -ForegroundColor Green
        winget install $_ --silent --accept-source-agreements --accept-package-agreements
    }
}
