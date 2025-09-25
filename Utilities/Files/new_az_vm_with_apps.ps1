# Installing Chocolatey package manager
Set-ExecutionPolicy Bypass -Scope Process -Force
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 2
# irm https://community.chocolatey.org/install.ps1 | iex

# RefreshEnv
# Set-Location 'C:\ProgramData\chocolatey\bin'
# .\choco.exe feature enable -n allowGlobalConfirmation
# .\choco.exe install oh-my-posh -y
# .\choco.exe install GoogleChrome -y --ignore-check
# .\choco.exe install firefox -y
Start-Process -FilePath msiexec.exe -ArgumentList "/i https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -Wait
# msiexec.exe /i https://download-installer.cdn.mozilla.net/pub/firefox/releases/142.0.1/win64/en-US/Firefox%20Setup%20142.0.1.msi


# GitHub API URL for the app manifest.
$apiUrl = "https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/b/Brave/Brave"

# Fetch version folders then filter only version folders.
$versions = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'PowerShell' }
$versionFolders = $versions | Where-Object { $_.type -eq "dir" }

# Extract and sort version numbers to get the latest version.
$sortedVersions = $versionFolders | ForEach-Object { $_.name } | Sort-Object {[version]$_} -Descending -ErrorAction SilentlyContinue
$latestVersion = $sortedVersions[0]

# Get contents of the latest version folder to find the .installer.yaml file.
$latestApiUrl = "$apiUrl/$latestVersion"
$latestFiles = Invoke-RestMethod -Uri $latestApiUrl -Headers @{ 'User-Agent' = 'PowerShell' }
$installerFile = $latestFiles | Where-Object { $_.name -like "*.installer.yaml" }

# Download and parse YAML content to get the Url of the latest installer file.
$yamlUrl = $installerFile.download_url
$yamlContent = Invoke-RestMethod -Uri $yamlUrl -Headers @{ 'User-Agent' = 'PowerShell' }
$yamlString = $yamlContent -join "`n"
$installerUrls = [regex]::Matches($yamlString, "InstallerUrl:\s+(http[^\s]+)") | ForEach-Object { $_.Groups[1].Value }
$installerUrl = $installerUrls[0]

# Download the latest installer then starting install or update the app if:
# - The installed version is older than the latest version.
# - The app is not installed ( $installedVersion = $null ).

$webClient = [System.Net.WebClient]::new()
$webClient.DownloadFile($installerUrl, "$env:TEMP\brave-latest.exe")

# Start the install or update process.
Start-Process -FilePath "$env:TEMP\brave-latest.exe" -Wait


# .\choco.exe install vlc -y
# .\choco.exe install winscp -y
# .\choco.exe install mremoteng -y
# .\choco.exe install zoom -y
# .\choco.exe install discord -y
# .\choco.exe install skype -y
# .\choco.exe install thunderbird -y
# .\choco.exe install fscapture -y
# .\choco.exe install teamviewer -y
# .\choco.exe install VisualStudioCode -y
# RefreshEnv
$filePath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\thumbnails.bat"
$uri = 'https://raw.githubusercontent.com/bonguides25/PowerShell/refs/heads/main/Utilities/Files/thumbnails.bat'
# $uri = 'https://raw.githubusercontent.com/bonguides25/PowerShell/refs/heads/main/Utilities/Files/thumbnails-bg.bat'
(New-Object Net.WebClient).DownloadFile($uri, $filePath)
