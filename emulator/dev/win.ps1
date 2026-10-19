# win.ps1 -procId N snap out.png | click x y [holdMs] : act on one adl window by process id.
param([int]$procId, [string]$cmd, [string]$a1, [string]$a2, [int]$hold = 80)
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System; using System.Runtime.InteropServices;
public class W { [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
[DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr dc, uint f);
[DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
[DllImport("user32.dll")] public static extern IntPtr ChildWindowFromPointEx(IntPtr h, POINT p, uint f);
[DllImport("user32.dll")] public static extern int MapWindowPoints(IntPtr from, IntPtr to, ref POINT p, uint n);
public struct RECT { public int L, T, R, B; } public struct POINT { public int X, Y; } }
"@
$h = (Get-Process -Id $procId -ErrorAction Stop).MainWindowHandle
if ($h -eq 0) { throw "process $procId has no window yet" }
if ($cmd -eq "snap") {
  $r = New-Object W+RECT; [W]::GetWindowRect($h, [ref]$r) | Out-Null
  $bmp = New-Object System.Drawing.Bitmap ($r.R - $r.L), ($r.B - $r.T)
  $g = [System.Drawing.Graphics]::FromImage($bmp); $dc = $g.GetHdc()
  [W]::PrintWindow($h, $dc, 2) | Out-Null; $g.ReleaseHdc($dc); $bmp.Save($a1); "saved $a1"
} elseif ($cmd -eq "click") {
  # Client coordinates (screenshot y minus the ~30px title bar), sent to the deepest visible child window
  # there (e.g. the Performance Pages layer), like a real mouse click.
  $p = New-Object W+POINT; $p.X = [int]$a1; $p.Y = [int]$a2
  while ($true) {
    $c = [W]::ChildWindowFromPointEx($h, $p, 1)
    if ($c -eq [IntPtr]::Zero -or $c -eq $h) { break }
    [W]::MapWindowPoints($h, $c, [ref]$p, 1) | Out-Null; $h = $c
  }
  $l = [IntPtr](($p.Y -shl 16) -bor $p.X)
  [W]::PostMessage($h, 0x200, [IntPtr]0, $l) | Out-Null
  [W]::PostMessage($h, 0x201, [IntPtr]1, $l) | Out-Null
  Start-Sleep -Milliseconds $hold
  [W]::PostMessage($h, 0x202, [IntPtr]0, $l) | Out-Null
} else { throw "unknown command $cmd" }
