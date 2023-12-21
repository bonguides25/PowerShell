$emails = @(
'M365t52469193.onmicrosoft.com',
'M365t78294782.onmicrosoft.com',
'M365t59825269.onmicrosoft.com',
'M365t23540883.onmicrosoft.com',
'M365t64434580.onmicrosoft.com',
'M365t67606670.onmicrosoft.com',
'M365t59435187.onmicrosoft.com',
'M365t12936856.onmicrosoft.com',
'M365t35955289.onmicrosoft.com',
'M365t88850504.onmicrosoft.com',
'M365t49155465.onmicrosoft.com',
'M365t17003662.onmicrosoft.com',
'M365t38195554.onmicrosoft.com',
'M365t84426586.onmicrosoft.com',
'M365t27719971.onmicrosoft.com',
'M365t17767234.onmicrosoft.com',
'M365t19286583.onmicrosoft.com',
'M365t48939080.onmicrosoft.com',
'M365t16013629.onmicrosoft.com',
'M365t66541549.onmicrosoft.com',
'M365t13870449.onmicrosoft.com',
'M365t91311484.onmicrosoft.com',
'M365t17825644.onmicrosoft.com',
'M365t79555651.onmicrosoft.com',
'M365t02018211.onmicrosoft.com',
'M365t12678753.onmicrosoft.com',
'M365t63474516.onmicrosoft.com',
'M365t23347570.onmicrosoft.com',
'M365t20883608.onmicrosoft.com',
'M365t66450166.onmicrosoft.com',
'M365t49577060.onmicrosoft.com',
'M365t99619573.onmicrosoft.com',
'M365t49276589.onmicrosoft.com',
'M365t51699621.onmicrosoft.com',
'M365t36299605.onmicrosoft.com',
'M365t86044316.onmicrosoft.com',
'M365t01523190.onmicrosoft.com',
'M365t72925540.onmicrosoft.com',
'M365t59167831.onmicrosoft.com',
'M365t39823312.onmicrosoft.com',
'M365t48116340.onmicrosoft.com',
'M365t33920249.onmicrosoft.com',
'M365t34600511.onmicrosoft.com',
'M365t94833368.onmicrosoft.com',
'M365t86782796.onmicrosoft.com',
'M365t13478671.onmicrosoft.com',
'M365t41251267.onmicrosoft.com',
'M365t58302718.onmicrosoft.com',
'M365t50165701.onmicrosoft.com',
'M365t08155677.onmicrosoft.com',
'M365t58593876.onmicrosoft.com',
'M365t32622584.onmicrosoft.com',
'M365t15973045.onmicrosoft.com',
'M365t68691598.onmicrosoft.com',
'M365t14798549.onmicrosoft.com',
'M365t00988977.onmicrosoft.com',
'M365t31108606.onmicrosoft.com',
'M365t52455515.onmicrosoft.com',
'M365t45363886.onmicrosoft.com',
'M365t47416792.onmicrosoft.com',
'M365t78591307.onmicrosoft.com',
'M365t24751156.onmicrosoft.com',
'M365t08142469.onmicrosoft.com',
'M365t73705057.onmicrosoft.com',
'M365t77653011.onmicrosoft.com',
'M365t78066047.onmicrosoft.com',
'M365t68254650.onmicrosoft.com',
'M365t63388961.onmicrosoft.com',
'M365t34226053.onmicrosoft.com'
)


# Connect to Microsoft Graph
foreach ($email in $emails){

    Write-Host "Tenant: $email"
    Start-Sleep 2
    $ClientId               = Get-Content "P:\05.Databases\Cdx\$email\appid.txt"
    $TenantId               = Get-Content "P:\05.Databases\Cdx\$email\tenantid.txt"
    $ClientSecret           = Get-Content "P:\05.Databases\Cdx\$email\clientSecret.txt"
    $ClientSecretPass       = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
    $ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ClientId, $ClientSecretPass
    Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential
    # Connect-Windows365 -ClientSecret $ClientSecret -TenantID $TenantId -ClientID $ClientId -Authtype ServicePrincipal

    # Cleanup the scripts without re-provision
    Write-Host "Removing scripts added to $($email)." -ForegroundColor Yellow
    Write-Host "    Current: $((Get-MgBetaDeviceManagementScript).DisplayName)" -ForegroundColor Red
    Get-MgBetaDeviceManagementScript | ForEach-Object {
        Remove-MgBetaDeviceManagementScript -DeviceManagementScriptId $_.Id
    }

}
