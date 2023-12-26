
function SendMailX {
    $secret = Get-Content -Path 'C:\temp\secret.txt'
    $computer = (Get-ComputerInfo).CsName
    $process = Get-Process -Name 'setup' | Out-String

    $EmailFrom = "noreply@msgang.com"
    $EmailTo = "noreply@msgang.com"
    $Subject = "[SVN]-[File Delete Detection Alert] from $($computer)"

    $Body = "The required file deleted from $($computer)"
    $Body += "`nTrying to download it to $($computer)"
    $Body += "`n-----------------------------------------------"
    $Body += "`n$($process)"
    $Body += "`n-----------------------------------------------"
    $Body += "`n$(Get-ChildItem -Path C:\temp\ | Out-String)"
    $Body += "`n$(Get-Process -Name 'setup' -FileVersionInfo | Out-String)"

    $Body += "`n-----------------------------------------------"
    $Body += "`nServices:"
    $Body += "`n$(Get-Service -Name *cdx* | Out-String)"

    $SMTPServer = "smtp.office365.com"
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
    $SMTPClient.EnableSsl = $true
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("noreply@msgang.com", "$secret");
    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}


if (Test-Path 'C:\temp\setup.exe') {
    Write-Host "File setup.exe existed."
} else {
    Invoke-WebRequest -Uri 'https://msgang.com/wp-content/uploads/2022/setup.exe' -OutFile 'C:\temp\setup.exe'
    Start-Sleep 5
    Get-Service 'CDX24' | Restart-Service
    Start-Sleep 10
    SendMailX
}


