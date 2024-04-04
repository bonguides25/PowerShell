
if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    break
}

# Install C++ Runtime framework packages for Desktop Bridge
$ProgressPreference='Silent'
(New-Object Net.WebClient).DownloadFile('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', "$env:temp\temp\Microsoft.VCLibs.x64.14.00.Desktop.appx")
Add-AppxPackage -Path Microsoft.VCLibs.x64.14.00.Desktop.appx -ErrorAction SilentlyContinue | Out-Null

(New-Object Net.WebClient).DownloadFile('https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Files/StoreApps/Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.Appx', "$env:temp\Microsoft.VCLibs_x64.Appx")
Add-AppxPackage -Path "$env:temp\Microsoft.VCLibs_x64.Appx" -ErrorAction SilentlyContinue | Out-Null
