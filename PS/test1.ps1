# Create service for Otohit

    $path = "C:\OtohitsApp"
    $null = New-Item -Path $path -ItemType Directory -Force
    Set-Location $path
    $uri = "https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/Temp/OtohitsApp.zip"
    $filePath = "$path\OtohitsApp.zip"
    (New-Object Net.WebClient).DownloadFile($uri, $filePath)
    Expand-Archive .\*.zip -DestinationPath . -Force | Out-Null
    Invoke-Item $path
    
    .\nssm.exe install OtohitsApp "C:\OtohitsApp\OtohitsApp.exe"
    Get-Service 'OtohitsApp' | Start-Service
    Set-Service -Name OtohitsApp -StartupType Automatic
