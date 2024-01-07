<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Export Office 365 users MFA status with PowerShell
============================================================================================#>

param (
    [switch]$OutCSV,
    [switch]$OutGridView
)

#Check for module installation
$module =  Get-Module 'MSOnline' -ListAvailable
    if($null -eq $module) {
    Write-host "Important: MSOnline module is unavailable. It is mandatory to have this module installed in the system to run the script successfully." 
    $confirm = Read-Host Are you sure you want to install MSOnline module? [Y] Yes [N] No  
    if($confirm -match "[yY]") { 
        Write-host "Installing MSOnline module..."
        Install-Module MSOnline -Scope CurrentUser
        Write-host "MSOnline module is installed in the machine successfully" -ForegroundColor Magenta 
    } else { 
        Write-host "Exiting. `nNote: MSOnline module must be available in your system to run the script" -ForegroundColor Red
        Exit 
    } 
}

Write-Host "Finding Azure Active Directory Accounts..."
$Users = Get-MsolUser -All | Where-Object { $_.UserType -ne "Guest" }
$Report = [System.Collections.Generic.List[Object]]::new() # Create output file
Write-Host "Processing" $Users.Count "accounts..." 
ForEach ($User in $Users) {

    $MFADefaultMethod = ($User.StrongAuthenticationMethods | Where-Object { $_.IsDefault -eq "True" }).MethodType
    $MFAPhoneNumber = $User.StrongAuthenticationUserDetails.PhoneNumber
    $PrimarySMTP = $User.ProxyAddresses | Where-Object { $_ -clike "SMTP*" } | ForEach-Object { $_ -replace "SMTP:", "" }
    $Aliases = $User.ProxyAddresses | Where-Object { $_ -clike "smtp*" } | ForEach-Object { $_ -replace "smtp:", "" }

    If ($User.StrongAuthenticationRequirements) {
        $MFAState = $User.StrongAuthenticationRequirements.State
    }
    Else {
        $MFAState = 'Disabled'
    }

    If ($MFADefaultMethod) {
        Switch ($MFADefaultMethod) {
            "OneWaySMS" { $MFADefaultMethod = "Text code authentication phone" }
            "TwoWayVoiceMobile" { $MFADefaultMethod = "Call authentication phone" }
            "TwoWayVoiceOffice" { $MFADefaultMethod = "Call office phone" }
            "PhoneAppOTP" { $MFADefaultMethod = "Authenticator app or hardware token" }
            "PhoneAppNotification" { $MFADefaultMethod = "Microsoft authenticator app" }
        }
    }
    Else {
        $MFADefaultMethod = "Not enabled"
    }
  
    $ReportLine = [PSCustomObject] @{
        UserPrincipalName = $User.UserPrincipalName
        DisplayName       = $User.DisplayName
        MFAState          = $MFAState
        MFADefaultMethod  = $MFADefaultMethod
        MFAPhoneNumber    = $MFAPhoneNumber
        PrimarySMTP       = ($PrimarySMTP -join ',')
        Aliases           = ($Aliases -join ',')
    }
                 
    $Report.Add($ReportLine)
}


if($OutCSV.IsPresent) {
    $Report | Sort-Object UserPrincipalName | Export-CSV -Encoding UTF8 -NoTypeInformation "c:\temp\MFAUsers.csv"
    Write-Host "Report is in c:\temp\MFAUsers.csv"
}

if($OutGridView.IsPresent) {
    $Report | Select-Object UserPrincipalName, DisplayName, MFAState, MFADefaultMethod, MFAPhoneNumber, PrimarySMTP, Aliases | Sort-Object UserPrincipalName | Out-GridView
}

$Report | Select-Object UserPrincipalName, DisplayName, MFAState, MFADefaultMethod, MFAPhoneNumber, PrimarySMTP, Aliases | Sort-Object UserPrincipalName
