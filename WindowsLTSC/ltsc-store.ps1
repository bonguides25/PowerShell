<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Install Microsoft Store on Windows LTSC systems.
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
    Write-Host "`nInstalling dependency packages..." -ForegroundColor Yellow
    $uri = "https://filedn.com/lOX1R8Sv7vhpEG9Q77kMbn0/bonben365.com/Zip/microsoftstore-win-ltsc.zip"
    (New-Object Net.WebClient).DownloadFile($uri, "$env:temp\temp\microsoftstore-win-ltsc.zip")

    # Extract downloaded file then run the script
    $null = Expand-Archive .\microsoftstore-win-ltsc.zip -Force -ErrorAction:SilentlyContinue
    Set-Location "$env:temp\temp\microsoftstore-win-ltsc"

    
    # Geeting the Windows architecture
        if ([System.Environment]::Is64BitOperatingSystem -like "True") {
            $arch = "x64"
        } else {
            $arch = "x86"
        }

    # Installing dependency packages
        $progressPreference = 'silentlyContinue'
        if ($arch -eq "x86") {
            $depens = Get-ChildItem | Where-Object {($_.Name -match '^*Microsoft.NET.Native*|^*VCLibs*') -and ($_.Name -like '*x86*')}
        } 
        if ($arch -eq "x64") {
            $depens = Get-ChildItem | Where-Object {$_.Name -match '^*Microsoft.NET.Native*|^*VCLibs*'}
        }
    
        foreach ($depen in $depens) {
            Add-AppxPackage -Path "$depen" -ErrorAction:SilentlyContinue
        }

    # Install Microsoft Store
        Write-Host "Installing Microsoft Store..." -ForegroundColor Yellow
        $null = Add-AppxProvisionedPackage -Online -PackagePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*WindowsStore*') -and ($_.Name -like '*AppxBundle*') })" -LicensePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*WindowsStore*') -and ($_.Name -like '*xml*') })"

        if ((Get-ChildItem "*StorePurchaseApp*")) {    
            $null = Add-AppxProvisionedPackage -Online -PackagePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*StorePurchaseApp*') -and ($_.Name -like '*AppxBundle*') })" -LicensePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*StorePurchaseApp*') -and ($_.Name -like '*xml*') })"
        }

        if ((Get-ChildItem "*XboxIdentityProvider*")) {
            $null = Add-AppxProvisionedPackage -Online -PackagePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*XboxIdentityProvider*') -and ($_.Name -like '*AppxBundle*') })" -LicensePath "$(Get-ChildItem | Where-Object { ($_.Name -like '*XboxIdentityProvider*') -and ($_.Name -like '*xml*') })"
        }

    # Install Windows Package Manager (winget)
        Invoke-RestMethod bonguides.com/winget | Invoke-Expression

# Installed apps
    $packages = @("WindowsStore")
    $report = ForEach ($package in $packages){Get-AppxPackage -Name *$package* | Select-Object Name,Version,Status }
    Write-Host "Installed packages:" -ForegroundColor Yellow
    $report | Format-Table
    Write-Host "Done." -ForegroundColor Yellow

# Open the Microsoft Store
    start ms-windows-store:

