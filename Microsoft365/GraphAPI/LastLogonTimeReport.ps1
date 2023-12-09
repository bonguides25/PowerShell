<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides
Description  : Export Microsoft 365 users' last logon time report using PowerShell

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Single script allows you to generate last login reports.
============================================================================================#>

Invoke-Expression "& { $(Invoke-RestMethod bonguides.com/graph/modulesinstall) } -InstallBetaBasic"

$uri = "https://bonguides.com/files/LicenseFriendlyName.txt"
$FriendlyNameHash = Invoke-RestMethod -Method GET -Uri $uri | ConvertFrom-StringData

$users  = Get-MgBetaUser -All
$Result = @()
#Get licenses assigned to mailboxes
$i = 1
foreach ($user in $users) {
    Write-Progress -Activity "   ($i/$($users.Count)) Processing: $($user.UserPrincipalName) - $($user.DisplayName)"
    $Licenses = (Get-MgBetaUserLicenseDetail -UserId $user.id).SkuPartNumber
    $AssignedLicense = @()
    #Convert license plan to friendly name
    if($Licenses.count -eq 0){
        $AssignedLicense = "Unlicensed"
    } else {
        foreach($License in $Licenses){
            $EasyName = $FriendlyNameHash[$License]
            if(!($EasyName)){
                $NamePrint = $License
            } else {
                $NamePrint = $EasyName
            }
            $AssignedLicense += $NamePrint
        }
    }

    $Result += [PSCustomObject]@{
        'DisplayName' = $user.DisplayName
        'UserPrincipalName' = $user.UserPrincipalName
        'Enabled' = $user.accountEnabled
        'AssignedLicenses'=(@($AssignedLicense)-join ',')
    }
    $i++
}

# Output options to console, graphical grid view or export to CSV file.
$Result | Sort-Object AssignedLicenses -Descending
# $result | Out-GridView
# $result | Export-CSV "C:\Result.csv" -NoTypeInformation -Encoding UTF8
