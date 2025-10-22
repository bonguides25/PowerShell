# VMware Tools auto install (VMware only)
# Run as Administrator

$downloadUrl = 'https://vdconline-my.sharepoint.com/personal/navara_vdconline_onmicrosoft_com/_layouts/15/download.aspx?share=ERzUEYjFZ7hOq0JeegVTByMBlUjydBxB4Ug1EAIjHyI6YQ'
$downloadPath = 'C:\Temp'
$installer = 'VMware-Tools.exe'
$installerPath = "$downloadPath\$installer"

$manufacturer = (Get-CimInstance Win32_ComputerSystem).Manufacturer
$model = (Get-CimInstance Win32_ComputerSystem).Model

if ($manufacturer -match "VMware" -or $model -match "VMware") {
    New-Item -ItemType Directory -Path $downloadPath -Force | Out-Null
    (New-Object Net.WebClient).DownloadFile($downloadUrl, $installerPath)
    Start-Process -FilePath $installerPath -ArgumentList '/S /v"/qn REBOOT=R"' -Wait
    Remove-Item $installerPath -Force
}
