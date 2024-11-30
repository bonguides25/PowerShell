Set-ExecutionPolicy Bypass -Scope Process -Force
Start-Sleep -Seconds 1
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
Start-Sleep -Seconds 1

#Update the $env:Path to the current session
$userpath = [System.Environment]::GetEnvironmentVariable("Path","User")
$machinePath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
$env:Path = $userpath + ";" + $machinePath

Start-Sleep -Seconds 1

oh-my-posh font install JetBrainsMono
