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

# Install the required Microsoft Graph PowerShell SDK modules
    Set-ExecutionPolicy Bypass -Scope Process -Force | Out-Null
    iex "& { $(irm bonguides.com/graph/modulesinstall) } -InstallBasic"

# Get user report with license assigments and account status
    $result = @()
    $uri = "https://bonguides.com/files/LicenseFriendlyName.txt"
    $friendlyNameHash = Invoke-RestMethod -Method GET -Uri $uri | ConvertFrom-StringData

    Disconnect-MgGraph -ErrorAction:SilentlyContinue | Out-Null

    Write-Host "Conncting to Microsoft Graph PowerShell..." -ForegroundColor Yellow
    Connect-MgGraph -Scopes "Directory.Read.All" -ErrorAction Stop
    $users  = Get-MgBetaUser -All

    # Get licenses assigned to user accounts
    $i = 1
    foreach ($user in $users) {
        Write-Host "($i/$($users.Count)) Processing: $($user.UserPrincipalName) - $($user.DisplayName)" -ForegroundColor Green
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
            'Enabled' = $user.accountEnabled
            'Assignedlicenses'=(@($assignedLicense)-join ',')
        }
        $i++
    }

    Write-Host "`nDone. Generating report..." -ForegroundColor Yellow

    # Output options to console, graphical grid view or export to CSV file.
        # $result | Sort-Object assignedlicenses -Descending 
        # $result | Out-GridView
        $filePath = "$env:userprofile\desktop\Result-$(Get-Date -Format yyyy-mm-dd-hh-mm-ss).csv"
        $result | Export-CSV $filePath -NoTypeInformation -Encoding UTF8
        Write-Host "The report is saved to: $filePath `n" -ForegroundColor Cyan

    Invoke-Item "$env:userprofile\desktop"
