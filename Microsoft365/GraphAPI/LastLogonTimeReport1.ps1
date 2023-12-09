iex "& { $(irm bonguides.com/graph/modulesinstall) } -InstallBetaBasic"

Connect-MgGraph -Scopes "Directory.Read.All" -ErrorAction SilentlyContinue -Errorvariable ConnectionError | Out-Null

$uri = "https://bonguides.com/files/LicenseFriendlyName.txt"

$FriendlyNameHash = Invoke-RestMethod -Method GET -Uri $uri | ConvertFrom-StringData

$users  = Get-MgBetaUser -All
$Result = @()
#Get licenses assigned to mailboxes
foreach ($user in $users) {
    Write-Progress -Activity "`n     Processing account: $($user.UserPrincipalName) - $($user.DisplayName)"
    $Licenses = (Get-MgBetaUserLicenseDetail -UserId $user.id).SkuPartNumber
    $AssignedLicense = @()
    #Convert license plan to friendly name
    if($Licenses.count -eq 0){
        $AssignedLicense = "No License Assigned"
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
        'AccountEnabled' = $user.accountEnabled
        'AssignedLicenses'=(@($AssignedLicense)-join ',')
    }
}

# Output options to console, graphical grid view or export to CSV file.
$Result | Sort-Object AssignedLicenses -Descending
# $result | Out-GridView
# $result | Export-CSV "C:\Result.csv" -NoTypeInformation -Encoding UTF8
