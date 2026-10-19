# Make this PC's Bluetooth radio announce itself as car audio (so iPhones list it), then restart the radio.
# Undo: remove the two values and restart the radio (or run with -Undo).
param([switch]$Undo)
$log = Join-Path $PSScriptRoot 'bt_car_audio.log'
Start-Transcript -Path $log -Force | Out-Null
$key = 'HKLM:\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters'
if ($Undo) {
    Remove-ItemProperty -Path $key -Name 'COD Major', 'COD Type' -ErrorAction SilentlyContinue
} else {
    New-ItemProperty -Path $key -Name 'COD Major' -PropertyType DWord -Value 4 -Force | Out-Null   # Audio/Video
    New-ItemProperty -Path $key -Name 'COD Type' -PropertyType DWord -Value 8 -Force | Out-Null    # Car audio
}
Get-ItemProperty -Path $key -Name 'COD Major', 'COD Type' -ErrorAction SilentlyContinue | Format-List 'COD Major', 'COD Type'
# the Bluetooth radio(s): restart so the new class is broadcast
$radio = Get-PnpDevice -Class Bluetooth -PresentOnly | Where-Object { $_.InstanceId -like 'USB\*' }
$radio | Disable-PnpDevice -Confirm:$false
Start-Sleep -Seconds 3
$radio | Enable-PnpDevice -Confirm:$false
Start-Sleep -Seconds 3
$radio | ForEach-Object { Get-PnpDevice -InstanceId $_.InstanceId } | Format-List Status, FriendlyName
Stop-Transcript | Out-Null
