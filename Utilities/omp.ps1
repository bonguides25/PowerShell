Set-ExecutionPolicy Bypass -Scope Process -Force
Start-Sleep -Seconds 1
$url = 'https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest'
$request = [System.Net.WebRequest]::Create($url)
$response = $request.GetResponse()
$tagUrl = $response.ResponseUri.OriginalString
$fileName = "install-x64.msi"

# Create the download link
$downloadUrl = $tagUrl.Replace('tag', 'download') + '/' + $fileName

# Download to the temp folder
(New-Object Net.WebClient).DownloadFile("$downloadUrl", "$env:TEMP/$fileName")

msiexec.exe /i "$env:TEMP\install-x64.msi" /qn
Start-Sleep -Seconds 1

# Update the $env:Path to the current session
$userpath = [System.Environment]::GetEnvironmentVariable("Path","User")
$machinePath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
$env:Path = $userpath + ";" + $machinePath

Start-Sleep -Seconds 1

oh-my-posh font install JetBrainsMono
