
Write-Host "Installing the WindowsAutopilotInfo script..."
PowerShell.exe -ExecutionPolicy Bypass
Install-Script -name Get-WindowsAutopilotInfo -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Write-Host "Adding the device to Windows Autopilot..."
Get-WindowsAutopilotInfo -Online
