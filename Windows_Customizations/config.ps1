

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

# Disable User Account Control (UAC)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
                 -Name "EnableLUA" -Value 0

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
}


if ($edition -like "*Windows 11*") {
    # Hide time & date in Windows taskbar (current user)
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "Advanced" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSystrayDateTimeValueName" -Type DWord -Value 0
}

# Enable "Auto arrange icons" on Desktop via registry (per-user)
# Optional: set $AlignToGrid = $true to also enable Align to grid
$AlignToGrid = $true

$deskKey = 'HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop'
New-Item -Path $deskKey -Force | Out-Null

# FFlags combinations (Shell Bags flag bitmask for Desktop)
# Auto=ON, Grid=ON  -> 0x40200225
# Auto=ON, Grid=OFF -> 0x40200221
# Auto=OFF, Grid=ON -> 0x40200224
# Auto=OFF, Grid=OFF-> 0x50300330

$fflags = if ($AlignToGrid) { 0x40200225 } else { 0x40200221 }

Set-ItemProperty -Path $deskKey -Name 'FFlags' -Type DWord -Value $fflags

# Cleanly bounce Explorer so the menu reflects the change
$explorer = Get-Process explorer -ErrorAction SilentlyContinue
if ($explorer) { $explorer | Stop-Process -Force }

# --- Define API methods ---
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);
    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
}
public struct RECT {
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}
"@

# --- Launch File Explorer ---
Start-Process explorer.exe "shell:MyComputerFolder"
Start-Sleep -Seconds 1

# --- Get the window handle ---
$hWnd = [WinAPI]::FindWindow("CabinetWClass", $null)
if ($hWnd -ne [IntPtr]::Zero) {
    [RECT]$rect = New-Object RECT
    [WinAPI]::GetWindowRect($hWnd, [ref]$rect) | Out-Null

    $width = $rect.Right - $rect.Left
    $height = $rect.Bottom - $rect.Top

    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $x = [Math]::Max(0, ($screen.Width - $width) / 2)
    $y = [Math]::Max(0, ($screen.Height - $height) / 2)

    [WinAPI]::MoveWindow($hWnd, $x, $y, $width, $height, $true) | Out-Null
}

# --- Launch Windows Settings ---
Start-Process "ms-settings:"
Start-Sleep -Seconds 1.5  # wait for Settings to start

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class WinAPI {
    [DllImport("user32.dll")] public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter,
        int X, int Y, int cx, int cy, uint uFlags);
    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
}
"@

# --- Try to find Settings window by class name ---
# Windows 10/11 Settings window class: "ApplicationFrameWindow"
$hwnd = [WinAPI]::FindWindow("ApplicationFrameWindow", "Settings")

if ($hwnd -eq [IntPtr]::Zero) {
    Start-Sleep -Seconds 1
    $hwnd = [WinAPI]::FindWindow("ApplicationFrameWindow", "Settings")
}

if ($hwnd -ne [IntPtr]::Zero) {
    # --- Get window size ---
    $rect = New-Object WinAPI+RECT
    [WinAPI]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
    $width  = $rect.Right - $rect.Left
    $height = $rect.Bottom - $rect.Top

    # --- Get primary screen working area (no taskbar overlap) ---
    Add-Type -AssemblyName System.Windows.Forms
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
    $x = [math]::Round(($screen.Width  - $width)  / 2 + $screen.Left)
    $y = [math]::Round(($screen.Height - $height) / 2 + $screen.Top)

    # --- Center the window ---
    [WinAPI]::SetWindowPos($hwnd, [IntPtr]::Zero, $x, $y, $width, $height, 0x0040) | Out-Null

    Write-Host "✅ Settings window centered on screen."
} else {
    Write-Host "⚠️ Could not find Settings window. Try increasing the sleep delay."
}

# --- Disable Recent Searches in File Explorer (and Search history) ---

$ErrorActionPreference = 'SilentlyContinue'

# 1) Policy: Turn off display of recent search entries in File Explorer search box
#    User policy (works without admin)
New-Item -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name 'DisableSearchBoxSuggestions' -Type DWord -Value 1

#    Machine policy (requires admin; optional but recommended)
try {
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Force | Out-Null
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableSearchBoxSuggestions' -Type DWord -Value 1
} catch {}

