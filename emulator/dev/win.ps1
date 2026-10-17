# win.ps1 -procId N snap out.png | click x y [holdMs] : act on one adl window by process id.
param([int]$procId, [string]$cmd, [string]$a1, [string]$a2, [int]$hold = 80)
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System; using System.Runtime.InteropServices;
public class W { [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
[DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr dc, uint f);
[DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
public struct RECT { public int L, T, R, B; } }
"@
$h = (Get-Process -Id $procId -ErrorAction Stop).MainWindowHandle
if ($h -eq 0) { throw "process $procId has no window yet" }
if ($cmd -eq "snap") {
  $r = New-Object W+RECT; [W]::GetWindowRect($h, [ref]$r) | Out-Null
  $bmp = New-Object System.Drawing.Bitmap ($r.R - $r.L), ($r.B - $r.T)
  $g = [System.Drawing.Graphics]::FromImage($bmp); $dc = $g.GetHdc()
  [W]::PrintWindow($h, $dc, 2) | Out-Null; $g.ReleaseHdc($dc); $bmp.Save($a1); "saved $a1"
} elseif ($cmd -eq "click") {
  # Client coordinates (screenshot y minus the ~30px title bar).
  $l = [IntPtr](([int]$a2 -shl 16) -bor [int]$a1)
  [W]::PostMessage($h, 0x200, [IntPtr]0, $l) | Out-Null
  [W]::PostMessage($h, 0x201, [IntPtr]1, $l) | Out-Null
  Start-Sleep -Milliseconds $hold
  [W]::PostMessage($h, 0x202, [IntPtr]0, $l) | Out-Null
} else { throw "unknown command $cmd" }
