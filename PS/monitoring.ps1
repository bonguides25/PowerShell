if ($env:computername -match 'proxy02') {
    $source = 'SVN'
    $port = '28000'
} else {
    $source = 'TSG'
    $port = '27000'
}
Set-ExecutionPolicy Bypass -Scope Process -Force
# [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
[System.Net.ServicePointManager]::SecurityProtocol = 'TLS12'
$hookUrl = "https://discord.com/api/webhooks/1187416596629692557/CF1UF2boFlmNOVYaKfWc3yp8VGsDUaQuifI4OuU98a7biUkr8Ps2fhNy7G1YqeVbWMse"
$content = @"
- $($source): $((Get-NetTCPConnection -State Established -LocalPort $port).Count) - $(Get-Date)
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