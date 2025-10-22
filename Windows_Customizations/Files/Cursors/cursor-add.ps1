# --- Auto-Apply Custom Mouse Pointers ---

$cursors_path = New-Item -Path "C:\Windows\Custom_Cursors" -ItemType Directory -Force
Invoke-WebRequest -Uri 'https://github.com/bonguides25/PowerShell/raw/refs/heads/main/Windows_Customizations/Files/Cursors/LightGreen.cur' -OutFile "$cursors_path\LightGreen.cur"
$Cursors = @{
    "Arrow"          = "$cursors_path\LightGreen.cur"
    "Help"           = "$cursors_path\LightGreen.cur"
    "AppStarting"    = "$cursors_path\LightGreen.cur"
    "Wait"           = "$cursors_path\LightGreen.cur"
    "Crosshair"      = "$cursors_path\LightGreen.cur"
    "IBeam"          = "$cursors_path\LightGreen.cur"
    "NWPen"          = "$cursors_path\LightGreen.cur"
    "No"             = "$cursors_path\LightGreen.cur"
    # "SizeNS"         = "$cursors_path\LightGreen.cur"
    # "SizeWE"         = "$cursors_path\LightGreen.cur"
    # "SizeNWSE"       = "$cursors_path\LightGreen.cur"
    # "SizeNESW"       = "$cursors_path\LightGreen.cur"
    # "SizeAll"        = "$cursors_path\LightGreen.cur"
    # "UpArrow"        = "$cursors_path\LightGreen.cur"
    "Hand"           = "$cursors_path\LightGreen.cur"
}

$RegPath = "HKCU:\Control Panel\Cursors"

# Apply new cursor paths
foreach ($cursor in $Cursors.GetEnumerator()) {
    Set-ItemProperty -Path $RegPath -Name $cursor.Key -Value $cursor.Value
}

# Mark the scheme name (optional)
Set-ItemProperty -Path $RegPath -Name "Scheme Source" -Value "CustomScheme"

# Force Windows to reload the new cursor scheme immediately
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class User32 {
    [DllImport("user32.dll", EntryPoint="SystemParametersInfo", SetLastError=true)]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, string pvParam, uint fWinIni);
}
"@

# SPI_SETCURSORS = 0x0057, SPIF_SENDCHANGE = 0x02
[User32]::SystemParametersInfo(0x0057, 0, "", 0x02) | Out-Null

