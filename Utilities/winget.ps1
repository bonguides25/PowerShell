#Download winget and license file
function getLink($match) {
    $uri = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $get = Invoke-RestMethod -uri $uri -Method Get -ErrorAction stop
    $data = $get[0].assets | Where-Object name -Match $match
    return $data.browser_download_url
}

$url = getLink("msixbundle")
$licenseUrl = getLink("License1.xml")

# Finally, install winget
$fileName = 'winget.msixbundle'
$licenseName = 'license1.xml'

(New-Object Net.WebClient).DownloadFile($url, "$path\$fileName")
(New-Object Net.WebClient).DownloadFile($licenseUrl, "$path\$licenseName")

Add-AppxProvisionedPackage -Online -PackagePath $fileName -LicensePath $licenseName | Out-Null
Write-Host
Write-Host Installed packages: -ForegroundColor Green
Write-Host
# Checking installed apps

$packages = @("DesktopAppInstaller")
$report = ForEach ($package in $packages){
    Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like "*$package*"} | Select-Object DisplayName,Version}

$report | Format-Table
Write-Host "$(winget -v)"

# Cleanup
Remove-Item $path\* -Recurse -Force