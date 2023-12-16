$email = Read-Host "Enter the email"
$folder = $email.Split("@")[1]
$ClientId          = Get-Content "P:\05.Databases\Cdx\$folder\appid.txt"
$TenantId          = Get-Content "P:\05.Databases\Cdx\$folder\tenantid.txt"
$ClientSecret      = Get-Content "P:\05.Databases\Cdx\$folder\clientSecret.txt"
$ClientSecretPass = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ClientId, $ClientSecretPass
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential
Connect-Windows365 -ClientSecret $ClientSecret -TenantID $TenantId -ClientID $ClientId -Authtype ServicePrincipal

Write-Host
Get-MgUser -ConsistencyLevel eventual -Count userCount -Filter "startsWith(DisplayName, 'Account')" -OrderBy UserPrincipalName
Write-Host
Get-CloudPC | select displayName, status, servicePlanName
Write-Host