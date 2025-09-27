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
msiexec.exe /i https://download-installer.cdn.mozilla.net/pub/firefox/releases/142.0.1/win64/en-US/Firefox%20Setup%20142.0.1.msi

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
