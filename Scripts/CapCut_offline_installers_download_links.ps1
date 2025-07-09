# Set GitHub API URL for CapCut manifests
$apiUrl = "https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/b/ByteDance/CapCut"

# Fetch version directories
$versions = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'PowerShell' }

# Filter only folders (versions)
$versionFolders = $versions | Where-Object { $_.type -eq "dir" }

# Extract version names and sort descending
$sortedVersions = $versionFolders | ForEach-Object { $_.name } | Sort-Object {[version]$_} -Descending

# Get latest version folder name
$latestVersion = $sortedVersions[0]

# Compose path to installer YAML in latest version folder
$installerApiUrl = "$apiUrl/$latestVersion"

# Get contents of that version folder
$latestFiles = Invoke-RestMethod -Uri $installerApiUrl -Headers @{ 'User-Agent' = 'PowerShell' }

# Find the installer YAML (contains .installer.yaml)
$installerFile = $latestFiles | Where-Object { $_.name -like "*.installer.yaml" }

# Download and parse YAML content
$yamlUrl = $installerFile.download_url
$yamlContent = Invoke-RestMethod -Uri $yamlUrl -Headers @{ 'User-Agent' = 'PowerShell' }
$installerUrl = ($yamlContent -join "`n") -match "InstallerUrl:\s+(http.*)" | ForEach-Object { $Matches[1] }

# Output result
Write-Host "Latest CapCut Version: $latestVersion"
Write-Host "Installer URL: $installerUrl"
