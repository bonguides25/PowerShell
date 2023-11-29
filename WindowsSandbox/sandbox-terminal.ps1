#Install and update Desktop framework packages
Set-Location $env:temp
ii $env:temp
$uri = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
(New-Object Net.WebClient).DownloadFile($uri, "$env:temp\Microsoft.VCLibs.x64.14.00.Desktop.appx")
Add-AppxPackage -Path .\Microsoft.VCLibs.x64.14.00.Desktop.appx

$ProgressPreference='Silent'
$url = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
(New-Object Net.WebClient).DownloadFile($url, "$env:temp\nuget.exe")
.\nuget.exe install Microsoft.UI.Xaml -Version 2.8 | Out-Null
Add-AppxPackage -Path ".\Microsoft.UI.Xaml.2.8.0\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.8.appx" -ErrorAction:SilentlyContinue | Out-Null

#Download the package to the Downloads folder of current logged on user
$url = 'https://github.com/microsoft/terminal/releases/latest'
$request = [System.Net.WebRequest]::Create($url)
$response = $request.GetResponse()
$tagUrl = $response.ResponseUri.OriginalString
$version = $tagUrl.split('/')[-1].Trim('v')
$fileName = "Microsoft.WindowsTerminal_$($version)_8wekyb3d8bbwe.msixbundle"
$downloadUrl = $tagUrl.Replace('tag', 'download') + '/' + $fileName
(New-Object Net.WebClient).DownloadFile($downloadUrl, "$env:temp\WindowsTerminal.msixbundle")

#Install Windows Terminal
Add-AppxPackage -Path ".\WindowsTerminal.msixbundle"


$progressPreference = 'silentlyContinue'
Write-Information "Downloading WinGet and its dependencies..."
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle