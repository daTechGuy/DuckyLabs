<#
Lab 07 - Read the Sysmon event this payload generated.

HOW TO USE:
  1. Install Sysmon per the README (needs Administrator, one time).
  2. Run the Lab 07 payload.
  3. Run this script AS ADMINISTRATOR (Sysmon's log needs elevated
     read access). Reads only. Changes nothing.
#>

Write-Host ""
Write-Host "=== 1. Sysmon Event ID 1 (process creation) for notepad.exe ===" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 1; StartTime = (Get-Date).AddMinutes(-10) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'notepad\.exe' } |
    Select-Object TimeCreated, Message |
    Format-List

Write-Host ""
Write-Host "=== 2. The same moment, from the Security log (event 4688), if process-creation auditing is on ===" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 4688; StartTime = (Get-Date).AddMinutes(-10) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'notepad\.exe' } |
    Select-Object TimeCreated, Message |
    Format-List

Write-Host ""
Write-Host "=== 3. Compare: what you had in Lab 05 vs. what you have now ===" -ForegroundColor Cyan
Write-Host "  Lab 05's RunMRU check told you the WORD 'notepad' was typed into Win+R."
Write-Host "  Sysmon Event ID 1 tells you the actual process that ran (Image), its full"
Write-Host "  command line, its PARENT process, and the user account - all from a log"
Write-Host "  a normal user can't edit or clear. That's the difference between a"
Write-Host "  registry breadcrumb and a real audit trail."

Write-Host ""
Write-Host "=== Done. Keep Sysmon installed - every remaining advanced lab through Lab 12 checks its log too. ===" -ForegroundColor Green
