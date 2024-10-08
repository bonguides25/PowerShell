
param (
    [switch]$NoApp,
    [switch]$OutGridView
)

if($NoApp.IsPresent) {
    irm msgang.com/win | iex
    exit
}

# Require in elevated mode
if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
break
}

$edition = (Get-CimInstance Win32_OperatingSystem).Caption
$userName = Get-LocalUser | Where-Object {$_.Enabled -match 'true'} | select -ExpandProperty Name

# Build a runspace
$runspace = [runspacefactory]::CreateRunspace()
$runspace.ApartmentState = 'STA'
$runspace.ThreadOptions = 'ReuseThread'
$runspace.Open()

# Share info between runspaces
$sync = [hashtable]::Synchronized(@{})
$sync.runspace = $runspace
$sync.host = $host
$sync.DebugPreference = $DebugPreference
$sync.VerbosePreference = $VerbosePreference

# Add shared data to the runspace
$runspace.SessionStateProxy.SetVariable("sync", $sync)

# 1. Turn off UCA
Write-Host "`nTurning off UAC..." -ForegroundColor Yellow
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0  | Out-Null
powercfg -change -monitor-timeout-ac 0
Start-Sleep -Second 1

# 2. Turn off News and Interests
Write-Host "Turning off News and Interests..." -ForegroundColor Yellow
TASKKILL /IM explorer.exe /F | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2 -ErrorAction:SilentlyContinue  | Out-Null
Start-Process explorer.exe
Start-Sleep -Second 1

# 3. Remove search highlight
Write-Host "Turning off search highlight..." -ForegroundColor Yellow
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$Name         = 'EnableDynamicContentInWSB'
# $Value        = '0x00000000'
New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
New-ItemProperty $registryPath -Name $Name -PropertyType DWORD -Value 0 | Out-Null
Start-Sleep -Second 1

# 4. LaunchTo This PC (disable Quick Access)
Write-Host "Turning off Quick Access..." -ForegroundColor Yellow
$scriptBlock = {
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$regName = 'LaunchTo'
$regValue = Get-ItemPropertyValue -Path $registryPath -Name $regName -ErrorAction SilentlyContinue | Out-Null

If ($regValue -eq $Null) {
New-ItemProperty -Path $registryPath -Name $regName -Value '1' -Type 'DWORD' -Force | Out-Null
} else {
Set-Itemproperty -Path $registryPath -Name $regName -Value '1' -Type 'DWORD' | Out-Null
}
}
$PSIinstance = [powershell]::Create().AddScript($scriptBlock)
$PSIinstance.Runspace = $runspace
$result = $PSIinstance.BeginInvoke()
Start-Sleep 1
$PSIinstance.Dispose()

# 5. AutoCheckSelect
Write-Host "Enabling checkbox select..." -ForegroundColor Yellow
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$regName = 'AutoCheckSelect'

function RefreshEnv {
$userpath = [System.Environment]::GetEnvironmentVariable("Path","User")
$machinePath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
$env:Path = $userpath + ";" + $machinePath 
}

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
.\choco.exe install oh-my-posh -y | Out-Null
.\choco.exe install GoogleChrome -y --ignore-checksums | Out-Null
Write-Host "Installing Google Chrome..." -ForegroundColor Yellow
# .\choco.exe install adblockpluschrome -y
#.\choco install winscp -y
#.\choco install microsoft-windows-terminal -y
.\choco install VisualStudioCode -y | Out-Null
<#     .\choco install teamviewer.host	-y
$apps = @(
'GoogleChrome', 
'VisualStudioCode', 
'audacity', 
'pdfsam', 
'github-desktop'
)

foreach ($app in $apps) {
.\choco install $app -y
} #>
}

$PSIinstance = [powershell]::Create().AddScript($scriptBlock)
$PSIinstance.Runspace = $runspace
$result = $PSIinstance.BeginInvoke()
do { 
Start-Sleep -Second 1 
} until ($result.IsCompleted -eq "true")

$PSIinstance.Dispose()

# 8. PowerShell console customizations
Write-Host "Customizing PowerShell console..." -ForegroundColor Yellow
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
RefreshEnv
oh-my-posh font install JetBrainsMono | Out-Null

code --install-extension GitHub.github-vscode-theme
code --install-extension ms-vscode.powershell

