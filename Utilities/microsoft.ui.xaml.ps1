if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}
        
$ProgressPreference='Silent'

Invoke-WebRequest -Uri 'https://github.com/QuestYouCraft/Microsoft-Store-UnInstaller/raw/master/Packages/Microsoft.UI.Xaml.2.4_2.42007.9001.0_x64__8wekyb3d8bbwe.appx' -OutFile "$env:temp\Microsoft.UI.Xaml.2.4_2.42007.9001.0_x64__8wekyb3d8bbwe.appx"
# Invoke-WebRequest -Uri 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.5/Microsoft.UI.Xaml.2.8.x64.appx' -OutFile 'Microsoft.UI.Xaml.2.8.x64.appx'
Invoke-WebRequest -Uri 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx' -OutFile "$env:temp\Microsoft.UI.Xaml.2.8.x64.appx"

Add-AppxPackage -Path "$env:temp\Microsoft.UI.Xaml.2.4_2.42007.9001.0_x64__8wekyb3d8bbwe.appx" -ErrorAction SilentlyContinue | Out-Null
# Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
Add-AppxPackage -Path "$env:temp\Microsoft.UI.Xaml.2.8.x64.appx" -ErrorAction SilentlyContinue | Out-Null
