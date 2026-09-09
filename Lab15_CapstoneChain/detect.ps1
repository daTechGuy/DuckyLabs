<#
Lab 15 - Full investigation script for blue team.

This is every technique from Labs 05, 07, 09, and 13 combined into one
triage pass, sorted so you can build a timeline instead of jumping between
scripts. Run AS ADMINISTRATOR (needed for the Security and Sysmon logs).
Reads only, changes nothing.

Fill in incident_report_template.md as you go through this output.
#>

Write-Host "`n=========================================================="
Write-Host " STAGE 1 CANDIDATES - how did it get in?"
Write-Host "=========================================================="

Write-Host "`n== Run-box history (Lab 05) ==" -ForegroundColor Cyan
$runMru = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
if (Test-Path $runMru) {
    (Get-ItemProperty -Path $runMru).PSObject.Properties |
        Where-Object { $_.Name -match '^[a-z]$' } |
        ForEach-Object { "  typed:  " + ($_.Value -replace '\1$','') }
}

Write-Host "`n== Sysmon Event ID 1: process creation in the last hour (Lab 07) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 1; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n=========================================================="
Write-Host " STAGE 2 CANDIDATES - how is it staying?"
Write-Host "=========================================================="

Write-Host "`n== HKCU Run key (Lab 09) ==" -ForegroundColor Cyan
Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -ErrorAction SilentlyContinue |
    Select-Object -Property * -ExcludeProperty PS* | Format-List

Write-Host "`n== Scheduled tasks created in the last hour (Lab 09) ==" -ForegroundColor Cyan
Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object { $_.Date -gt (Get-Date).AddHours(-1) -or $_.TaskName -eq 'WindowsUpdateCheck' } |
    Select-Object TaskName, State, Date

Write-Host "`n== Local admin accounts created in the last hour (Lab 08) ==" -ForegroundColor Cyan
Get-LocalUser | Where-Object { $_.PasswordLastSet -gt (Get-Date).AddHours(-1) } |
    Select-Object Name, Enabled, PasswordLastSet

Write-Host "`n=========================================================="
Write-Host " STAGE 3 CANDIDATES - what did it take?"
Write-Host "=========================================================="

Write-Host "`n== Sysmon Event ID 3: network connections from powershell.exe (Lab 13) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 3; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'powershell\.exe' } |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n=========================================================="
Write-Host " STAGE 4 CANDIDATES - did it try to cover its tracks?"
Write-Host "=========================================================="

Write-Host "`n== Security event 1102: audit log cleared (Lab 14) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 1102; StartTime = (Get-Date).AddHours(-2) } -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== System event 104: other logs cleared (Lab 14) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'System'; Id = 104; StartTime = (Get-Date).AddHours(-2) } -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n=========================================================="
Write-Host " DONE. Build a timeline from the timestamps above, then fill"
Write-Host " in incident_report_template.md."
Write-Host "=========================================================="
