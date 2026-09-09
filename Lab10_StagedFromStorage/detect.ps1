<#
Lab 10 detection script — run on the victim VM after the payload has
executed. Surfaces artifacts left by payload.txt without assuming prior
knowledge of what it did.
#>

Write-Host "`n== Currently mounted volumes labeled DUCKY ==" -ForegroundColor Cyan
Get-Volume | Where-Object { $_.FileSystemLabel -eq 'DUCKY' } |
    Select-Object DriveLetter, FileSystemLabel, DriveType, SizeRemaining

Write-Host "`n== Recently attached removable/USB disks ==" -ForegroundColor Cyan
Get-CimInstance -ClassName Win32_DiskDrive -ErrorAction SilentlyContinue |
    Where-Object { $_.InterfaceType -eq 'USB' } |
    Select-Object Model, DeviceID, SerialNumber

Write-Host "`n== Security event 6416: new external device recognized (last hour) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 6416; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== Process creation from a non-C: drive (Sysmon Event ID 1 / Security 4688) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 1; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'Image:\s*[D-Zd-z]:\\' } |
    Select-Object TimeCreated, Message | Format-List
Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 4688; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match '[D-Zd-z]:\\p\.exe' } |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== PowerShell script block log (event 4104) referencing Get-Volume/FileSystemLabel, if enabled ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-PowerShell/Operational'; Id = 4104; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'Get-Volume|FileSystemLabel' } |
    Select-Object TimeCreated, Message | Format-List
