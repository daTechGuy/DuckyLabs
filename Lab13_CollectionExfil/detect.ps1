<#
Lab 13 detection script - run on the victim VM after the payload has
executed. Surfaces artifacts left by payload.txt without assuming prior
knowledge of what it did. Reads only, changes nothing.
#>

Write-Host "`n== Sysmon Event ID 3 (network connection) from powershell.exe, if Sysmon is installed ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 3; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'powershell\.exe' } |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== PowerShell script block log (event 4104) mentioning Invoke-WebRequest / fake_secrets, if enabled ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-PowerShell/Operational'; Id = 4104; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'Invoke-WebRequest|fake_secrets' } |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== The honest gap: was the FILE READ itself logged anywhere? ==" -ForegroundColor Cyan
Write-Host "  Sysmon logs file CREATE (Event ID 11) and process activity, but not"
Write-Host "  ordinary file READS by default. Get-Content on fake_secrets.txt almost"
Write-Host "  certainly left NOTHING host-side to find. Only the network call above -"
Write-Host "  the exfiltration step, not the collection step - is what you can catch"
Write-Host "  here. Keep that in mind for the discussion questions in the README."

Write-Host "`n== On the lab server: check collected.log ==" -ForegroundColor Cyan
Write-Host "  This script only reads the VICTIM machine. The actual proof the exfil"
Write-Host "  worked lives in collected.log on whatever machine ran lab_collector.py."
