<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Install Microsoft Windows Terminal on Windows.
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}

Set-Location "$env:temp"
Write-Host "`nInstalling Microsoft Windows Terminal..." -ForegroundColor Green

# Install C++ Runtime framework packages for Desktop Bridge
    $ProgressPreference='Silent'
    irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/msvclibs.ps1 | iex

# Install Microsoft.UI.Xaml
    $ProgressPreference='Silent'
    irm https://raw.githubusercontent.com/bonguides25/PowerShell/main/Utilities/microsoft.ui.xaml.ps1 | iex

# Downlaod and install Windows Package Manager to install Store apps
    Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
    Add-AppxPackage 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'

# Download and install Windows Terminal

    $url = 'https://github.com/microsoft/terminal/releases/latest'
    $request = [System.Net.WebRequest]::Create($url)
    $response = $request.GetResponse()
    $tagUrl = $response.ResponseUri.OriginalString
    $version = $tagUrl.split('/')[-1].Trim('v')
    $fileName = "Microsoft.WindowsTerminal_$($version)_8wekyb3d8bbwe.msixbundle"
    $downloadUrl = $tagUrl.Replace('tag', 'download') + '/' + $fileName
    (New-Object Net.WebClient).DownloadFile($downloadUrl, "$env:temp\WindowsTerminal.msixbundle")

    Add-AppxPackage WindowsTerminal.msixbundle

 Get-AppxPackage | Where-Object { $_.Name -like "*terminal*"} | select Name, Architecture, Version, PublisherId -ErrorAction SilentlyContinue

# Start Windows Terminal
Start-Process wt
