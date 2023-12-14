

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

# Output options to console, graphical grid view or export to CSV file.
$skuReport | Format-Table
# $skuReport | Out-GridView -Title "License Report"
# $skuReport | Export-Csv 'C:\Temp\report.csv' -Nti -Encoding UTF8
