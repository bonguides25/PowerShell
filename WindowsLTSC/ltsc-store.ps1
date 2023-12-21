<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides
============================================================================================#>

if (-not([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated powershell prompt!"
    Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "irm bonguides.com/ltsc/msstore.com | iex"
    break
}

if ([System.Environment]::OSVersion.Version.Build -lt 16299) {
    Write-Host "This pack is for Windows 10 version 1709 and later" -ForegroundColor Yellow
    Write-Host "Exitting..."
    Start-Sleep -Seconds 3
    exit
}

# Installing dependency packages
    # Create temporary directory
    $null = New-Item -Path $env:temp\temp -ItemType Directory -Force
    Set-Location $env:temp\temp

    # Download required files
    Write-Host "`nInstalling dependency packages..." -ForegroundColor Green
    $uri = "https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/bonben365.com/Zip/microsoftstore-win-ltsc.zip"
    (New-Object Net.WebClient).DownloadFile($uri, "$env:temp\temp\microsoftstore-win-ltsc.zip")

    # Extract downloaded file then run the script
    Expand-Archive .\microsoftstore-win-ltsc.zip -Force -ErrorAction:SilentlyContinue
    Set-Location "$env:temp\temp\microsoftstore-win-ltsc"

    if ([System.Environment]::Is64BitOperatingSystem -like "True") {
        $arch = "x64"
    } else {
        $arch = "x86"
    }

    if (!(Get-ChildItem "*WindowsStore*")) {    
        Write-Host "Error: Required files are missing in the current directory"
        Write-Host "Exitting..."
        Start-Sleep -Seconds 3
        exit
    }

    if ($arch -eq "x86") {
        $depens = Get-ChildItem | Where-Object {($_.Name -match '^*Microsoft.NET.Native*|^*VCLibs*') -and ($_.Name -like '*x86*')}
    } 
    if ($arch -eq "x64") {
        $depens = Get-ChildItem | Where-Object {$_.Name -match '^*Microsoft.NET.Native*|^*VCLibs*'}
    }

    $progressPreference = 'silentlyContinue'
    foreach ($depen in $depens) {
        Add-AppxPackage -Path "$depen" -ErrorAction:SilentlyContinue
    }

    # Install Microsoft Store
    Write-Host "Installing Microsoft Store..." -ForegroundColor Green
    $null = Add-AppxProvisionedPackage -Online -PackagePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*WindowsStore*') -and ($_.Name -like '*AppxBundle*') })" -LicensePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*WindowsStore*') -and ($_.Name -like '*xml*') })"

    if ((Get-ChildItem "*StorePurchaseApp*")) {    

    Add-AppxProvisionedPackage -Online -PackagePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*StorePurchaseApp*') -and ($_.Name -like '*AppxBundle*') })" -LicensePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*StorePurchaseApp*') -and ($_.Name -like '*xml*') })"
    }

    if ((Get-ChildItem "*DesktopAppInstaller*")) {    
    Add-AppxProvisionedPackage -Online -PackagePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*DesktopAppInstaller*') -and ($_.Name -like '*AppxBundle*') })" -LicensePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*DesktopAppInstaller*') -and ($_.Name -like '*xml*') })"
    }

    if ((Get-ChildItem "*XboxIdentityProvider*")) {    
    Add-AppxProvisionedPackage -Online -PackagePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*XboxIdentityProvider*') -and ($_.Name -like '*AppxBundle*') })" -LicensePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*XboxIdentityProvider*') -and ($_.Name -like '*xml*') })"
    }

# Installed apps
    $packages = @("Microsoft.VCLibs","DesktopAppInstaller","WindowsStore","Microsoft.NET.Native")
    $report = ForEach ($package in $packages){Get-AppxPackage -Name *$package* | Select-Object Name,Version,Status }
    write-host "Installed packages:"
    $report | format-table

# Cleanup
    Set-Location "$env:temp"
    Remove-Item $env:temp\temp -Recurse -Force

    Write-Host Done.
    Write-Host 