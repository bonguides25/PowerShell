<#=============================================================================================
Script by    : Leo Nguyen
Website      : www.bonguides.com
Telegram     : https://t.me/bonguides
Discord      : https://discord.gg/fUVjuqexJg
YouTube      : https://www.youtube.com/@BonGuides

Script Highlights:
~~~~~~~~~~~~~~~~~
#. Install Chocolatey Package Manager (choco)
============================================================================================#>

# Build a runspace
$runspace = [runspacefactory]::CreateRunspace()
$runspace.ApartmentState = 'STA'
$runspace.ThreadOptions = 'ReuseThread'
$runspace.Open()

# Share info between runspaces
$sync = [hashtable]::Synchronized(@{})
$sync.runspace = $runspace
$sync.host = $host

# Add shared data to the runspace
$runspace.SessionStateProxy.SetVariable("sync", $sync)

$scriptBlock = {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

$PSIinstance = [powershell]::Create().AddScript($scriptBlock)
$PSIinstance.Runspace = $runspace
$result = $PSIinstance.BeginInvoke()

do { 
  Start-Sleep -Second 1 
} until ($result.IsCompleted -eq "true")

$PSIinstance.Dispose()

Write-Host "Choco version: $(choco --version)"