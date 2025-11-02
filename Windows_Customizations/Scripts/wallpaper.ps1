
# --- Configuration ---
$ImageUrl = "https://raw.githubusercontent.com/bonguides25/PowerShell/main/Windows_Customizations/Files/img0.jpeg"
$SavePath = "$env:TEMP\wallpaper.jpeg"

# --- Download image ---
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $ImageUrl -OutFile $SavePath -UseBasicParsing

# --- Update wallpaper style (Fill) ---
# 0=Center, 2=Stretch, 6=Fit, 10=Fill, 22=Span
Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value 10
Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name TileWallpaper  -Value 0
Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value $SavePath

# --- Apply wallpaper immediately ---
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE   = 0x01
$SPIF_SENDCHANGE      = 0x02
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $SavePath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE) | Out-Null
