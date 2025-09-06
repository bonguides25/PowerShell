
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

# Activate Windows license
Write-Host "`nActivating Windows license..." -ForegroundColor Yellow
irm win.msgang.com | iex

# Install oh-mu-posh
Write-Host "`nInstalling oh-my-posh..." -ForegroundColor Yellow
irm bonguides.com/omp | iex

$edition = (Get-CimInstance Win32_OperatingSystem).Caption

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

# 1.Turn off UCA
Write-Host "`nTurning off UAC..." -ForegroundColor Yellow
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0  | Out-Null
powercfg -change -monitor-timeout-ac 0
Start-Sleep -Second 1

# 2.Turn off News and Interests
Write-Host "Turning off News and Interests..." -ForegroundColor Yellow
TASKKILL /IM explorer.exe /F | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2 -ErrorAction:SilentlyContinue  | Out-Null
Start-Process explorer.exe
Start-Sleep -Second 1

# 3. Remove search highlight
Write-Host "Turning off search highlight..." -ForegroundColor Yellow
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$Name         = 'EnableDynamicContentInWSB'
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
$PSIinstance.BeginInvoke()
Start-Sleep 2
$PSIinstance.Dispose()

New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSystrayDateTimeValueName' -Value '0' -Type 'DWORD' -Force

# New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop' -Name 'FFlags' -Value '1210057253' -Type 'DWORD' -Force

if(($env:username) -match 'admin'){
    Invoke-WebRequest -Uri 'https://github.com/bonguides25/PowerShell/raw/main/Config/admin.reg' -OutFile $env:TEMP\admin.reg
    reg import "$env:TEMP\admin.reg"
}

# 5.AutoCheckSelect
Write-Host "Enabling checkbox select..." -ForegroundColor Yellow
$registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$regName = 'AutoCheckSelect'

function RefreshEnv {
$userpath = [System.Environment]::GetEnvironmentVariable("Path","User")
$machinePath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
$env:Path = $userpath + ";" + $machinePath 
}


# Define the source link and destination path
$source = 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user'
$destination = "$env:TEMP\vscode.exe"
$webClient = [System.Net.WebClient]::new()
$webClient.DownloadFile($source, $destination)
Start-Process -FilePath "$env:TEMP\vscode.exe" -ArgumentList "/silent"


$filePath = "C:\Users\$($env:username)\Appdata\Roaming\Code\User\settings.json"

Remove-Item -Path $filePath -Force -ErrorAction SilentlyContinue
$uri = 'https://github.com/bonguides25/PowerShell/raw/main/Config/Code/settings.json'
(New-Object Net.WebClient).DownloadFile($uri, $filePath)



# 6.Installing Chocolatey package manager
Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Invoke-WebRequest -Uri 'https://community.chocolatey.org/install.ps1' -OutFile $env:temp\install.ps1
Start-Sleep -Second 3
# Start-Process -FilePath $env:TEMP\install.ps1 -Wait 

# 7.Installing the required application...
Write-Host 'Installing the required application...' -ForegroundColor Yellow
RefreshEnv
Set-Location 'C:\ProgramData\chocolatey\bin'
.\choco.exe feature enable -n allowGlobalConfirmation
Write-Host "Installing Google Chrome..." -ForegroundColor Yellow
msiexec.exe /i https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi /qn
# .\choco install VisualStudioCode -y | Out-Null

# 8.PowerShell console customizations
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

$filePath = "C:\Users\$($env:username)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"

Remove-Item -Path $filePath -Force
$uri = 'https://github.com/bonguides25/PowerShell/raw/main/Config/Windows%20PowerShell.lnk'
(New-Object Net.WebClient).DownloadFile($uri, $filePath)


# 10.Creating shortcuts to desktop
Write-Host "Creating shortcuts to desktop..." -ForegroundColor Yellow
Copy-Item "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Control Panel.lnk" "$env:userprofile\Desktop\"

# 11.Change to the Light theme (Windows 10)
if ($edition -like "*Windows 10*") {
    Write-Host "Changing to the Light theme..." -ForegroundColor Yellow
    Start-Process -Filepath "C:\Windows\Resources\Themes\light.theme"
    Start-Sleep -Seconds 3
    Get-Process -ProcessName 'SystemSettings' -ErrorAction SilentlyContinue | Stop-Process | Out-Null
}

# 12.Configure Terminal (Windows 11)
if ($edition -like "*Windows 11*") {
    Write-Host "Configure Terminal..." -ForegroundColor Yellow
    Set-Location 'C:\ProgramData\chocolatey\bin'
    .\choco.exe install microsoft-windows-terminal -y
    Start-Sleep -Seconds 3
    Start-Process wt.exe
    Start-Sleep -Seconds 3
    Get-Process -ProcessName "WindowsTerminal" | Stop-Process
    $filePath = "C:\Users\$($env:username)\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Remove-Item -Path $filePath -Force
    $uri = 'https://github.com/bonguides25/PowerShell/raw/main/Config/settings.json'
    (New-Object Net.WebClient).DownloadFile($uri, $filePath)
}

# Install Windows Package Manager
Write-Host "Configure Windows Package Manager..." -ForegroundColor Yellow
irm bonguides.com/winget | iex

Write-Host "Completed..." -ForegroundColor Yellow
Write-Host "Restarting..." -ForegroundColor Yellow
Start-Sleep -Second 1
Restart-Computer -Force
