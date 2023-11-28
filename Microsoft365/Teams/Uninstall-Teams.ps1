# Clearing Teams Cache
# Uninstall Teams

$clearCache = Read-Host "Do you want to delete the Teams Cache (Y/N)?"
$clearCache = $clearCache.ToUpper()

$uninstall= Read-Host "Do you want to uninstall Teams completely (Y/N)?"
$uninstall= $uninstall.ToUpper()


if ($clearCache -eq "Y"){
    Write-Host "Stopping Teams Process" -ForegroundColor Yellow

    try{
        Get-Process -ProcessName Teams | Stop-Process -Force
        Start-Sleep -Seconds 3
        Write-Host "Teams Process Sucessfully Stopped" -ForegroundColor Green
    }catch{
        Write-Output $_
    }
    
    Write-Host "Clearing Teams Disk Cache" -ForegroundColor Yellow

    try{
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\application cache\cache" | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\blob_storage" | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\databases" | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\cache" | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\gpucache" | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Indexeddb" | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Local Storage" | Remove-Item -Confirm:$false
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\tmp" | Remove-Item -Confirm:$false
        Write-Host "Teams Disk Cache Cleaned" -ForegroundColor Green
    }catch{
        Write-Output $_
    }
}

if ($uninstall -eq "Y"){
    Write-Host "Removing Teams apps..." -ForegroundColor Yellow
    $winget = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq 'Microsoft.DesktopAppInstaller'}
    If ([Version]$winGet.Version -lt "2022.506.16.0") {
        Invoke-RestMethod bonguides.com/winget | Invoke-Expression
    }

    $path = "C:\Program Files\WindowsApps"
    $winget = Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "WinGet.exe" } | Select-Object -ExpandProperty fullname -ErrorAction SilentlyContinue

    If ($winget.count -gt 1){ $winget = $winget[-1] }

    & $winget --uninstall Microsoft.Teams --exact --silent --force -ErrorAction SilentlyContinue
    & $winget --uninstall Microsoft.Teams.Classic --exact --silent --force -ErrorAction SilentlyContinue
    & $winget --uninstall MicrosoftTeams_8wekyb3d8bbwe --exact --silent --force -ErrorAction SilentlyContinue
    & $winget --uninstall {731F6BAA-A986-45A4-8936-7C3AAAAA760B} --exact --silent --force -ErrorAction SilentlyContinue

}