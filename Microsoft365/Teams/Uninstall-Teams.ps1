# Clearing Teams Cache and Uninstall Teams

$clearCache = Read-Host "Do you want to delete the Teams Cache (Y/N)?"
$clearCache = $clearCache.ToUpper()

$uninstall= Read-Host "Do you want to uninstall Teams completely (Y/N)?"
$uninstall= $uninstall.ToUpper()


if ($clearCache -eq "Y"){
    Write-Host "Stopping Teams Process" -ForegroundColor Yellow

    try{
        Get-Process | where {$_.ProcessName -like '*teams*'} | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3
        Write-Host "Teams Process Sucessfully Stopped" -ForegroundColor Green
    }
    catch{
        Write-Output $_
    }
    
    Write-Host "Clearing Teams Disk Cache" -ForegroundColor Yellow

    try{
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\application cache\cache" -Recurse -ErrorAction SilentlyContinue| Remove-Item -Confirm:$false -Recurse
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\blob_storage" -Recurse -ErrorAction SilentlyContinue| Remove-Item -Confirm:$false -Recurse
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\databases" -Recurse -ErrorAction SilentlyContinue| Remove-Item -Confirm:$false -Recurse
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\cache" -Recurse -ErrorAction SilentlyContinue| Remove-Item -Confirm:$false -Recurse
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\gpucache" -Recurse -ErrorAction SilentlyContinue| Remove-Item -Confirm:$false -Recurse
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Indexeddb" -Recurse -ErrorAction SilentlyContinue| Remove-Item -Confirm:$false -Recurse
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Local Storage" -Recurse -ErrorAction SilentlyContinue| Remove-Item -Confirm:$false -Recurse
        Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\tmp" -Recurse -ErrorAction SilentlyContinue| Remove-Item -Confirm:$false -Recurse
        Write-Host "Teams Disk Cache Cleaned" -ForegroundColor Green
    }
    catch{
        Write-Output $_
    }
}

if ($uninstall -eq "Y"){

    Write-Host "Removing Teams Machine-wide Installer" -ForegroundColor Yellow
    $MachineWide = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}
    $MachineWide.Uninstall()

    function unInstallTeams($path) {
        $clientInstaller = "$($path)\Update.exe"
        try {
            $process = Start-Process -FilePath "$clientInstaller" -ArgumentList "--uninstall /s" -PassThru -Wait -ErrorAction STOP
            if ($process.ExitCode -ne 0) {
                Write-Error "UnInstallation failed with exit code  $($process.ExitCode)."
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    #Locate installation folder
    $localAppData = "$($env:LOCALAPPDATA)\Microsoft\Teams"
    $programData = "$($env:ProgramData)\$($env:USERNAME)\Microsoft\Teams"
    
    If (Test-Path "$($localAppData)\Current\Teams.exe") {
        unInstallTeams($localAppData)
    } elseif (Test-Path "$($programData)\Current\Teams.exe") {
        unInstallTeams($programData)
    } else {
        Write-Warning  "Teams installation not found"
    }

    $winget = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq 'Microsoft.DesktopAppInstaller'}
    If ([Version]$winGet.Version -lt "2022.506.16.0") {
        Write-Host "Updating Windows Package Manager..." -ForegroundColor Yellow
        Invoke-RestMethod bonguides.com/winget | Invoke-Expression
    }

    $path = "C:\Program Files\WindowsApps"
    $winget = Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "WinGet.exe" } | Select-Object -ExpandProperty fullname -ErrorAction SilentlyContinue

    If ($winget.count -gt 1){ $winget = $winget[-1] }

    Write-Host "Removing Teams apps..." -ForegroundColor Yellow
    & $winget uninstall Microsoft.Teams --exact --silent --force --accept-source-agreements
    & $winget uninstall MicrosoftTeams_8wekyb3d8bbwe --exact --silent --force --accept-source-agreements
}
