
New-Item -Path $env:TEMP\vmware -ItemType Directory

ii $env:TEMP\vmware

$hashtable = @{
    'https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.5.2/23775571/windows/core/VMware-workstation-17.5.2-23775571.exe.tar' = "$env:TEMP\vmware\VMware-workstation-17.5.2-23775571.exe.tar"
    'https://jaist.dl.sourceforge.net/project/sevenzip/7-Zip/9.20/7za920.zip' = "$env:TEMP\vmware\7za920.zip"
}

ForEach ($file in $hashtable.GetEnumerator()) {
    $webClient = [System.Net.WebClient]::new()
    $webClient.DownloadFile($file.Key, $file.Value)
}

Set-Location -Path $env:TEMP\vmware

Expand-Archive .\7za920.zip $env:TEMP\vmware

.\7za.exe e .\VMware-workstation-17.5.2-23775571.exe.tar

.\VMware-workstation-17.5.2-23775571.exe /s
