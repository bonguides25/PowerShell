Clear-Host
Write-Host "`nDisconnecting from Microsoft Graph...." -ForegroundColor Yellow
Disconnect-Graph
Start-Sleep -Seconds 2
Disconnect-Graph
Clear-Host

# Connect to Microsoft Graph
    $email = Read-Host "Enter the email"
    $folder = $email.Split("@")[1]
    Write-Host "Tenant: $folder"
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
    $scriptContent = Get-Content "P:\05.Databases\Cdx\all-svn.ps1" -Raw
    # $encodedScriptContent = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$scriptContent"))
    $params = @{
        "@odata.type" = "#microsoft.graph.deviceManagementScript"
        displayName = "svn-$(Get-Date -Format "dd-MM-yyyy")"
        description = "all-svn-new"
        # scriptContent = [System.Text.Encoding]::ASCII.GetBytes("c2NyaXB0Q29udGVudA==")
        scriptContent = [System.Text.Encoding]::ASCII.GetBytes("$scriptContent")
        runAsAccount = "system"
        enforceSignatureCheck = $false
        fileName = "all-svn-new.ps1"
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

    Get-CloudPC | Select-Object displayName, status,userPrincipalName,  servicePlanName | Format-Table

    Write-Host "Done.`n" -ForegroundColor Green

