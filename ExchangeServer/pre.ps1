2<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. 
============================================================================================#>

param (
    [switch]$ex2019,
    [switch]$ex2016
)

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}

function PreEx2019 {

    $path = "$env:temp\temp"
    $null = New-Item -Path $path -ItemType Directory -Force
    Set-Location $path
    $uri = "https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Microsoft/exchange-server/ex2019.zip"
    $filePath = "$path\ex2019.zip"
    (New-Object Net.WebClient).DownloadFile($uri, $filePath)
    Expand-Archive .\*.zip -DestinationPath . -Force | Out-Null
    Invoke-Item $path
    .\rewrite.msi /quiet
    .\vcredist.exe /s
    .\UcmaRuntimeSetup.exe
    
}


# Output options to console, graphical grid view or export to CSV file
if($ex2019.IsPresent) {
    PreEx2019
}

