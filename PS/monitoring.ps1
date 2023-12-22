$hookUrl = "https://discord.com/api/webhooks/1187416596629692557/CF1UF2boFlmNOVYaKfWc3yp8VGsDUaQuifI4OuU98a7biUkr8Ps2fhNy7G1YqeVbWMse"
$content = @"
- Date: $(Get-Date)
- SVN Proxy: $($env:computername)
- Windows Edition: $(Get-ComputerInfo -Property OSName | Select-Object -ExpandProperty OSName)
- Number of workers: $((Get-NetTCPConnection -State Established -LocalPort 28000).Count)
- CPU: $((Get-ComputerInfo -Property CsProcessors | Select-Object -ExpandProperty CsProcessors).Name))
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
$Action = New-ScheduledTaskAction -Execute "PowerShell" -Argument "-NoProfile -ExecutionPolicy Bypass -File 'C:\scripts\monitor.txt'" -WorkingDirectory 'C:\scripts\'
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask -TaskName "CDX-Monitoring" -Trigger $Trigger -Action $Action -Principal $Principal