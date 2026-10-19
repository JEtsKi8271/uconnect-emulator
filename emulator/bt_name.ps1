# Set the name this PC's Bluetooth radio(s) broadcast (default: the computer name), then restart the radio.
#   powershell -ExecutionPolicy Bypass -File bt_name.ps1 -Name Uconnect      (as administrator)
#   powershell -ExecutionPolicy Bypass -File bt_name.ps1 -Undo               (back to the computer name)
param([string]$Name = 'Uconnect', [switch]$Undo)
$log = Join-Path $env:TEMP 'bt_name.log'
Start-Transcript -Path $log -Force | Out-Null
$radios = Get-PnpDevice -Class Bluetooth -PresentOnly | Where-Object { $_.InstanceId -like 'USB\*' }
foreach ($r in $radios) {
    $key = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($r.InstanceId)\Device Parameters"
    if ($Undo) {
        Remove-ItemProperty -Path $key -Name 'Local Name' -ErrorAction SilentlyContinue
    } else {
        # REG_BINARY UTF-8 name, as BthPort reads it
        $bytes = [Text.Encoding]::UTF8.GetBytes($Name.Substring(0, [Math]::Min(31, $Name.Length)))
        New-ItemProperty -Path $key -Name 'Local Name' -PropertyType Binary -Value $bytes -Force | Out-Null
    }
    $r | Disable-PnpDevice -Confirm:$false
    Start-Sleep -Seconds 3
    $r | Enable-PnpDevice -Confirm:$false
    "$($r.FriendlyName): name set"
}
Stop-Transcript | Out-Null
