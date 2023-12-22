[System.Net.ServicePointManager]::SecurityProtocol = 'TLS12'
$hookUrl = "https://discord.com/api/webhooks/1187416596629692557/CF1UF2boFlmNOVYaKfWc3yp8VGsDUaQuifI4OuU98a7biUkr8Ps2fhNy7G1YqeVbWMse"
$content = @"
- SVN Proxy: $($env:computername)
- Number of workers: $((Get-NetTCPConnection -State Established -LocalPort 28000).Count)
- Date: $(Get-Date)
"@

$payload = [PSCustomObject]@{
    content = $content
}

$params = @{
    Uri = $hookUrl
    Method = 'Post'
    Body = ($payload | ConvertTo-Json) 
    ContentType = 'Application/Json'
}

Invoke-RestMethod  @params

$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 120)
$Action = New-ScheduledTaskAction -Execute "PowerShell" -Argument "-NoProfile -ExecutionPolicy Bypass -File 'C:\Users\mpnadmin\Desktop\monitor.ps1'" -WorkingDirectory 'C:\Users\mpnadmin\Desktop'
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask -TaskName "CDX-Monitoring" -Trigger $Trigger -Action $Action -Principal $Principal
Get-ScheduledTask -TaskName *CDX-Monitoring*