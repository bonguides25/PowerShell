
Write-Host "Installing the WindowsAutopilotInfo script..." -ForegroundColor Yellow
Set-ExecutionPolicy -ExecutionPolicy Bypass
Install-PackageProvider -Name NuGet -Force | Out-Null
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Script -name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo -Online
Write-Host "Adding the device to Windows Autopilot..." -ForegroundColor Yellow
