
Write-Host "Installing the WindowsAutopilotInfo script..."
Set-ExecutionPolicy -ExecutionPolicy Bypass
Install-PackageProvider -Name NuGet -Force | Out-Null
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Script -name Get-WindowsAutopilotInfo -Force
Write-Host "Adding the device to Windows Autopilot..."
Get-WindowsAutopilotInfo -Online
