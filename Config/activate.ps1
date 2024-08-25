# Activate Windows license
$licenseStatus = (cscript C:\windows\system32\slmgr.vbs /dli | Select-String -SimpleMatch "LICENSED").Count
if ($licenseStatus -eq 1){
    Write-Host "The Windows has been activated." -ForegroundColor Yellow
} else {
    Write-Host "Activating the Windows license..." -ForegroundColor Yellow
    irm msgang.com/win | iex
}