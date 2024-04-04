<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
# Install Windows Package Manager (winget).
# Works on all Windows editons included Windows LTSC and Windows Sandbox
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}


# Install Windows Package Manager on Windows Sandbox only
if (Test-Path 'C:\Users\WDAGUtilityAccount') {
    Write-Host "`nYou're using Windows Sandbox." -ForegroundColor Yellow
    irm bonguides.com/wsb/winget | iex
} else {

    Write-Host "Installing Windows Package Manager (AppInstaller)..." -ForegroundColor Yellow
    Set-Location "$env:temp"

    # Install C++ Runtime framework packages for Desktop Bridge
        $ProgressPreference='Silent'
        irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/msvclibs.ps1 | iex
    
    # Install Microsoft.UI.Xaml through Nuget.
        $ProgressPreference='Silent'
        irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/microsoft.ui.xaml.ps1 | iex
    
    # Download winget and license file the install it
        function getLink($match) {
            $uri = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
            $get = Invoke-RestMethod -uri $uri -Method Get -ErrorAction stop
            $data = $get[0].assets | Where-Object name -Match $match
            return $data.browser_download_url
        }
    
        $url = getLink("msixbundle")
        $licenseUrl = getLink("License1.xml")
    
        # Finally, install winget
        $fileName = 'winget.msixbundle'
        $licenseName = 'license1.xml'
    
        (New-Object Net.WebClient).DownloadFile($url, "$env:temp\$fileName")
        (New-Object Net.WebClient).DownloadFile($licenseUrl, "$env:temp\$licenseName")
    
        Add-AppxProvisionedPackage -Online -PackagePath $fileName -LicensePath $licenseName | Out-Null
        Write-Host "The Windows Package Manager has been installed." -ForegroundColor Yellow
}


