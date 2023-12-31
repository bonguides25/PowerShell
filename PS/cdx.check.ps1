Clear-Host
Write-Host "`nDisconnecting from Microsoft Graph...." -ForegroundColor Yellow
Disconnect-Graph
Start-Sleep -Seconds 2
Disconnect-Graph
Clear-Host

$email = Read-Host "Enter the email"
$folder = $email.Split("@")[1]
Write-Host "Tenant: $folder"
Start-Sleep 3
$ClientId          = Get-Content "P:\05.Databases\Cdx\$folder\appid.txt"
$TenantId          = Get-Content "P:\05.Databases\Cdx\$folder\tenantid.txt"
$ClientSecret      = Get-Content "P:\05.Databases\Cdx\$folder\clientSecret.txt"
$ClientSecretPass = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ClientId, $ClientSecretPass
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential
Connect-Windows365 -ClientSecret $ClientSecret -TenantID $TenantId -ClientID $ClientId -Authtype ServicePrincipal

Write-Host
Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')" -OrderBy UserPrincipalName | Format-Table
Write-Host "`nNumber of Cloud PCs: $((Get-CloudPc).Count)"
Get-CloudPC | Select-Object displayName, status, servicePlanName | Format-Table
Write-Host