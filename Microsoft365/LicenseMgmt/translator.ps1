<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides
============================================================================================#>
param (
    [switch]$OutCSV,
    [switch]$OutGridView
)

$skus = Get-MgSubscribedSku -All
$translationTable = Invoke-RestMethod -Method GET -Uri "https://download.microsoft.com/download/e/3/e/e3e9faf2-f28b-490a-9ada-c6089a1fc5b0/Product%20names%20and%20service%20plan%20identifiers%20for%20licensing.csv" | ConvertFrom-Csv

$output = @()
foreach ($sku in $skus) {
    $skuNamePretty = ($translationTable | Where-Object {$_.GUID -eq $sku.skuId} | Sort-Object Product_Display_Name -Unique).Product_Display_Name
    $skuDetails = [PSCustomObject][Ordered]@{
        LicenseName   = $skuNamePretty
        SkuPartNumber = $Sku.SkuPartNumber
        SkuId         = $Sku.SkuId
        ActiveUnits   = $Sku.PrepaidUnits.Enabled
        ConsumedUnits = $Sku.ConsumedUnits

    }
    $output += $skuDetails
}

if($OutCSV.IsPresent) {
    # $result | Sort-Object assignedlicenses -Descending 
    # $result | Out-GridView
    $filePath = "$env:userprofile\desktop\Result-$(Get-Date -Format yyyy-mm-dd-hh-mm-ss).csv"
    $result | Export-CSV $filePath -NoTypeInformation -Encoding UTF8
    Write-Host "The report is saved to: $filePath `n" -ForegroundColor Cyan
    Invoke-Item "$env:userprofile\desktop"
} elseif ($OutGridView.IsPresent) {
    $output | Out-GridView
} else {
    $output | Format-Table
}
