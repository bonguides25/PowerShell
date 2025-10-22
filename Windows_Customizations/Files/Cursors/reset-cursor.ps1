# --- Reset to Windows default cursors (Aero) and apply immediately ---

$RegPath = "HKCU:\Control Panel\Cursors"
$Win = $env:SystemRoot

# Default Windows (Aero) cursor map
$DefaultCursors = @{
  "Arrow"       = "$Win\Cursors\aero_arrow.cur"
  "Help"        = "$Win\Cursors\aero_helpsel.cur"
  "AppStarting" = "$Win\Cursors\aero_working.ani"
  "Wait"        = "$Win\Cursors\aero_busy.ani"
  "Crosshair"   = "$Win\Cursors\cross.cur"
  "IBeam"       = "$Win\Cursors\beam_r.cur"
  "NWPen"       = "$Win\Cursors\pen_r.cur"
  "No"          = "$Win\Cursors\no.cur"
  "SizeNS"      = "$Win\Cursors\size_ns.cur"
  "SizeWE"      = "$Win\Cursors\size_we.cur"
  "SizeNWSE"    = "$Win\Cursors\size_nwse.cur"
  "SizeNESW"    = "$Win\Cursors\size_nesw.cur"
  "SizeAll"     = "$Win\Cursors\size_all.cur"
  "UpArrow"     = "$Win\Cursors\up_arrow.cur"
  "Hand"        = "$Win\Cursors\aero_link.cur"
}

# Write default paths
foreach ($kv in $DefaultCursors.GetEnumerator()) {
  Set-ItemProperty -Path $RegPath -Name $kv.Key -Value $kv.Value -Force
}

# Optional: enable cursor shadow (1 = on, 0 = off)
Set-ItemProperty -Path $RegPath -Name "CursorShadow" -Value 1 -Force

# Clear scheme name hints
Remove-ItemProperty -Path $RegPath -Name "Scheme Source" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $RegPath -Name "(Default)" -ErrorAction SilentlyContinue

# Force reload of cursor scheme now
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class User32 {
  [DllImport("user32.dll", EntryPoint="SystemParametersInfo", SetLastError=true)]
  public static extern bool SystemParametersInfo(uint action, uint param, string vparam, uint winIni);
}
"@

# SPI_SETCURSORS = 0x0057, SPIF_SENDCHANGE = 0x02
[User32]::SystemParametersInfo(0x0057, 0, "", 0x02) | Out-Null

Write-Host "✅ Mouse pointers reset to Windows defaults and applied."
