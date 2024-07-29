
# reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v TargetReleaseversion /t REG_DWORD /d 1

# New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableFirstLogonAnimation -Value 0 -Force

# Write-Host "Installing Oh-My-Posh..." -ForegroundColor Green
# Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
# Start-Sleep -Seconds 1
# $userpath = [System.Environment]::GetEnvironmentVariable("Path","User")
# $machinePath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
# $env:Path = $userpath + ";" + $machinePath
# oh-my-posh font install JetBrainsMono


# 6. Installing Chocolatey package manager
Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
$scriptBlock = {
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
$PSIinstance = [powershell]::Create().AddScript($scriptBlock)
$PSIinstance.Runspace = $runspace
$result = $PSIinstance.BeginInvoke()

do { 
Start-Sleep -Second 1 
} until ($result.IsCompleted -eq "true")

$PSIinstance.Dispose()

# 7. Installing the required application...
Write-Host 'Installing the required application...' -ForegroundColor Yellow
$scriptBlock = {
RefreshEnv
Set-Location 'C:\ProgramData\chocolatey\bin'
.\choco.exe feature enable -n allowGlobalConfirmation
.\choco.exe install GoogleChrome -y --ignore-checksums | Out-Null
