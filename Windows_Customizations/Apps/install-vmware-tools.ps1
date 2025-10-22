<# 
.SYNOPSIS
  If running inside VMware, download and silently install the latest VMware Tools x64.

.USAGE
  Run in an elevated PowerShell:
    .\Install-VMTools-IfVMware.ps1 [-DownloadFolder C:\Temp\VMwareTools] [-KeepInstaller]

.NOTES
  - Uses (New-Object Net.WebClient).DownloadFile for download.
  - Suppresses auto reboot (REBOOT=R). Exit code 3010 means reboot required.
#>

param(
  [string]$BaseUrl = 'https://packages.vmware.com/tools/esx/latest/windows/x64/',
  [string]$DownloadFolder = 'C:\Temp\VMwareTools',
  [switch]$KeepInstaller
)

# ------------------ Helpers ------------------

function Test-IsAdmin {
  $id  = [Security.Principal.WindowsIdentity]::GetCurrent()
  $pri = [Security.Principal.WindowsPrincipal]::new($id)
  $pri.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Test-IsVmwareVm {
  try {
    $cs   = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
    $bios = Get-CimInstance Win32_BIOS -ErrorAction Stop
    $manu = ($cs.Manufacturer   -as [string])
    $model= ($cs.Model          -as [string])
    $biosv= ($bios.SMBIOSBIOSVersion -as [string])

    $ven15ad = ($null -ne (Get-CimInstance Win32_NetworkAdapter -ErrorAction SilentlyContinue |
                  Where-Object { $_.PNPDeviceID -match 'VEN_15AD' } | Select-Object -First 1))

    return ($manu -match 'VMware' -or $model -match 'VMware' -or $biosv -match 'VMware' -or $ven15ad)
  } catch { return $false }
}

function Get-InstalledVmtoolsVersion {
  # Try MSI product registry then VMware Tools key
  $ver = $null
  try {
    $regPath = 'HKLM:\SOFTWARE\VMware, Inc.\VMware Tools'
    if (Test-Path $regPath) {
      $ver = (Get-ItemProperty $regPath -ErrorAction Stop).Version
    }
  } catch {}

  if (-not $ver) {
    try {
      $prodKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
      $ver = Get-ChildItem $prodKey -ErrorAction SilentlyContinue |
            ForEach-Object { Get-ItemProperty $_.PsPath -ErrorAction SilentlyContinue } |
            Where-Object { $_.DisplayName -match 'VMware Tools' } |
            Select-Object -First 1 -ExpandProperty DisplayVersion
    } catch {}
  }

  return $ver
}

function Get-LatestVmtoolsUrl {
  param([Parameter(Mandatory)] [string]$IndexUrl)

  # Ensure TLS 1.2 for older systems
  try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

  # Get directory index HTML
  $html = (Invoke-WebRequest -Uri $IndexUrl -UseBasicParsing -ErrorAction Stop).Content

  # Pull all .exe hrefs
  $matches = [regex]::Matches($html, 'href="([^"]+\.exe)"', 'IgnoreCase')
  if ($matches.Count -eq 0) { throw "No .exe links found at $IndexUrl" }

  $links = $matches | ForEach-Object { $_.Groups[1].Value } |
           ForEach-Object {
              if ($_ -match '^https?://') { $_ } else { ($IndexUrl.TrimEnd('/') + '/' + $_) }
           }

  # Try to parse version/build to pick the newest
  $candidates = foreach ($u in $links) {
    # Expect: VMware-tools-13.0.0-24696409-x64.exe
    if ($u -match 'VMware-tools-(?<ver>[0-9\.]+)-(?(?=.+)-(?<build>\d+))?.*?-x64\.exe$') {
      [pscustomobject]@{
        Url   = $u
        Ver   = [version]$Matches['ver']
        Build = if ($Matches['build']) { [int64]$Matches['build'] } else { 0 }
      }
    } else {
      [pscustomobject]@{ Url = $u; Ver = [version]'0.0'; Build = 0 }
    }
  }

  $best = $candidates | Sort-Object Ver, Build -Descending | Select-Object -First 1
  if (-not $best) { throw "Unable to determine latest VMware Tools from $IndexUrl" }
  return $best.Url
}

# ------------------ Main ------------------

if (-not (Test-IsAdmin)) {
  Write-Error "Run this script as Administrator."
  exit 1
}

if (-not (Test-IsVmwareVm)) {
  Write-Host "This machine does not appear to be a VMware VM. No action taken."
  exit 0
}

# Check if already installed (basic)
$installedVer = Get-InstalledVmtoolsVersion
if ($installedVer) {
  Write-Host "Existing VMware Tools version detected: $installedVer"
}

# Prepare folder
if (-not (Test-Path $DownloadFolder)) {
  New-Item -ItemType Directory -Path $DownloadFolder -Force | Out-Null
}

# Resolve latest URL and local path
try {
  $latestUrl   = Get-LatestVmtoolsUrl -IndexUrl $BaseUrl
  $installer   = Split-Path $latestUrl -Leaf
  $installerPath = Join-Path $DownloadFolder $installer
  Write-Host "Latest VMware Tools: $latestUrl"
} catch {
  Write-Error "Failed to get latest VMware Tools URL: $_"
  exit 2
}

# Download with WebClient
try {
  Write-Host "Downloading to $installerPath ..."
  $wc = New-Object Net.WebClient
  $wc.DownloadFile($latestUrl, $installerPath)
  Write-Host "Download complete."
} catch {
  Write-Error "Download failed: $_"
  exit 3
}

# Quick size sanity (>= 20MB)
try {
  $size = (Get-Item $installerPath).Length
  if ($size -lt 20MB) { throw "Downloaded file too small: $size bytes" }
} catch {
  Write-Error $_
  exit 4
}

# Silent install
try {
  Write-Host "Installing VMware Tools silently..."
  $args = '/S /v"/qn REBOOT=R"'
  $p = Start-Process -FilePath $installerPath -ArgumentList $args -Wait -PassThru
  $code = $p.ExitCode
  Write-Host "Installer exit code: $code"
  switch ($code) {
    0     { Write-Host "VMware Tools installed successfully." }
    3010  { Write-Warning "Installed successfully. Reboot is required (exit code 3010)." }
    default { throw "Installer returned exit code $code" }
  }
} catch {
  Write-Error "Installation failed: $_"
  exit 5
}

# Cleanup
if (-not $KeepInstaller) {
  try { Remove-Item $installerPath -Force } catch { Write-Warning "Could not delete installer: $installerPath" }
} else {
  Write-Host "Keeping installer at: $installerPath"
}

Write-Host "Done."
