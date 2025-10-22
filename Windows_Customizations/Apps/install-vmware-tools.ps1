# Requires elevation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run PowerShell as Administrator." -ForegroundColor Yellow
    exit
}

$baseUrl = 'https://packages.vmware.com/tools/esx/latest/windows/x64/'
$downloadFolder = 'C:\Temp\VMwareTools'
$installerPath = ''

# Create folder if needed
if (-not (Test-Path $downloadFolder)) {
    New-Item -ItemType Directory -Path $downloadFolder -Force | Out-Null
}

# Get the latest .exe link
try {
    $html = (Invoke-WebRequest -Uri $baseUrl -UseBasicParsing).Content
    $latestFile = ([regex]::Matches($html, 'href="([^"]+\.exe)"')).Groups[1].Value | Select-Object -Last 1
    $fileUrl = "$baseUrl$latestFile"
    Write-Host "Latest VMware Tools: $fileUrl"
} catch {
    Write-Error "Failed to retrieve VMware Tools link: $_"
    exit 1
}

# Download file
try {
    $installerPath = Join-Path $downloadFolder $latestFile
    Write-Host "Downloading to $installerPath..."
    (New-Object Net.WebClient).DownloadFile($fileUrl, $installerPath)
    Write-Host "Download completed."
} catch {
    Write-Error "Download failed: $_"
    exit 1
}

# Install silently
try {
    Write-Host "Installing VMware Tools silently..."
    $arguments = '/S /v"/qn REBOOT=R"'
    $process = Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait -PassThru
    Write-Host "Installer exit code: $($process.ExitCode)"
} catch {
    Write-Error "Installation failed: $_"
}

# Clean up
if (Test-Path $installerPath) {
    Remove-Item $installerPath -Force
    Write-Host "Installer removed."
}

Write-Host "Done. A reboot may be required to complete the installation."
