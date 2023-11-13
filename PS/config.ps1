if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    # Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm msgang.com/dl | iex"
    break
}

Write-Host "1. Turning off UAC..."
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0  | Out-Null
powercfg -change -monitor-timeout-ac 0
Start-Sleep -Second 1

# Turn off News and Interests
Write-Host "2. Turning off News and Interests..."
TASKKILL /IM explorer.exe /F | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2  | Out-Null
Start-Process explorer.exe
Start-Sleep -Second 1

# Remove search highlight
Write-Host "3. Turning off search highlight..."
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$Name         = 'EnableDynamicContentInWSB'
# $Value        = '0x00000000'
New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
New-ItemProperty $registryPath -Name $Name -PropertyType DWORD -Value 0 | Out-Null
Start-Sleep -Second 1

# LaunchTo This PC (disable Quick Access)
Write-Host "4. Turning off Quick Access..."
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$regName = 'LaunchTo'
$regValue = Get-ItemPropertyValue -Path $registryPath -Name $regName -ErrorAction:SilentlyContinue

If ($regValue -eq $Null) {
  New-ItemProperty -Path $registryPath -Name $regName -Value '1' -Type 'DWORD' -Force | Out-Null
} else {
    Set-Itemproperty -Path $registryPath -Name $regName -Value '1' -Type 'DWORD'
}
Start-Sleep -Second 1

# AutoCheckSelect
Write-Host "5. Enabling checkbox select..."
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$regName = 'AutoCheckSelect'
$regValue = Get-ItemPropertyValue -Path $registryPath -Name $regName -ErrorAction:SilentlyContinue

If ($regValue -eq $Null) {
  New-ItemProperty -Path $registryPath -Name $regName -Value '1' -Type 'DWORD' -Force | Out-Null
} else {
    Set-Itemproperty -Path $registryPath -Name $regName -Value '1' -Type 'DWORD'
}
Start-Sleep -Second 1

# Mapping a network drive
Write-Host "6. Mapping a network drive..."
$registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$regName = 'EnableLinkedConnections'
$regValue = Get-ItemPropertyValue -Path $registryPath -Name $regName -ErrorAction:SilentlyContinue | Out-Null

If ($regValue -eq $Null) {
  New-ItemProperty -Path $registryPath -Name $regName -Value '1' -Type 'DWORD' -Force | Out-Null
} else {
    Set-Itemproperty -Path $registryPath -Name $regName -Value '1' -Type 'DWORD'
}

Set-Location "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
New-Item .\mapper.bat -ItemType File -Force | Out-Null
Add-Content .\mapper.bat -Value "net use H: /DELETE"
Add-Content .\mapper.bat -Value "net use H: `"`\`\10.10.2.101`\Shared`" /user:`"stadmin`" `"123@123a`" /PERSISTENT:YES"
Start-Sleep -Second 1

# Chocolatey
Write-Host "7. Installing Chocolatey and apps.."
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation
choco install oh-my-posh
choco install GoogleChrome
choco install VisualStudioCode

$userpath = [System.Environment]::GetEnvironmentVariable("Path","User")
$machinePath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
$env:Path = $userpath + ";" + $machinePath

# PowerShell console customizations
Write-Host "8. Customizing PowerShell console..."
oh-my-posh font install JetBrainsMono

$filePath = "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
Remove-Item -Path $filePath -Force
$uri = 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Temp/Windows%20PowerShell.lnk'
(New-Object Net.WebClient).DownloadFile($uri, $filePath)


Write-Host "Restarting..."
shutdown -r -t 5
