<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides
Description  : Verify Azure AD Tenant Availability
============================================================================================#>

$domainName = $(Write-Host -NoNewLine) + $(Write-Host "`nProvide the domain name: " -ForegroundColor Yellow -NoNewLine; Read-Host)
$FQDN = $domainName + ".onmicrosoft.com"

if ($FQDN -notmatch "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)") {
    Write-Error -Message ("FQDN used incorrect format: '{0}'." -f $FQDN) -ErrorAction Stop
}

$uri = "https://login.microsoftonline.com/{0}/FederationMetadata/2007-06/FederationMetadata.xml" -f $FQDN

$response = try { 
    (Invoke-WebRequest -Uri $uri -Method GET -ErrorAction Stop).BaseResponse
} catch [System.Net.WebException] { 
    $_.Exception.Response 
}

switch ($response.StatusCode.Value__) {
    200 {
        Write-Host "The tenant name `"$FQDN`" is unavailable." -ForegroundColor Red
    }
    404 {
        Write-Host "The tenant name `"$FQDN`" is available." -ForegroundColor Green
    }
    default {
        Write-Error -Message "Unable to determine result." -ErrorAction Stop
        break;
    }
}