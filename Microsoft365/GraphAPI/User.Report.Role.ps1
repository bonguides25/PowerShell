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
    [switch]$InstallMainBasic,
    [switch]$InstallMainAll,
    [switch]$OutCSV,
    [switch]$OutGridView
)

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    # Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm  | iex"
    break
}

# Install the required Microsoft Graph PowerShell SDK modules
    Set-ExecutionPolicy Bypass -Scope Process -Force | Out-Null
    iex "& { $(irm bonguides.com/graph/modulesinstall) } -InstallMainBasic"

# Get user report with license assigments and account status

    Disconnect-MgGraph -ErrorAction:SilentlyContinue | Out-Null

    Write-Host "Conncting to Microsoft Graph PowerShell..." -ForegroundColor Yellow
    Connect-MgGraph -Scopes 'Directory.Read.All', 'User.Read.All' -ErrorAction Stop

    $users  = Get-MgUser -All

    # Get licenses assigned to user accounts
    $i = 1
    $Roles = @()
    $result = @()
    foreach ($user in $users) {
        #Get roles assigned to user
        Write-Host "($i/$($users.Count)) Processing: $($user.UserPrincipalName) - $($user.DisplayName)" -ForegroundColor Green
        $Roles = Get-MgBetaUserTransitiveMemberOf -UserId $user.Id | Select-Object -ExpandProperty AdditionalProperties
        $Roles = $Roles | Where-Object{$_.'@odata.type' -eq '#microsoft.graph.directoryRole'} 
        if($Roles.count -eq 0) { 
            $RolesAssigned = "No roles" 
        } else { 
            $RolesAssigned = @($Roles.displayName) -join ',' 
        } 

        # Creating the custom report
        $result += [PSCustomObject]@{
            'DisplayName' = $user.DisplayName
            'UserPrincipalName' = $user.UserPrincipalName
            'Enabled' = $user.accountEnabled
            'Roles' = $RolesAssigned
        }
        $i++
    }

# Output options to console, graphical grid view or export to CSV file.
if($OutCSV.IsPresent) {
    # $result | Sort-Object assignedlicenses -Descending 
    # $result | Out-GridView
    $filePath = "$env:userprofile\desktop\Result-$(Get-Date -Format yyyy-mm-dd-hh-mm-ss).csv"
    $result | Export-CSV $filePath -NoTypeInformation -Encoding UTF8
    Write-Host "`nThe report is saved to: $filePath `n" -ForegroundColor Cyan
    Invoke-Item "$env:userprofile\desktop"
} elseif ($OutGridView.IsPresent) {
    $result | Out-GridView
} else {
    $result | Format-Table
}

