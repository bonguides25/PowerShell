# Installing Chocolatey package manager
Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://community.chocolatey.org/install.ps1 | iex

RefreshEnv
Set-Location 'C:\ProgramData\chocolatey\bin'
.\choco.exe feature enable -n allowGlobalConfirmation
.\choco.exe install GoogleChrome -y --ignore-check
.\choco.exe install firefox -y
.\choco.exe install vlc -y
.\choco.exe install winscp -y
.\choco.exe install zoom -y
.\choco.exe install thunderbird -y
.\choco.exe install fscapture -y
.\choco.exe install teamviewer -y
.\choco.exe install VisualStudioCode -y
