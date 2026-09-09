<#
Lab 09 detection script - run on the victim VM after the payload has
executed. Surfaces artifacts left by payload.txt without assuming prior
knowledge of what it did. Reads only, changes nothing.
#>

Write-Host "`n== HKCU Run key entries ==" -ForegroundColor Cyan
Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -ErrorAction SilentlyContinue |
    Select-Object -Property * -ExcludeProperty PS* | Format-List

Write-Host "`n== Scheduled tasks created recently ==" -ForegroundColor Cyan
Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object { $_.Date -gt (Get-Date).AddHours(-1) -or $_.TaskName -eq 'WindowsUpdateCheck' } |
    Select-Object TaskName, State, Date

Write-Host "`n== Dropped script in %APPDATA% ==" -ForegroundColor Cyan
Get-ChildItem -Path $env:APPDATA -File -ErrorAction SilentlyContinue |
    Where-Object { $_.CreationTime -gt (Get-Date).AddHours(-1) } |
    Select-Object Name, CreationTime, Length

Write-Host "`n== Security log: scheduled task creation (event 4698) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 4698; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== Sysmon Event ID 13 (registry value set) for the Run key, IF your Sysmon config watches registry events ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 13; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'CurrentVersion\\Run' } |
    Select-Object TimeCreated, Message | Format-List
Write-Host "  (If this section is empty but the Run key above IS populated, your Sysmon"
Write-Host "  config - like Lab 07's beginner one - only watches Process Creation."
Write-Host "  Add a <RegistryEvent onmatch=`"exclude`" /> rule and reload with"
Write-Host "  'Sysmon64.exe -c <config>' to see registry changes too.)"

Write-Host "`n== PowerShell script block log (event 4104), if enabled ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-PowerShell/Operational'; Id = 4104; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'CurrentVersion\\Run|schtasks|ONLOGON' } |
    Select-Object TimeCreated, Message | Format-List
