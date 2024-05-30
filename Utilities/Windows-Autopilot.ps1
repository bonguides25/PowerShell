
Write-Host "Installing the WindowsAutopilotInfo script..."
Set-ExecutionPolicy -ExecutionPolicy Bypass
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-PackageProvider -Name NuGet -Force
Install-Script -name Get-WindowsAutopilotInfo -Force
Write-Host "Adding the device to Windows Autopilot..."
Get-WindowsAutopilotInfo -Online
