$null = New-Item -Path "$env:TEMP\temp" -ItemType Directory -Force
Set-Location "$env:TEMP\temp"

Invoke-WebRequest -Uri 'https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Temp/nssm.exe' -OutFile "$env:TEMP\temp\nssm.exe"

$uri = "https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Temp/OtohitsApp.zip"
(New-Object Net.WebClient).DownloadFile($uri, "$env:TEMP\temp\OtohitsApp.zip")

$ProgressPreference = 'SilentlyContinue'
$null = Expand-Archive OtohitsApp.zip -DestinationPath . -Force

.\nssm.exe install OtohitsApp "$env:TEMP\temp\OtohitsApp.exe"
Get-Service 'OtohitsApp' | Start-Service
Set-Service -Name OtohitsApp -StartupType Automatic