# 2) Turn off "Search history on this device" (per-user)
New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings' -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'IsDeviceSearchHistoryEnabled' -Type DWord -Value 0

# 3) (Optional hardening) Disable web/Bing suggestions in search
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Force | Out-Null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch' -Type DWord -Value 1
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWeb' -Type DWord -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWebOverMeteredConnections' -Type DWord -Value 0

# 4) Clear existing search MRU (Explorer dropdown)
if (Test-Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery') {
    Remove-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery' -Recurse -Force
}

# 5) Restart Explorer + SearchHost so changes take effect immediately
Get-Process SearchHost -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force

# --- Run as Administrator ---

# 1) OFF for the current user (backs Settings > Personalization > Start)
$adv = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
if (-not (Test-Path $adv)) { New-Item -Path $adv -Force | Out-Null }
# 0 = hide Start recommendations
Set-ItemProperty -Path $adv -Name 'Start_IrisRecommendations' -Type DWord -Value 0
# Optional: also stop "Most used" & "Recent" from feeding Recommended
Set-ItemProperty -Path $adv -Name 'Start_TrackProgs' -Type DWord -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path $adv -Name 'Start_TrackDocs'  -Type DWord -Value 0 -ErrorAction SilentlyContinue

# 2) OFF via policy (device-wide) — Microsoft’s documented policy
#    Works on 24H2+ and most SKUs; requires sign-out to fully apply.
$pmDeviceStart = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start'
New-Item -Path $pmDeviceStart -Force | Out-Null
Set-ItemProperty -Path $pmDeviceStart -Name 'HideRecommendedSection' -Type DWord -Value 1

# 3) Fallbacks seen to help on some SKUs/builds
#    a) Mirror to user policy path (some builds read user scope)
$pmUserStart = 'HKCU:\SOFTWARE\Microsoft\PolicyManager\current\user\Start'
New-Item -Path $pmUserStart -Force | Out-Null
Set-ItemProperty -Path $pmUserStart -Name 'HideRecommendedSection' -Type DWord -Value 1

#    b) Old Explorer policy path (some environments still honor it)
$explPolicy = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
New-Item -Path $explPolicy -Force | Out-Null
Set-ItemProperty -Path $explPolicy -Name 'HideRecommendedSection' -Type DWord -Value 1

#    c) (Optional) Nudge “education environment” bit
#       Some admins report this helps the policy stick on Pro/Home.
$edu = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Education'
New-Item -Path $edu -Force | Out-Null
Set-ItemProperty -Path $edu -Name 'IsEducationEnvironment' -Type DWord -Value 1

# 4) Also turn off personalized website recs (policy)
$pmStart = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start'
Set-ItemProperty -Path $pmStart -Name 'HideRecommendedPersonalizedSites' -Type DWord -Value 1 -ErrorAction SilentlyContinue

# 5) Kill & restart Explorer so the UI refreshes (sign-out gives the most reliable result)
Stop-Process -Name explorer -Force
Start-Process explorer.exe


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

# Requires admin
$guid = 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF'

$enrollKey = "HKLM:\SOFTWARE\Microsoft\Enrollments\$guid"
$omadmKey  = "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$guid"

# Create keys
New-Item -Path $enrollKey -Force | Out-Null
New-Item -Path $omadmKey  -Force | Out-Null

# Key 1: Enrollment status
New-ItemProperty -Path $enrollKey -Name 'EnrollmentState' -PropertyType DWord -Value 0x1 -Force | Out-Null
New-ItemProperty -Path $enrollKey -Name 'EnrollmentType'  -PropertyType DWord -Value 0x0 -Force | Out-Null
New-ItemProperty -Path $enrollKey -Name 'IsFederated'     -PropertyType DWord -Value 0x0 -Force | Out-Null

# Key 2: OMA-DM account info
New-ItemProperty -Path $omadmKey -Name 'Flags'                   -PropertyType DWord -Value 0x00D6FB7F -Force | Out-Null
New-ItemProperty -Path $omadmKey -Name 'AcctUId'                 -PropertyType String -Value '0x000000000000000000000000000000000000000000000000000000000000000000000000' -Force | Out-Null
New-ItemProperty -Path $omadmKey -Name 'RoamingCount'            -PropertyType DWord -Value 0x0 -Force | Out-Null
New-ItemProperty -Path $omadmKey -Name 'SslClientCertReference'  -PropertyType String -Value 'MY;User;0000000000000000000000000000000000000000' -Force | Out-Null
New-ItemProperty -Path $omadmKey -Name 'ProtoVer'                -PropertyType String -Value '1.2' -Force | Out-Null


