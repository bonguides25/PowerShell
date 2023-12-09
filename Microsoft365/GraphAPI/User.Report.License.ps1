<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Single script allows you to generate user report with license assigments and account status
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    # Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm  | iex"
    break
}

# Check installed required modules then Install the Microsoft Graph PowerShell SDK modules if needed
    Invoke-Expression "& { $(Invoke-RestMethod bonguides.com/graph/modulesinstall) } -InstallBetaBasic"

# Get user report with license assigments and account status
    $result = @()
    $uri = "https://bonguides.com/files/LicenseFriendlyName.txt"
    $friendlyNameHash = Invoke-RestMethod -Method GET -Uri $uri | ConvertFrom-StringData

    Connect-MgGraph -Scopes "Directory.Read.All" | Out-Null
    $users  = Get-MgBetaUser -All

    # Get licenses assigned to user accounts
    $i = 1
    foreach ($user in $users) {
        Write-Progress -Activity "   ($i/$($users.Count)) Processing: $($user.UserPrincipalName) - $($user.DisplayName)"
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
        
        # Creating report object
        $result += [PSCustomObject]@{
            'DisplayName' = $user.DisplayName
            'UserPrincipalName' = $user.UserPrincipalName
            'Enabled' = $user.accountEnabled
            'Assignedlicenses'=(@($assignedLicense)-join ',')
        }
        $i++
    }

    # Output options to console, graphical grid view or export to CSV file.
        $result | Sort-Object assignedlicenses -Descending 
        # $result | Out-GridView
        # $result | Export-CSV "C:\Result.csv" -NoTypeInformation -Encoding UTF8
