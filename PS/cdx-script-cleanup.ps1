# Cleanuo the scripts without re-provision

Write-Host "1. Removing any scripts." -ForegroundColor Yellow
Write-Host "    Current: $((Get-MgBetaDeviceManagementScript).DisplayName)" -ForegroundColor Red
Get-MgBetaDeviceManagementScript | ForEach-Object {
    Remove-MgBetaDeviceManagementScript -DeviceManagementScriptId $_.Id
}