
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

$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

foreach ($regPath in $regPaths) {
    $apps = Get-ChildItem $regPath -ErrorAction SilentlyContinue
    foreach ($app in $apps) {
        $props = Get-ItemProperty $app.PSPath
        if ($props.DisplayName -like "*WinRAR*") {
            $installedVersion = $($props.DisplayVersion)
        }
    }
}

if ($installedVersion -lt $latestVersion) {
    # Download the file
    $webClient = [System.Net.WebClient]::new()
    $webClient.DownloadFile($installerUrl, "$env:TEMP\setup.exe")
    Write-Host "Updating from $installedVersion to $latestVersion"
    Start-Process -FilePath "$env:TEMP\setup.exe" -ArgumentList '-s1' -Wait
} else {
    Write-Host "The latest version already installed."
}
