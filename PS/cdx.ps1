Clear-Host
Write-Host "`nDisconnecting from Microsoft Graph...." -ForegroundColor Yellow
Disconnect-Graph
Start-Sleep -Seconds 2
Disconnect-Graph
Clear-Host
$scopes = @('Directory.ReadWrite.All','User.ReadWrite.All')
Connect-MgGraph -Scopes $scopes

$tenantInfo = Get-MgOrganization
Write-Host "
Tenant Information:
Tenant: $($tenantInfo.DisplayName)
Id    : $($tenantInfo.Id)
Domain: $((Get-MgDomain).Id)
" -ForegroundColor Yellow

# Creating users in bulk
Write-Host "Creating user accounts..." -ForegroundColor Yellow 
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
    Write-Host "($item/$($items.Count)) Creating $($params.UserPrincipalName)"  -ForegroundColor Yellow 
    New-MgUser -BodyParameter $params | Out-Null
    Start-Sleep -Seconds 1
}

Start-Sleep 3

$users = Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')" -OrderBy UserPrincipalName
while ($users.Count -lt 6){
Start-Sleep 1
}

Write-Host "`nAssign licenses and add members to group." -ForegroundColor Green
$users = Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')" -OrderBy UserPrincipalName
$groupId = (Get-MgGroup -ConsistencyLevel eventual -Count groupCount -Search '"DisplayName:sg-CloudPCUsers"').Id
$sku1 = (Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -match 'CPC_E_2C_8GB_256GB'}).SkuId
$sku2 = (Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -match 'CPC_E_2C_4GB_128GB​'}).SkuId

$i = 1
foreach ($user in $users) {
    Write-Host "($i/$($users.Count)) Assign licenses to account: $($user.UserPrincipalName)" -ForegroundColor Green
    Set-MgUserLicense -UserId $($user.Id) -Addlicenses @{SkuId = $sku1} -RemoveLicenses @() | Out-Null
    Set-MgUserLicense -UserId $($user.Id) -Addlicenses @{SkuId = $sku2} -RemoveLicenses @() | Out-Null
    $i++
    Start-Sleep 1
}
Write-Host
$i = 1
foreach ($user in $users) {
    Write-Host "($i/$($users.Count)) Adding account to group: $($user.UserPrincipalName)" -ForegroundColor Green
    New-MgGroupMember -GroupId $groupId -DirectoryObjectId $($user.Id) | Out-Null
    $i++
    Start-Sleep 1
}

Start-Sleep 5

# Get user report with license assigments and account status
    $result = @()
    $uri = "https://bonguides.com/files/LicenseFriendlyName.txt"
    $friendlyNameHash = Invoke-RestMethod -Method GET -Uri $uri | ConvertFrom-StringData

    $users  = Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')" -OrderBy UserPrincipalName

    # Get licenses assigned to user accounts
    Write-Host
    $i = 1
    foreach ($user in $users) {
        Write-Host "($i/$($users.Count)) Processing: $($user.UserPrincipalName) - $($user.DisplayName)" -ForegroundColor Cyan
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

# Retrieve the group based on the specified group ID or display name
$groupId = (Get-MgGroup -ConsistencyLevel eventual -Count groupCount -Search '"DisplayName:sg-CloudPCUsers"').Id

$members = Get-MgGroupMember -GroupId $groupId -All

# Initialize an array to store user information
$users = @()

# Iterate through each group member and retrieve user details
foreach ($member in $members) {
    $user = Get-MgUser -UserId $member.Id -ErrorAction SilentlyContinue

    # Add user information to the array
    $Objects = [PSCustomObject][ordered]@{
        Group             = "sg-CloudPCUsers"
        Name              = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
    }

    # Add the ordered custom object to the array
    $users += $Objects
}

# Export user information
$users

Write-Host "Done." -ForegroundColor Green
Write-Host "Disconnecting from Microsoft Graph.`n" -ForegroundColor Green

Disconnect-Graph





