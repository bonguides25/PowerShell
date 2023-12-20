# Fix for accounts created earlier 
    $email = Read-Host "Enter the email"
    $folder = $email.Split("@")[1]
    Write-Host "Tenant: $folder"

    if (Test-Path "P:\05.Databases\Cdx\$folder") {
        Write-Host "Remoing the old folder..."
        Remove-Item -Path "P:\05.Databases\Cdx\$folder" -Force -ErrorAction Stop
    }

# Connect to Microsoft Graph

    Write-Host "`nDisconnecting from Microsoft Graph...." -ForegroundColor Yellow
    Disconnect-Graph
    Start-Sleep -Seconds 2
    Disconnect-Graph
    Start-Sleep -Seconds 2

    $scopes = @(
        'Directory.ReadWrite.All',
        'User.ReadWrite.All',
        'Application.ReadWrite.All',
        'AppRoleAssignment.ReadWrite.All',
        'RoleManagement.ReadWrite.Directory',
        'DeviceManagementManagedDevices.PrivilegedOperations.All',
        'DeviceManagementManagedDevices.ReadWrite.All',
        'DeviceManagementConfiguration.ReadWrite.All',
        'CloudPC.ReadWrite.All'
    )

    Connect-MgGraph -Scopes $scopes
    Start-Sleep -Seconds 1

# Get tenant information
    $tenantInfo = Get-MgOrganization
    Write-Host "
    Tenant Information:
    Tenant: $($tenantInfo.DisplayName)
    Id    : $($tenantInfo.Id)
    Domain: $((Get-MgDomain).Id)
    " -ForegroundColor Yellow

