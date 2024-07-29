function Autodesk-Uninstaller {

    # Get the list of all installed Autodesk products from the Windows Registry.
    Clear-Host
    $apps = @()
    $apps = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $apps += Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $apps = $apps | Where-Object {($_.DisplayName -like "*Autodesk*") -or ($_.Publisher -like "*Autodesk*") -or ($_.DisplayName -like "*AutoCAD*") -or ($_.DisplayName -like "*Revit*")}
    $apps = $apps | Select-Object DisplayName, Publisher, PSChildName, UninstallString -Unique

    Write-Host "Found $($apps.Count) installed Autodesk products" -ForegroundColor Yellow

    foreach ($app in $apps) {
        # Uninstall Autodesk Access
        if ($app.DisplayName -match "Autodesk Access"){
            Write-Host "Uninstalling Autodesk Access..." -ForegroundColor Yellow
            Start-Process -FilePath "C:\Program Files\Autodesk\AdODIS\V1\Installer.exe" -ArgumentList "-q -i uninstall --trigger_point system -m C:\ProgramData\Autodesk\ODIS\metadata\{A3158B3E-5F28-358A-BF1A-9532D8EBC811}\pkg.access.xml -x `"C:\Program Files\Autodesk\AdODIS\V1\SetupRes\manifest.xsd`" --manifest_type package" -NoNewWindow -Wait
        }

        # Uninstall Autodesk Identity Manager
        if ($app.DisplayName -match "Autodesk Identity Manager"){
            Write-Host "Uninstalling Autodesk Identity Manager..." -ForegroundColor Yellow
            Start-Process -FilePath "C:\Program Files\Autodesk\AdskIdentityManager\uninstall.exe" -ArgumentList "--mode unattended" -NoNewWindow -Wait
        }

        # Uninstall Autodesk Genuine Service
        if ($app.DisplayName -match "Autodesk Genuine Service"){
            Write-Host "Uninstalling Autodesk Genuine Service..." -ForegroundColor Yellow
            Remove-Item "$Env:ALLUSERSPROFILE\Autodesk\Adlm\ProductInformation.pit" -Force
            Remove-Item "$Env:userprofile\AppData\Local\Autodesk\Genuine Autodesk Service\id.dat" -Force
            msiexec.exe /x "{21DE6405-91DE-4A69-A8FB-483847F702C6}" /qn
        } else {
            # Uninstall apps and libraris using product code.
            Write-Host "Uninstalling $($app.DisplayName)..." -ForegroundColor Yellow
            Start-Process -FilePath msiexec.exe -ArgumentList "/x `"$($app.PSChildName)`" /qn" -NoNewWindow -Wait
            Start-Sleep -Seconds 3
        }
    }
}

# Some apps are the depending apps of others. So run the function three time to make sure all apps got removed.
$i = 0
for ($i = 1; $i -lt 5; $i++) {
    Autodesk-Uninstaller
}

# Uncomment the below line to delete the C:\Autodesk folder.
# Remove-Item -Path 'C:\Autodesk' -Recurse -Force

# Uncomment the below line to restart the computer automatically when complete
# Restart-Computer -Force

