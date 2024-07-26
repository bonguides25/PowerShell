
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v TargetReleaseversion /t REG_DWORD /d 1

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
Start-Sleep -Seconds 1
$userpath = [System.Environment]::GetEnvironmentVariable("Path","User")
$machinePath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
$env:Path = $userpath + ";" + $machinePath
oh-my-posh font install JetBrainsMono
