<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Single script allows you to generate user report with roles assignments
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

# Get user report with license assigments and account status

    Disconnect-MgGraph -ErrorAction:SilentlyContinue | Out-Null

    Write-Host "Conncting to Microsoft Graph PowerShell..." -ForegroundColor Yellow
    Connect-MgGraph -Scopes 'Directory.Read.All', 'User.Read.All' -ErrorAction Stop

    $users  = Get-MgBetaUser -All

    # Get licenses assigned to user accounts
    $i = 1
    $Roles = @()
    $report = @()
    foreach ($user in $users) {
        #Get roles assigned to user
        Write-Host "($i/$($users.Count)) Processing: $($user.UserPrincipalName) - $($user.DisplayName)" -ForegroundColor Green
        $Roles = Get-MgUserTransitiveMemberOf -UserId $user.Id | Select-Object -ExpandProperty AdditionalProperties
        $Roles = $Roles | Where-Object{$_.'@odata.type' -eq '#microsoft.graph.directoryRole'} 
        if($Roles.count -eq 0) { 
            $RolesAssigned = "No roles" 
        } else { 
            $RolesAssigned = @($Roles.displayName) -join ',' 
        } 

        # Creating the custom report
        $report += [PSCustomObject]@{
            'DisplayName' = $user.DisplayName
            'UserPrincipalName' = $user.UserPrincipalName
            'Enabled' = $user.accountEnabled
            'Roles' = $RolesAssigned
        }
        $i++
    }

# Output options to console, graphical grid view or export to CSV file

if($OutCSV.IsPresent) {
    $filePath = "$env:userprofile\desktop\report-$(Get-Date -Format yyyy-mm-dd-hh-mm-ss).csv"
    $report | Export-CSV $filePath -NoTypeInformation -Encoding UTF8
    Write-Host "`nThe report is saved to: $filePath `n" -ForegroundColor Cyan
    Invoke-Item "$env:userprofile\desktop"
} elseif ($OutGridView.IsPresent) {
    $report | Out-GridView
} else {
    $report | Sort-Object -Property Roles -Descending
}
