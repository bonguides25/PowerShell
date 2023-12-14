<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Single script allows you to generate licenses/ subscriptions report
============================================================================================#>

param (
    [switch]$OutCSV,
    [switch]$OutGridView
)

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    # Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm  | iex"
    break
}

# Install the required Microsoft Graph PowerShell SDK modules
    Set-ExecutionPolicy Bypass -Scope Process -Force | Out-Null
    iex "& { $(irm bonguides.com/graph/modulesinstall) } -InstallLicMgmt"

# Connect to Microsoft Graph
    Disconnect-MgGraph -ErrorAction:SilentlyContinue | Out-Null
    Write-Host "Conncting to Microsoft Graph PowerShell..." -ForegroundColor Yellow
    Connect-MgGraph -Scopes "Directory.Read.All" -ErrorAction Stop -NoWelcome

# Caching the information into variables
    $skus = Get-MgSubscribedSku -All
    $renewalData = Get-MgBetaDirectorySubscription -All
    $translationTable = Invoke-RestMethod -Method GET -Uri "https://bonguides.com/ms/skus" | ConvertFrom-Csv

# Create the report with the renewal information
    $skuReport = @()
    foreach ($sku in $skus) {
        $expireDate = $renewalData | Where-Object {$_.skuId -match $($sku.SkuId)}
        $skuNamePretty = ($translationTable | Where-Object {$_.GUID -eq $sku.skuId} | Sort-Object Product_Display_Name -Unique).Product_Display_Name

        if ($expireDate.nextLifecycleDateTime) {
            $DaysToRenewal = ($expireDate.nextLifecycleDateTime - $((Get-Date).Date)).Days
        } else {
            $DaysToRenewal = $null
        }

        $object = [PSCustomObject][Ordered]@{
            LicenseName   = $skuNamePretty
            SkuPartNumber = $Sku.SkuPartNumber
            SkuId         = $Sku.SkuId
            ActiveUnits   = $Sku.PrepaidUnits.Enabled
            ConsumedUnits = $Sku.ConsumedUnits
            RenewalDate   = $expireDate.nextLifecycleDateTime
            DaysToRenewal = $DaysToRenewal
        }
        $skuReport += $object
    }

# Output options to console, graphical grid view or export to CSV file
    if($OutCSV.IsPresent) {
        $filePath = "$env:userprofile\desktop\result-$(Get-Date -Format yyyy-mm-dd-hh-mm-ss).csv"
        $skuReport | Export-CSV $filePath -NoTypeInformation -Encoding UTF8
        Write-Host "`nThe report is saved to: $filePath `n" -ForegroundColor Cyan
        Invoke-Item "$env:userprofile\desktop"
    } elseif ($OutGridView.IsPresent) {
        $skuReport | Out-GridView
    } else {
        $skuReport | Format-Table
    }
