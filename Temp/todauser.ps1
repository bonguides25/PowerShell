# After install (user)
# Modify State Key
Write-Host "Starting Microsoft Teams..." -ForegroundColor Green
start "shell:AppsFolder\$(Get-StartApps "*teams*" | select -ExpandProperty AppId)"
Start-Sleep -Seconds 5
Stop-Process (Get-Process ms-teams).Id
Write-Host "Disabling Teams starts on boot..." -ForegroundColor Green
$rpath = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MSTeams_8wekyb3d8bbwe\TeamsTfwStartupTask"
if (Test-Path $rpath) {
    # Modify State
    Set-ItemProperty -Path $rpath -Name "State" -Value "0"
    # Modify LastDisabledTime
    $epoch = (Get-Date -Date ((Get-Date).DateTime) -UFormat %s)
    Set-ItemProperty -Path $rpath -Name "LastDisabledTime" -Value $epoch
    Write-Host "Autostart NEW Teams has been Disabled" -ForegroundColor Green
} else {
    Write-Host "NEW Teams is not found"
}

Write-Host "Mapping the network drive..." -ForegroundColor Green
net use X: \\192.168.0.3\data /persistent:yes
Start-Sleep -Seconds 2

Write-Host "Renaming the network drive lable..." -ForegroundColor Green
function Set-DriveName($Drive, $Name){
    (New-Object -ComObject Shell.Application).NameSpace($Drive).Self.Name = $Name
}

powershell -c "(New-Object -ComObject Shell.Application).NameSpace('X:').Self.Name = 'TVCHanServer'"

net use
