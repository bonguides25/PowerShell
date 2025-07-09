
# GitHub API URL for WinRAR manifests
$apiUrl = "https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/r/RARLab/WinRAR"

# Fetch version folders
$versions = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'PowerShell' }

# Filter only version folders
$versionFolders = $versions | Where-Object { $_.type -eq "dir" }

# Extract and sort version numbers
$sortedVersions = $versionFolders | ForEach-Object { $_.name } | Sort-Object {[version]$_} -Descending

# Get the latest version
$latestVersion = $sortedVersions[0]

# Get contents of the latest version folder
$latestApiUrl = "$apiUrl/$latestVersion"
$latestFiles = Invoke-RestMethod -Uri $latestApiUrl -Headers @{ 'User-Agent' = 'PowerShell' }

# Find the .installer.yaml file
$installerFile = $latestFiles | Where-Object { $_.name -like "*.installer.yaml" }

# Download and parse YAML content
$yamlUrl = $installerFile.download_url
$yamlContent = Invoke-RestMethod -Uri $yamlUrl -Headers @{ 'User-Agent' = 'PowerShell' }
$installerUrl = ($yamlContent -join "`n") -match "InstallerUrl:\s+(http.*)" | ForEach-Object { $Matches[1] }

# Output result
Write-Host "Latest CapCut Version: $latestVersion"
Write-Host "Installer URL: $installerUrl"
