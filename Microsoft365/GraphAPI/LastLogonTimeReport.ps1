<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides
Description  : Export Microsoft 365 users' last logon time report using PowerShell

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Single script allows you to generate last login reports.
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    # Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm  | iex"
    break
}

# Install the required Microsoft Graph PowerShell SDK modules
    Invoke-Expression "& { $(Invoke-RestMethod bonguides.com/graph/modulesinstall) } -InstallBetaBasic"

# Get last login time report for list of users including account status and license assignment
    $uri = "https://bonguides.com/files/LicenseFriendlyName.txt"
    $friendlyNameHash = Invoke-RestMethod -Method GET -Uri $uri | ConvertFrom-StringData

    Connect-MgGraph -Scopes "Directory.Read.All" | Out-Null

    $users  = Get-MgBetaUser -All
    $result = @()
    #Get licenses assigned to mailboxes
    $i = 1
    foreach ($user in $users) {
        Write-Progress -Activity "   ($i/$($users.Count)) Processing: $($user.UserPrincipalName) - $($user.DisplayName)"
        $Licenses = (Get-MgBetaUserLicenseDetail -UserId $user.id).SkuPartNumber
        $AssignedLicense = @()
        #Convert license plan to friendly name
        if($Licenses.count -eq 0){
            $AssignedLicense = "Unlicensed"
        } else {
            foreach($License in $Licenses){
                $EasyName = $friendlyNameHash[$License]
                if(!($EasyName)){
                    $NamePrint = $License
                } else {
                    $NamePrint = $EasyName
                }
                $AssignedLicense += $NamePrint
            }
        }

        $Result += [PSCustomObject]@{
            'DisplayName' = $user.DisplayName
            'UserPrincipalName' = $user.UserPrincipalName
            'Enabled' = $user.accountEnabled
            'AssignedLicenses'=(@($AssignedLicense)-join ',')
        }
        $i++
    }

    # Output options to console, graphical grid view or export to CSV file.
        $Result | Sort-Object AssignedLicenses -Descending 
        # $result | Out-GridView
        # $result | Export-CSV "C:\Result.csv" -NoTypeInformation -Encoding UTF8