Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://community.chocolatey.org/install.ps1 | iex
Set-Location 'C:\ProgramData\chocolatey\bin'
.\choco.exe feature enable -n allowGlobalConfirmation
Start-Process -FilePath msiexec.exe -ArgumentList "/i https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -Wait
msiexec.exe /i https://download-installer.cdn.mozilla.net/pub/firefox/releases/142.0.1/win64/en-US/Firefox%20Setup%20142.0.1.msi

RefreshEnv

# .\choco.exe install -y 7zip.install
# .\choco.exe install -y adobereader
# .\choco.exe install -y foxitreader
.\choco.exe install -y vscode
# .\choco.exe install -y nordvpn
.\choco.exe install -y audacity -y
.\choco.exe install -y winamp -y
.\choco.exe install -y paint.net -y
.\choco.exe install -y inkscape -y
.\choco.exe install -y zoom -y
.\choco.exe install -y evernote -y
