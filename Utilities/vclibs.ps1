<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Single script allows you to download and install Microsoft VCLibs
============================================================================================#>

Write-Host
Write-Host 'Installing Microsoft VCLibs...' -ForegroundColor Green

(New-Object Net.WebClient).DownloadFile('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', "$env:temp\Microsoft.VCLibs.x64.14.00.Desktop.appx")
(New-Object Net.WebClient).DownloadFile('https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Files/StoreApps/Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.Appx', "$env:temp\Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.Appx")

Add-AppxPackage -Path "$env:temp\Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.Appx"
Add-AppxPackage -Path "$env:temp\Microsoft.VCLibs.x64.14.00.Desktop.appx"

Write-Host
Write-Host 'Installed Package:' -ForegroundColor Green
Get-AppxPackage *vclibs* | select Name, Version

# Cleanup
Remove-Item "$env:temp\Microsoft.VCLibs.x64.14.00.Desktop.appx" -Force -ErrorAction:SilentlyContinue
Remove-Item "$env:temp\Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.Appx" -Force -ErrorAction:SilentlyContinue
