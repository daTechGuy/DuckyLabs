# ============================================================
# Lab 02 (BLUE) - Find the traces of a keyboard-injection attack
#
# Beginner detection. No Sysmon, no deep event-log archaeology -
# just the breadcrumbs a Rubber Ducky leaves that YOU can read.
#
# HOW TO USE:
#   1. Run the Lab 00 and/or Lab 01 payload on this computer first.
#   2. Then run this script (right-click > Run with PowerShell, or
#      paste it into a PowerShell window).
#   3. Read the output and match it against what the payload did.
#
# This script only READS information. It changes nothing.
# ============================================================

Write-Host ""
Write-Host "=== 1. What was typed into the Run box (Win+R history) ===" -ForegroundColor Cyan
# Windows remembers what you type into the Run box, in the registry.
# A Ducky that used 'GUI r' to launch apps shows up right here.
$runMru = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
if (Test-Path $runMru) {
    $entries = Get-ItemProperty -Path $runMru
    $entries.PSObject.Properties |
        Where-Object { $_.Name -match '^[a-z]$' } |   # entries are named a, b, c...
        ForEach-Object { "  typed:  " + ($_.Value -replace '\1$','') }
} else {
    Write-Host "  (no Run-box history found on this account)"
}

Write-Host ""
Write-Host "=== 2. Recently opened / created files (Recent folder) ===" -ForegroundColor Cyan
# Windows tracks recently touched files here. Notepad and friends leave marks.
$recent = "$env:APPDATA\Microsoft\Windows\Recent"
Get-ChildItem -Path $recent -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 15 Name, LastWriteTime |
    Format-Table -AutoSize

Write-Host ""
Write-Host "=== 3. The 'impossibly fast' tell ===" -ForegroundColor Cyan
# A human opens apps seconds or minutes apart. A Ducky opens several in the
# SAME second. Look at the timestamps above: if two or more things happened
# within the same 1-2 seconds, that is a strong sign a machine did the typing.
Write-Host "  Look at the timestamps above. Did several things happen in the"
Write-Host "  same 1-2 seconds? Humans don't type that fast. Machines do."

Write-Host ""
Write-Host "=== Done. Now compare this to what the payload actually did. ===" -ForegroundColor Green
