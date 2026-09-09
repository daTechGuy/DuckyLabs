<#
Lab 14 detection script - looks for evidence that this VM's event logs
were recently cleared. Reads only, changes nothing (it can't restore
anything either - that's the point of this lab).
#>

Write-Host "`n== Security log: was it cleared? (event 1102) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 1102; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Message | Format-List
Write-Host "  Event 1102 = 'The audit log was cleared.' Windows writes this"
Write-Host "  automatically the instant the Security log is cleared - it CANNOT be"
Write-Host "  included in that same clear, because it doesn't exist until after."

Write-Host "`n== System log: were other logs cleared? (event 104) ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'System'; Id = 104; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Message | Format-List
Write-Host "  Event 104 = '<LogName> log file was cleared.' This is what clearing"
Write-Host "  Sysmon or PowerShell-Operational leaves behind - in the SYSTEM log,"
Write-Host "  which this payload did NOT clear."

Write-Host "`n== How many events are actually in the Security log right now? ==" -ForegroundColor Cyan
$count = (Get-WinEvent -LogName Security -ErrorAction SilentlyContinue | Measure-Object).Count
Write-Host "  Current event count: $count"
Write-Host "  A freshly-cleared log on an active machine looks suspiciously short for"
Write-Host "  how long the machine has been running - compare this count to uptime."

Write-Host "`n== The honest limit of this detection ==" -ForegroundColor Cyan
Write-Host "  This payload cleared Security, Sysmon, and PowerShell-Operational, in"
Write-Host "  that order - the LAST log cleared (PowerShell-Operational) has no"
Write-Host "  witness, because System was never touched but also never asked to log"
Write-Host "  that specific clear. Every clear leaves ONE trace: a clear-notification"
Write-Host "  written to whichever log recorded that specific channel's reset. If an"
Write-Host "  attacker clears System LAST, even the 104 events above disappear. The"
Write-Host "  only real fix is forwarding logs off this machine before an attacker"
Write-Host "  can reach them - a purely local log can always eventually be made to"
Write-Host "  lie about its own history."
