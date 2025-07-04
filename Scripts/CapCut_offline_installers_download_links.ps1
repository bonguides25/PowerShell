# Step 1: Define GitHub API URL for CapCut manifest repository
$repoUrl = "https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/b/ByteDance/CapCut"

# Step 2: Fetch the folder structure (requires User-Agent)
$response = Invoke-RestMethod -Uri $repoUrl -Headers @{ "User-Agent" = "PowerShell" }

# Step 3: Extract version folder names
$versionFolders = $response | Where-Object { $_.type -eq "dir" } | Select-Object -ExpandProperty name

# Step 4: Sort versions in descending order (using natural version comparison)
$latestVersion = $versionFolders | Sort-Object -Descending | Select-Object -First 1

# Step 5: Construct the download URL for the YAML file
$installerYamlUrl = $repoUrl + '/' + $latestVersion + '/' + 'ByteDance.CapCut.installer.yaml'

# Step 6: Fetch the YAML manifest and extract the installer URL
$yamlContent = Invoke-RestMethod -Uri $installerYamlUrl -Headers @{ "User-Agent" = "PowerShell" }
$installerUrl = ($yamlContent -join "`n") -match "InstallerUrl:\s+(http.*)" | ForEach-Object { $Matches[1] }

# Output the latest version and installer URL
Write-Host "Latest Version: $latestVersion"
Write-Host "Installer URL: $installerUrl"
