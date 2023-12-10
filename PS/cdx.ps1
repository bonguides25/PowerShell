

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
        Write-Progress -Activity "Creating $($params.UserPrincipalName)" -Status "Created: $item of $($items.Count)"
        New-MgUser -BodyParameter $params
    }

Start-Sleep 5

Write-Host "Assign licenses and add members to group." -ForegroundColor Green
$users = Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')" -OrderBy UserPrincipalName
$groupId = (Get-MgGroup -ConsistencyLevel eventual -Count groupCount -Search '"DisplayName:sg-CloudPCUsers"').Id
$sku1 = (Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -match 'CPC_E_2C_8GB_256GB'}).SkuId
$sku2 = (Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -match 'CPC_E_2C_4GB_128GB​'}).SkuId

while ($users.Count -lt 6) {
    Start-Sleep 1
}

$i = 1
foreach ($user in $users) {
    Write-Host "($i/$($users.Count) Processing account: $($user.UserPrincipalName)" -ForegroundColor Green
    Set-MgUserLicense -UserId $($user.Id) -Addlicenses @{SkuId = $sku1} -RemoveLicenses @() | Out-Null
    Set-MgUserLicense -UserId $($user.Id) -Addlicenses @{SkuId = $sku2} -RemoveLicenses @() | Out-Null
    New-MgGroupMember -GroupId $groupId -DirectoryObjectId $($user.Id) | Out-Null
    $i++
}

Write-Host "List of members:" -ForegroundColor Green
Get-MgGroupMember -GroupId $groupId | select AdditionalProperties

Write-Host "Done." -ForegroundColor Green
Write-Host "Disconnecting from Microsoft Graph.`n" -ForegroundColor Green

Disconnect-Graph





