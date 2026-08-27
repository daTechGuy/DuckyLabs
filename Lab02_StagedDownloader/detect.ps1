<#
Lab 02 detection script — run on the victim VM after the payload has
executed. Surfaces artifacts left by payload.txt without assuming prior
knowledge of what it did.
#>

Write-Host "`n== Files created in %TEMP% in the last hour ==" -ForegroundColor Cyan
Get-ChildItem -Path $env:TEMP -File -ErrorAction SilentlyContinue |
    Where-Object { $_.CreationTime -gt (Get-Date).AddHours(-1) } |
    Select-Object Name, CreationTime, Length

Write-Host "`n== Sysmon Event ID 3 (network connection) from powershell.exe, if Sysmon is installed ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 3; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'powershell\.exe' } |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== Sysmon Event ID 11 (file create) under Temp paths, if Sysmon is installed ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 11; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match '\\Temp\\' } |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== Process creation from a Temp path (Sysmon 1 / Security 4688) ==" -ForegroundColor Cyan
$ids = 1
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = $ids; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match '\\Temp\\' } |
    Select-Object TimeCreated, Message | Format-List
Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 4688; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match '\\Temp\\' } |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== PowerShell script block log (event 4104) mentioning WebClient/Download/IEX, if enabled ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-PowerShell/Operational'; Id = 4104; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'WebClient|DownloadFile|DownloadString|IEX|Invoke-Expression' } |
    Select-Object TimeCreated, Message | Format-List