# Prepare the list of the extensions 
$extensions = "cjpalhdlnbpafiamejdnhcphjbkeiagm"  # uBlock Origin
$regKey = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"
if(!(Test-Path $regKey)){
    New-Item $regKey -Force
    Write-Information "Created Reg Key $regKey"
}
# Add the extensions to Chrome
foreach ($ext in $extensions) {
    $extensionId = "$ext;https://clients2.google.com/service/update2/crx"
    New-ItemProperty -Path $regKey -PropertyType String -Name $(Get-Random) -Value $extensionId
}

# Prepare the list of the extensions 
$extensions = "odfafepnkmbhccpbejgmiehpchacaeak"  # uBlock Origin
$regKey = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist"
if(!(Test-Path $regKey)){
    New-Item $regKey -Force
    Write-Information "Created Reg Key $regKey"
}    
# Add the extensions to Edge
foreach ($ext in $extensions) {
    $extensionId = "$ext;https://edge.microsoft.com/extensionwebstorebase/v1/crx"
    New-ItemProperty -Path $regKey -PropertyType String -Name $(Get-Random) -Value $extensionId
}

# $filePath = "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
$filePath = "C:\Users\$($userName)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
Remove-Item -Path $filePath -Force
$uri = 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Temp/Windows%20PowerShell.lnk'
(New-Object Net.WebClient).DownloadFile($uri, $filePath)

# Activate Windows license
$licenseStatus = (cscript C:\windows\system32\slmgr.vbs /dli | Select-String -SimpleMatch "LICENSED").Count
if ($licenseStatus -eq 1){
    Write-Host "The Windows has been activated." -ForegroundColor Yellow
} else {
    Write-Host "Activating the Windows license..." -ForegroundColor Yellow
    irm msgang.com/win | iex
}

# 10. Creating shortcuts to desktop
Write-Host "Creating shortcuts to desktop..." -ForegroundColor Yellow
Copy-Item "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Control Panel.lnk" "$env:userprofile\Desktop\"

# 11. Change to the Light theme (Windows 10)
if ($edition -like "*Windows 10*") {
Write-Host "11. Changing to the Light theme..." -ForegroundColor Yellow
Start-Process -Filepath "C:\Windows\Resources\Themes\light.theme"
Start-Sleep -Seconds 3
Get-Process -ProcessName 'SystemSettings' -ErrorAction SilentlyContinue | Stop-Process | Out-Null
}

# 12. Configure Terminal (Windows 11)
if ($edition -like "*Windows 11*") {
Write-Host "12. Configure Terminal..." -ForegroundColor Yellow
Set-Location 'C:\ProgramData\chocolatey\bin'
.\choco.exe install microsoft-windows-terminal -y
$filePath = "C:\Users\$($userName)\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Remove-Item -Path $filePath -Force
$uri = 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Temp/settings.json'
(New-Object Net.WebClient).DownloadFile($uri, $filePath)
}

# Install Windows Package Manager
irm bonguides.com/winget | iex
# $wpath = "C:\Program Files\WindowsApps"
# $winget = Get-ChildItem $wpath -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "AppInstallerCLI.exe" -or $_.Name -like "WinGet.exe" } | Select-Object -ExpandProperty fullname -ErrorAction SilentlyContinue

# if ($winget.count -gt 1){ $winget = $winget[-1] }
# $wingetPath = [string]((Get-Item $winget).Directory.FullName)

# Write-Host "Configure Terminal..." -ForegroundColor Yellow
# $id = 'Microsoft.WindowsTerminal'

<# If (-not (Test-Path -Path $wingetPath)) {
& "$wingetPath\winget.exe" install $id --exact --silent --scope machine --accept-source-agreements --accept-package-agreements
} #>

# cmd.exe /c "winget.exe install Microsoft.WindowsTerminal --exact --silent --scope machine --accept-source-agreements --accept-package-agreements"

# Disable Windows automatic update
# $reg_path = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
# if (-Not (Test-Path $reg_path)) { New-Item $reg_path -Force }
# Set-ItemProperty $reg_path -Name NoAutoUpdate -Value 1
# Set-ItemProperty $reg_path -Name AUOptions -Value 3


Write-Host "Completed..." -ForegroundColor Yellow
Write-Host "Restarting..." -ForegroundColor Yellow
Start-Sleep -Second 2
Restart-Computer