# --- Set Google as default search engine in Microsoft Edge ---

$EdgePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"

# Create policy path if not exist
if (-not (Test-Path $EdgePolicyPath)) {
    New-Item -Path $EdgePolicyPath -Force | Out-Null
}

# Configure search provider settings
Set-ItemProperty -Path $EdgePolicyPath -Name "DefaultSearchProviderEnabled" -Type DWord -Value 1
Set-ItemProperty -Path $EdgePolicyPath -Name "DefaultSearchProviderName" -Type String -Value "Google"
Set-ItemProperty -Path $EdgePolicyPath -Name "DefaultSearchProviderSearchURL" -Type String -Value "https://www.google.com/search?q={searchTerms}"
Set-ItemProperty -Path $EdgePolicyPath -Name "DefaultSearchProviderSuggestURL" -Type String -Value "https://www.google.com/complete/search?output=chrome&q={searchTerms}"

# Optional: lock the settings so users can’t change them
# Set-ItemProperty -Path $EdgePolicyPath -Name "DefaultSearchProviderLocked" -Type DWord -Value 1

# Restart Edge if running
Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "Google has been set as the default search engine in Microsoft Edge."

# Run this script as Administrator

$EdgePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"

# Ensure Edge policy path exists
if (-not (Test-Path $EdgePolicyPath)) {
    New-Item -Path $EdgePolicyPath -Force | Out-Null
}

# --- Disable all new tab content and promos ---
New-ItemProperty -Path $EdgePolicyPath -Name "NewTabPageContentEnabled" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "NewTabPageQuickLinksEnabled" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "NewTabPagePromotionsEnabled" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "NewTabPageAllowedBackgroundTypes" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "NewTabPageCompanyLogoVisible" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "NewTabPageHideDefaultTopSites" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "ShowMicrosoftRewards" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "ShowRecommendationsEnabled" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "NewTabPageLocation" -Value "about:blank" -PropertyType String -Force | Out-Null

# --- Set Default Display Language to English (United States) ---
# en-US = English (United States)
New-ItemProperty -Path $EdgePolicyPath -Name "ApplicationLocaleValue" -Value "en-US" -PropertyType String -Force | Out-Null

Write-Host "✅ Microsoft Edge configured:"
Write-Host " - Default language: English (United States)"
Write-Host " - All new tab page widgets, promos, and feeds disabled."
Write-Host ""
Write-Host "ℹ️ Restart Edge for changes to take effect."


# 12.Configure Terminal (Windows 11)
if ($edition -like "*Windows 11*") {
    Write-Host "Configure Terminal..." -ForegroundColor Yellow
    Set-Location 'C:\ProgramData\chocolatey\bin'
    .\choco.exe install microsoft-windows-terminal -y
    Start-Sleep -Seconds 2
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

# Restart Explorer to apply changes
Stop-Process -Name explorer -Force


# VMware Tools auto install (VMware only)
# Run as Administrator

$downloadUrl = 'https://vdconline-my.sharepoint.com/personal/navara_vdconline_onmicrosoft_com/_layouts/15/download.aspx?share=ERzUEYjFZ7hOq0JeegVTByMBlUjydBxB4Ug1EAIjHyI6YQ'
$downloadPath = 'C:\Temp'
$installer = 'VMware-Tools.exe'
$installerPath = "$downloadPath\$installer"

$manufacturer = (Get-CimInstance Win32_ComputerSystem).Manufacturer
$model = (Get-CimInstance Win32_ComputerSystem).Model

if ($manufacturer -match "VMware" -or $model -match "VMware") {
    New-Item -ItemType Directory -Path $downloadPath -Force | Out-Null
    (New-Object Net.WebClient).DownloadFile($downloadUrl, $installerPath)
    Start-Process -FilePath $installerPath -ArgumentList '/S /v"/qn REBOOT=R"' -Wait
    Remove-Item $installerPath -Force
}
