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

param (
    [switch]$OutCSV,
    [switch]$OutGridView
)

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}

# Install the required Microsoft Graph PowerShell SDK modules
    Set-ExecutionPolicy Bypass -Scope Process -Force | Out-Null
    iex "& { $(irm bonguides.com/graph/modulesinstall) } -InstallBasic"

# Connect to Microsoft Graph PowerShell
    $report = @()
    $uri = "https://bonguides.com/files/LicenseFriendlyName.txt"
    $friendlyNameHash = Invoke-RestMethod -Method GET -Uri $uri | ConvertFrom-StringData

    Disconnect-MgGraph -ErrorAction:SilentlyContinue | Out-Null

    Write-Host "Conncting to Microsoft Graph PowerShell..." -ForegroundColor Yellow
    Connect-MgGraph -Scopes "Directory.Read.All" -ErrorAction Stop
    $users  = Get-MgBetaUser -All

# Get licenses assigned to user accounts
    $i = 1
    foreach ($user in $users) {
        Write-Progress -PercentComplete ($i/$($users.Count)*100) -Status "Processing: $($user.UserPrincipalName) - $($user.DisplayName)" -Activity "Processing: ($i/$($users.Count))"
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
        $report += [PSCustomObject]@{
            'DisplayName' = $user.DisplayName
            'UserPrincipalName' = $user.UserPrincipalName
            'Enabled' = $user.accountEnabled
            'Assignedlicenses'=(@($assignedLicense)-join ',')
        }
        $i++
    }

Write-Host "`nDone. Generating report..." -ForegroundColor Yellow

# Output options to console, graphical grid view or export to CSV file
if($OutCSV.IsPresent) {
    $filePath = "$env:userprofile\desktop\report-$(Get-Date -Format yyyy-mm-dd-hh-mm-ss).csv"
    $report | Export-CSV $filePath -NoTypeInformation -Encoding UTF8
    Write-Host "`nThe report is saved to: $filePath `n" -ForegroundColor Cyan
    Invoke-Item "$env:userprofile\desktop"
} elseif ($OutGridView.IsPresent) {
    $report | Out-GridView
} else {
    $report | Sort-Object assignedlicenses -Descending
}
