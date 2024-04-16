# Download links
$uri = "https://github.com/bonben365/office-installer/raw/main/setup.exe"
$productId = "O365ProPlusRetail"
$languageId = "en-US"
$arch = '64'

$workingDir = New-Item -Path $env:temp\ClickToRun\$productId -ItemType Directory -Force
Set-Location $workingDir

$configurationFile = "configuration-x$arch.xml"
New-Item $configurationFile -ItemType File -Force | Out-Null
Add-Content $configurationFile -Value "<Configuration>"
Add-content $configurationFile -Value "<Add OfficeClientEdition=`"$arch`">"
Add-content $configurationFile -Value "<Product ID=`"$productId`">"
Add-content $configurationFile -Value "<Language ID=`"$languageId`"/>"
Add-Content $configurationFile -Value "</Product>"
Add-Content $configurationFile -Value "</Add>"
Add-Content $configurationFile -Value "</Configuration>"

(New-Object Net.WebClient).DownloadFile($uri, "$workingDir\ClickToRun.exe")

Start-Process -FilePath .\ClickToRun.exe -ArgumentList "/configure .\$($configurationFile)" -NoNewWindow -Wait
