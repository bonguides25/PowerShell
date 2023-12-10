

Disconnect-Graph
Start-Sleep -Seconds 1
Disconnect-Graph


$scopes = @('Directory.ReadWrite.All','User.ReadWrite.All')
Connect-MgGraph -Scopes $scopes

# Creating users in bulk

    $domain = Get-MgDomain | select -ExpandProperty Id
    $items = @(1..6)
    foreach ($item in $items) {
        $params = @{
            AccountEnabled = $true
            DisplayName = "Account$item"
            UserPrincipalName = "account$item@$domain"
            MailNickname = "account$item"
            UsageLocation = 'US'
            PasswordProfile = @{
                ForceChangePasswordNextSignIn = $false
                Password = 'Nttg$ti74fnff[gr4]'
            }
        }
        Write-Host "($item/$($items.Count)) Creating $($params.UserPrincipalName)"
        New-MgUser -BodyParameter $params | Out-Null
    }

Start-Sleep 5

Write-Host "Assign licenses and add members to group." -ForegroundColor Green
$users = Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')" -OrderBy UserPrincipalName
$groupId = (Get-MgGroup -ConsistencyLevel eventual -Count groupCount -Search '"DisplayName:sg-CloudPCUsers"').Id
$sku1 = (Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -match 'CPC_E_2C_8GB_256GB'}).SkuId
$sku2 = (Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -match 'CPC_E_2C_4GB_128GB​'}).SkuId

# Get user report with license assigments and account status
    $result = @()
    $uri = "https://bonguides.com/files/LicenseFriendlyName.txt"
    $friendlyNameHash = Invoke-RestMethod -Method GET -Uri $uri | ConvertFrom-StringData

    $users  = Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')" -OrderBy UserPrincipalName

    # Get licenses assigned to user accounts
    $i = 1
    foreach ($user in $users) {
        Write-Host "($i/$($users.Count)) Processing: $($user.UserPrincipalName) - $($user.DisplayName)" -ForegroundColor Green
        $licenses = (Get-MgBetaUserLicenseDetail -UserId $user.id).SkuPartNumber
        $assignedLicense = @()
    # Convert license plan to friendly name
        if($licenses.count -eq 0){
            $assignedLicense = "Unlicensed"
        } else {
        
        foreach($License in $licenses){
            $EasyName = $friendlyNameHash[$License]
            if(!($EasyName)){
                $NamePrint = $License
            } else {
                $NamePrint = $EasyName
        }
        $assignedLicense += $NamePrint
    }
    }

    # Creating the custom report
        $result += [PSCustomObject]@{
            'DisplayName' = $user.DisplayName
            'UserPrincipalName' = $user.UserPrincipalName
            'Assignedlicenses'=(@($assignedLicense)-join ',')
        }
        $i++
        }
    
    Write-Host "`nDone. Generating report..." -ForegroundColor Yellow
    $result | Sort-Object assignedlicenses -Descending | Format-Table

$i = 1
foreach ($user in $users) {
    Write-Host "($i/$($users.Count)) Processing account: $($user.UserPrincipalName)" -ForegroundColor Green
    Set-MgUserLicense -UserId $($user.Id) -Addlicenses @{SkuId = $sku1} -RemoveLicenses @() | Out-Null
    Set-MgUserLicense -UserId $($user.Id) -Addlicenses @{SkuId = $sku2} -RemoveLicenses @() | Out-Null
    New-MgGroupMember -GroupId $groupId -DirectoryObjectId $($user.Id) | Out-Null
    $i++
}

Write-Host "List of members:" -ForegroundColor Green
Get-MgGroupMember -GroupId $groupId | select AdditionalProperties

Write-Host "Done." -ForegroundColor Green
Write-Host "Disconnecting from Microsoft Graph.`n" -ForegroundColor Green

Start-Sleep 30

Get-MgDevice

Start-Sleep 30

Get-MgDevice

Start-Sleep 30

Get-MgDevice

Disconnect-Graph





