$path = "C:\OtohitsApp"
New-Item -Path $path -ItemType Directory -Force
Set-Location $path
$uri = "https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Temp/OtohitsApp.zip"
$filePath = "$path\OtohitsApp.zip"
(New-Object Net.WebClient).DownloadFile($uri, $filePath)
Expand-Archive .\*.zip -DestinationPath . -Force | Out-Null
Invoke-Item $path

.\nssm.exe install OtohitsApp "C:\OtohitsApp\OtohitsApp.exe"
Get-Service 'OtohitsApp' | Start-Service

<# $WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\OtohitsApp.lnk")
$Shortcut.TargetPath = "C:\OtohitsApp\OtohitsApp.exe"
$Shortcut.Save() #>

Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0  | Out-Null
Get-AppxPackage 'MicrosoftTeams*' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.OneDrive*' | Remove-AppxPackage

winget uninstall Microsoft.OneDrive --accept-source-agreements

function unInstallTeams($path) {
    $clientInstaller = "$($path)\Update.exe"
     try {
          $process = Start-Process -FilePath "$clientInstaller" -ArgumentList "--uninstall /s" -PassThru -Wait -ErrorAction STOP
          if ($process.ExitCode -ne 0)
      {
        Write-Error "UnInstallation failed with exit code  $($process.ExitCode)."
          }
      }
      catch {
          Write-Error $_.Exception.Message
      }
  }
  
  # Remove Teams Machine-Wide Installer
  Write-Host "Removing Teams Machine-wide Installer" -ForegroundColor Yellow
  
  $MachineWide = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}
  $MachineWide.Uninstall()
  
  # Remove Teams for Current Users
  $localAppData = "$($env:LOCALAPPDATA)\Microsoft\Teams"
  $programData = "$($env:ProgramData)\$($env:USERNAME)\Microsoft\Teams"
  
  
  If (Test-Path "$($localAppData)\Current\Teams.exe") 
  {
    unInstallTeams($localAppData)
      
  } elseif (Test-Path "$($programData)\Current\Teams.exe") {
    unInstallTeams($programData)
  } else {
    Write-Warning  "Teams installation not found"
  }
