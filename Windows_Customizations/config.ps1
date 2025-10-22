$edition = (Get-CimInstance Win32_OperatingSystem).Caption

Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://community.chocolatey.org/install.ps1 | iex
Set-Location 'C:\ProgramData\chocolatey\bin'
.\choco.exe feature enable -n allowGlobalConfirmation

# Turn off display sleep and computer sleep
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0
powercfg -h off

# 2.Turn off News and Interests
if ($edition -like "*Windows 10*") {
    Write-Host "Turning off News and Interests..." -ForegroundColor Yellow
    TASKKILL /IM explorer.exe /F | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2 -ErrorAction:SilentlyContinue  | Out-Null
    Start-Process explorer.exe
    Start-Sleep -Second 1
}

if ($edition -like "*Windows 10*") {
    # 3. Remove search highlight
    Write-Host "Turning off search highlight..." -ForegroundColor Yellow
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    $Name         = 'EnableDynamicContentInWSB'
    New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    New-ItemProperty $registryPath -Name $Name -PropertyType DWORD -Value 0 | Out-Null
}

if ($edition -like "*Windows 11*") {
    # Disable Search Highlights in Windows 11
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings"
    New-Item -Path $path -Force | Out-Null
    Set-ItemProperty -Path $path -Name "IsDynamicSearchBoxEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path $path -Name "IsDynamicSearchBoxVisible" -Type DWord -Value 0

    # Disable for the shell search box
    $path2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    Set-ItemProperty -Path $path2 -Name "BingSearchEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $path2 -Name "IsDynamicSearchBoxEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}


if ($edition -like "*Windows 10*") {
    # Hide date and time (clock) on the taskbar
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    New-Item -Path $path -Force | Out-Null
    Set-ItemProperty -Path $path -Name "HideClock" -Type DWord -Value 1

    # Restart Explorer to apply changes
    Stop-Process -Name explorer -Force

}


if ($edition -like "*Windows 11*") {
    # Hide time & date in Windows taskbar (current user)
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "Advanced" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSystrayDateTimeValueName" -Type DWord -Value 0
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


# 12.Configure Terminal (Windows 11)
if ($edition -like "*Windows 11*") {
    Write-Host "Configure Terminal..." -ForegroundColor Yellow
    Set-Location 'C:\ProgramData\chocolatey\bin'
    .\choco.exe install microsoft-windows-terminal -y
    Start-Sleep -Seconds 2
    Start-Process wt.exe
    Start-Sleep -Seconds 2
    Get-Process -ProcessName "WindowsTerminal" | Stop-Process
    $filePath = "C:\Users\$($env:username)\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Remove-Item -Path $filePath -Force
    $uri = 'https://github.com/bonguides25/PowerShell/raw/refs/heads/main/Windows_Customizations/settings.json'
    (New-Object Net.WebClient).DownloadFile($uri, $filePath)
}

if ($edition -like "*Windows 10*") {
    $filePath = "C:\Users\$($env:username)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
    Remove-Item -Path $filePath -Force
    $uri = 'https://github.com/bonguides25/PowerShell/raw/refs/heads/main/Windows_Customizations/Shortcuts/Windows%20PowerShell.lnk'
    (New-Object Net.WebClient).DownloadFile($uri, $filePath)
}

if ($edition -like "*Windows 10*") {
    $filePath = "C:\Users\$($env:username)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk"
    Remove-Item -Path $filePath -Force
    $uri = 'https://github.com/bonguides25/PowerShell/raw/refs/heads/main/Windows_Customizations/Shortcuts/Command%20Prompt.lnk'
    (New-Object Net.WebClient).DownloadFile($uri, $filePath)
}


# Purpose: Update App Installer (winget) immediately after install
irm bonguides.com/winget | iex