# Add users to Global Admin role
    Write-Host "Add users to Global Admin role"
    $userIds = (Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')").Id
    $DirectoryRoleId = (Get-MgDirectoryRole | Where-Object {$_.Displayname -eq 'Global Administrator'}).Id
    foreach ($UserId in $userIds) {
        $DirObject = @{ 
            "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$UserId"
        }
        
        New-MgDirectoryRoleMemberByRef -DirectoryRoleId $DirectoryRoleId -BodyParameter $DirObject -ErrorAction:SilentlyContinue
    }

# Create a device group

    $groupx = (Get-MgGroup -ConsistencyLevel eventual -Count groupCount -Search '"DisplayName:All-Cloud-PCs"').Count

    if ($groupx -eq 0) {
        Write-Host "Creating a device group..." -ForegroundColor Yellow
        $GroupParam = @{
            DisplayName = "All-Cloud-PCs"
            GroupTypes = @(
                'DynamicMembership'
            )
            SecurityEnabled     = $true
            IsAssignableToRole  = $false
            MailEnabled         = $false
            membershipRuleProcessingState = 'On'
            MembershipRule = 'device.deviceModel -startsWith "Cloud PC"'
            MailNickname        = "test17"
            "Owners@odata.bind" = @(
                "https://graph.microsoft.com/v1.0/me"
            )
        }
    
        New-MgGroup -BodyParameter $GroupParam | Out-Null
        Start-Sleep 5

    } else {
        Write-Host "The device group is existed..." -ForegroundColor Yellow
    }


# Creating an app registration in Entra ID
    Write-Host "Creating an app registration in Entra ID..." -ForegroundColor Yellow
    $appName =  "testapp-$(Get-Random)"
    $app = New-MgApplication -DisplayName $appName
    $appObjectId = $app.Id

    $passwordCred = @{
        "displayName" = "DemoClientSecret"
        "endDateTime" = (Get-Date).AddMonths(+12)
    }
    $clientSecret = Add-MgApplicationPassword -ApplicationId $appObjectId -PasswordCredential $passwordCred

    $permissionParams = @{
        RequiredResourceAccess = @(
            @{
                ResourceAppId = "00000003-0000-0000-c000-000000000000"
                ResourceAccess = @(
                    @{
                        Id = '19dbc75e-c2e2-444c-a770-ec69d8559fc7'
                        Type = "Role"
                    },
                    @{
                        Id = "741f803b-c850-494e-b5df-cde7c675a1ca"
                        Type = "Role"
                    },
                    @{
                        Id = "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9"
                        Type = "Role"
                    },
                    @{
                        Id = "9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8"
                        Type = "Role"
                    },
                    @{
                        Id = "5b07b0dd-2377-4e44-a38d-703f09a0dc3c"
                        Type = "Role"
                    },
                    @{
                        Id = "243333ab-4d21-40cb-a475-36241daa0842"
                        Type = "Role"
                    },
                    @{
                        Id = "9241abd9-d0e6-425a-bd4f-47ba86e767a4"
                        Type = "Role"
                    },
                    @{
                        Id = "06b708a9-e830-4db3-a914-8e69da51d44f"
                        Type = "Role"
                    }
                    
                )
            }
        )
    }
    Update-MgApplication -ApplicationId $appObjectId -BodyParameter $permissionParams

# Grant admin consent

    Write-Host "Granting admin consent..." -ForegroundColor Yellow
    $graphSpId = $(Get-MgServicePrincipal -Filter "appId eq '00000003-0000-0000-c000-000000000000'").Id
    $sp = New-MgServicePrincipal -AppId $app.appId
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "19dbc75e-c2e2-444c-a770-ec69d8559fc7" -ResourceId $graphSpId | Out-Null
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "741f803b-c850-494e-b5df-cde7c675a1ca" -ResourceId $graphSpId | Out-Null
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9" -ResourceId $graphSpId | Out-Null
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8" -ResourceId $graphSpId | Out-Null
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "5b07b0dd-2377-4e44-a38d-703f09a0dc3c" -ResourceId $graphSpId | Out-Null
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "243333ab-4d21-40cb-a475-36241daa0842" -ResourceId $graphSpId | Out-Null
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "9241abd9-d0e6-425a-bd4f-47ba86e767a4" -ResourceId $graphSpId | Out-Null
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "06b708a9-e830-4db3-a914-8e69da51d44f" -ResourceId $graphSpId | Out-Null
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -PrincipalId $sp.Id -AppRoleId "3b4349e1-8cf5-45a3-95b7-69d1751d3e6a" -ResourceId $graphSpId | Out-Null

    $folder = (Get-MgOrganization).VerifiedDomains.Name
    New-Item -ItemType Directory "P:\05.Databases\Cdx\$folder" -Force | Out-Null

    Write-Host "Generating app-only authentication information..." -ForegroundColor Yellow
    $($app.AppID) >> "P:\05.Databases\Cdx\$folder\appid.txt"
    $((Get-MgOrganization).Id) >> "P:\05.Databases\Cdx\$folder\tenantid.txt"
    $($clientSecret.SecretText) >> "P:\05.Databases\Cdx\$folder\clientSecret.txt"

    Invoke-Item -Path "P:\05.Databases\Cdx\$folder"


    $Seconds = 30
    $EndTime = [datetime]::UtcNow.AddSeconds($Seconds)

    while (($TimeRemaining = ($EndTime - [datetime]::UtcNow)) -gt 0) {
    Write-Progress -Activity 'Waitng for the permissions apply to the app...' -Status Godot -SecondsRemaining $TimeRemaining.TotalSeconds
    Start-Sleep 1
    }


# The app authen has been configured, now disconnect fron delegated session then connect with app-only
# Connect to Microsoft Graph with app-only
    Write-Host "`nDisconnecting from Microsoft Graph...." -ForegroundColor Yellow
    Disconnect-Graph
    Start-Sleep -Seconds 2
    Disconnect-Graph
    Start-Sleep 3
    $ClientId               = Get-Content "P:\05.Databases\Cdx\$folder\appid.txt"
    $TenantId               = Get-Content "P:\05.Databases\Cdx\$folder\tenantid.txt"
    $ClientSecret           = Get-Content "P:\05.Databases\Cdx\$folder\clientSecret.txt"
    $ClientSecretPass       = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
    $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ClientId, $ClientSecretPass
    Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential
    Connect-Windows365 -ClientSecret $ClientSecret -TenantID $TenantId -ClientID $ClientId -Authtype ServicePrincipal

# Get the device list
    $devices = Get-CloudPC | Select-Object managedDeviceName, userPrincipalName, status, servicePlanName
    Write-Host "The List of devices: ($($devices.Count)) ." -ForegroundColor Cyan
    $devices | Format-Table

# Remove any scripts
    Write-Host "1. Removing any scripts." -ForegroundColor Yellow
    Write-Host "    Current: $((Get-MgBetaDeviceManagementScript).DisplayName)" -ForegroundColor Red
    Get-MgBetaDeviceManagementScript | ForEach-Object {
        Remove-MgBetaDeviceManagementScript -DeviceManagementScriptId $_.Id
    }

# Add the new script
    Write-Host "2. Adding a PowerShell script into Intune..." -ForegroundColor Yellow
    $scriptContent = Get-Content "P:\05.Databases\Cdx\all-tsg.ps1" -Raw
    # $encodedScriptContent = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$scriptContent"))
    $params = @{
        "@odata.type" = "#microsoft.graph.deviceManagementScript"
        displayName = "tsg-$(Get-Date -Format "dd-MM-yyyy")"
        description = "all-tsg-new"
        # scriptContent = [System.Text.Encoding]::ASCII.GetBytes("c2NyaXB0Q29udGVudA==")
        scriptContent = [System.Text.Encoding]::ASCII.GetBytes("$scriptContent")
        runAsAccount = "system"
        enforceSignatureCheck = $false
        fileName = "all-tsg-new.ps1"
        roleScopeTagIds = @()
        runAs32Bit = $true
    }

    New-MgBetaDeviceManagementScript -BodyParameter $params | Out-Null
    Write-Host "    New script: $((Get-MgBetaDeviceManagementScript).DisplayName)" -ForegroundColor Green


# Assign the script to a group
    Write-Host "3. Assign the script to a group." -ForegroundColor Yellow
    $devicesGroup = (Get-MgGroup | Where-Object {$_.DisplayName -eq 'All-Cloud-PCs'}).Id
    $scriptIds = (Get-MgBetaDeviceManagementScript).id

    foreach ($scriptId in $scriptIds){
        $params = @{
            deviceManagementScriptGroupAssignments = @(
                @{
                    "@odata.type" = "#microsoft.graph.deviceManagementScriptGroupAssignment"
                    id = $scriptId
                    targetGroupId = $devicesGroup
                }
            )
        }
        
        Set-MgBetaDeviceManagementScript -DeviceManagementScriptId $scriptId -BodyParameter $params
    }

# Reprovisioning Cloud PCs
    Write-Host "4. Reprovisioning Cloud PCs." -ForegroundColor Yellow
    $pcs = Get-CloudPC | Select-Object managedDeviceName, userPrincipalName, status, servicePlanName
    foreach ($pc in $pcs){
        Write-Host "      Reprovisioning $($pc.managedDeviceName)." -ForegroundColor Green
        Invoke-CPCReprovision -Name $pc.managedDeviceName | Out-Null
    }

    Start-Sleep -Seconds 10

# Checking the reprovision status
    Write-Host "5. Checking the reprovision status." -ForegroundColor Yellow
    $status = Get-CloudPC | Select-Object status
    while ($status.status -ccontains 'provisioned') {
        Write-Host "Updating..."
        Start-Sleep -Seconds 10
    }

    Get-CloudPC | Select-Object displayName, status, servicePlanName | Format-Table

    Write-Host "Done.`n" -ForegroundColor Green
