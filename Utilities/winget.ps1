<#
==================================================================================================================  
Version:        1.0
Date :          26/2/2023
Website:        https://bonguides.com
Script by:      https://github.com/bonguides25
=================================================================================================================
#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}

# Create temporary directory
$null = New-Item -Path $env:temp\temp -ItemType Directory -Force
Set-Location $env:temp\temp
$path = "$env:temp\temp"

#Install C++ Runtime framework packages for Desktop Bridge
$ProgressPreference='Silent'
$url = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
(New-Object Net.WebClient).DownloadFile($url, "$env:temp\temp\Microsoft.VCLibs.x64.14.00.Desktop.appx")
Add-AppxPackage -Path Microsoft.VCLibs.x64.14.00.Desktop.appx -ErrorAction SilentlyContinue | Out-Null

#Download and extract Nuget
$url = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
(New-Object Net.WebClient).DownloadFile($url, "$env:temp\temp\nuget.exe")
.\nuget.exe install Microsoft.UI.Xaml -Version 2.7 | Out-Null
Add-AppxPackage -Path "$path\Microsoft.UI.Xaml.2.7.0\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx" -ErrorAction:SilentlyContinue | Out-Null

#Download winget and license file
Write-Host '`nInstalling Windows Package Manager...'
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

(New-Object Net.WebClient).DownloadFile($url, "$env:temp\temp\$fileName")
(New-Object Net.WebClient).DownloadFile($licenseUrl, "$env:temp\temp\$licenseName")

Add-AppxProvisionedPackage -Online -PackagePath $fileName -LicensePath $licenseName | Out-Null

# Checking installed apps
Write-Host '`nInstalled packages:'
$packages = @("DesktopAppInstaller")
$report = ForEach ($package in $packages){Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like "*$package*"} | select DisplayName,Version}
$report | format-table

# Cleanup
Remove-Item $path\* -Recurse -Force
