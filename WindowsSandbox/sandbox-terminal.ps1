#Install and update Desktop framework packages
Set-Location $env:temp
$uri = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
(New-Object Net.WebClient).DownloadFile($uri, "$env:temp\Microsoft.VCLibs.x64.14.00.Desktop.appx")
Add-AppxPackage -Path 'Microsoft.VCLibs.x64.14.00.Desktop.appx'

$ProgressPreference='Silent'
$url = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
(New-Object Net.WebClient).DownloadFile($url, "$env:temp\nuget.exe")
.\nuget.exe install Microsoft.UI.Xaml -Version 2.7 | Out-Null
Add-AppxPackage -Path ".\Microsoft.UI.Xaml.2.7.0\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx" -ErrorAction:SilentlyContinue | Out-Null

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
$path = Get-ChildItem -Name "*.msixbundle"
Add-AppxPackage -Path $path