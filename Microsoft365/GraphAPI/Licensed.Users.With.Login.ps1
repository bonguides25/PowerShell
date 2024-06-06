<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. 
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
    Invoke-RestMethod 'bonguides.com/psdeps' | Invoke-Expression

    $installedModule1 = Get-InstalledModule -Name 'Microsoft.Graph.Users' -ErrorAction SilentlyContinue
    if ($null -eq $installedModule1) {
        Install-Module -Name 'Microsoft.Graph.Users' -Scope CurrentUser
        Install-Module -Name 'Microsoft.Graph.Beta.Users' -Scope CurrentUser -AllowClobber
    }

    $installedModule2 = Get-InstalledModule -Name 'Microsoft.Graph.Authentication' -ErrorAction SilentlyContinue
    if ($null -eq $installedModule2) {
        Install-Module -Name 'Microsoft.Graph.Authentication' -Scope CurrentUser -AllowClobber
    }

# Connect to Microsoft Graph PowerShell
    # Disconnect-MgGraph -ErrorAction:SilentlyContinue | Out-Null

    Write-Host "Connecting to Microsoft Graph PowerShell..." -ForegroundColor Yellow
    Connect-MgGraph -Scopes "Directory.Read.All", 'AuditLog.Read.All' -ErrorAction Stop
    $users  = Get-MgUser -All -Property UserPrincipalName, DisplayName, SignInActivity

# Get licenses assigned to user accounts
    $report = @()
    Invoke-WebRequest -Uri "https://download.microsoft.com/download/e/3/e/e3e9faf2-f28b-490a-9ada-c6089a1fc5b0/Product%20names%20and%20service%20plan%20identifiers%20for%20licensing.csv" -OutFile "$env:temp\LicenseNames.csv"
    $translationTable = Import-Csv "$env:temp\LicenseNames.csv"

    $i = 1
    foreach ($user in $users) {
        Write-Progress -PercentComplete ($i/$($users.Count)*100) -Status "Processing: $($user.UserPrincipalName) - $($user.DisplayName)" -Activity "Processing: ($i/$($users.Count))"
        $licenses = (Get-MgBetaUserLicenseDetail -UserId $user.id)
        $assignedLicense = @()
        
        # Convert license plan to friendly name
        if($licenses.count -eq 0){
            $assignedLicense = "Unlicensed"
        } else {
            foreach($License in $licenses){
                $skuNamePretty = ($translationTable | Where-Object {$_.GUID -eq $License.skuId} | Sort-Object Product_Display_Name -Unique).Product_Display_Name

                if(!($skuNamePretty)){
                    $NamePrint = $License
                } else {
                    $NamePrint = $skuNamePretty
                }
                $assignedLicense += $NamePrint
            }
        }

        # Creating the custom report
        $report += [PSCustomObject]@{
            'DisplayName' = $user.DisplayName
            'UserPrincipalName' = $user.UserPrincipalName
            'Enabled' = $user.accountEnabled
            'Assignedlicenses' = (@($assignedLicense)-join ',')
            'LastSignInDateTime' = $user.SignInActivity.LastSignInDateTime.ToString("M/d/yyyy")
        }
        $i++
    }

Write-Host "`nDone. Generating report..." -ForegroundColor Yellow

# Output options to console, graphical grid view or export to CSV file
if($OutCSV.IsPresent) {
    New-Item -Path "$env:userprofile\desktop\Outputbg" -ItemType Directory -Force
    $filePath = "$env:userprofile\desktop\Outputbg\report-$(Get-Date -Format yyyy-mm-dd-hh-mm-ss).csv"
    $report | Export-CSV $filePath -NoTypeInformation -Encoding UTF8
    Write-Host "`nThe report is saved to: $filePath `n" -ForegroundColor Cyan
    Invoke-Item "$env:userprofile\desktop\Outputbg"
} elseif ($OutGridView.IsPresent) {
    $report | Out-GridView
} else {
    $report | Sort-Object assignedlicenses -Descending | Format-Table
}
