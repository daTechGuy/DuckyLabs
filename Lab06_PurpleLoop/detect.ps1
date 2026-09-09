# ============================================================
# Lab 06 (PURPLE) - Hunt the artifact this payload left behind
#
# Run this AFTER the Lab 06 payload. It looks for:
#   1. New file(s) recently created on the Desktop
#   2. The 'powershell' command in the Run-box history
#   3. How close in time those two events were (the machine tell)
#
# Reads only. Changes nothing. Blue team: try to PREDICT what each
# section will show before you run it.
# ============================================================

Write-Host ""
Write-Host "=== 1. Recently created files on the Desktop ===" -ForegroundColor Cyan
$desktop = "$env:USERPROFILE\Desktop"
$cutoff  = (Get-Date).AddMinutes(-15)   # anything created in the last 15 min
Get-ChildItem -Path $desktop -File -ErrorAction SilentlyContinue |
    Where-Object { $_.CreationTime -gt $cutoff } |
    Sort-Object CreationTime -Descending |
    Select-Object Name, CreationTime, Length |
    Format-Table -AutoSize
Write-Host "  (If YOU_WERE_HERE.txt shows up here, the blue team found the artifact.)"

Write-Host ""
Write-Host "=== 2. Was PowerShell launched from the Run box? ===" -ForegroundColor Cyan
$runMru = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
if (Test-Path $runMru) {
    $entries = Get-ItemProperty -Path $runMru
    $hits = $entries.PSObject.Properties |
        Where-Object { $_.Name -match '^[a-z]$' -and $_.Value -match 'powershell' }
    if ($hits) {
        $hits | ForEach-Object { "  found in Run history:  " + ($_.Value -replace '\1$','') }
    } else {
        Write-Host "  (no 'powershell' entry in Run history)"
    }
}

Write-Host ""
Write-Host "=== 3. The timing tell ===" -ForegroundColor Cyan
Write-Host "  Compare the file's CreationTime above with when the payload ran."
Write-Host "  A real person types a PowerShell command and creates a file MINUTES"
Write-Host "  apart. A Ducky does both in the same second. That gap - or lack of"
Write-Host "  one - is a detection rule waiting to be written."

Write-Host ""
Write-Host "=== Done. Purple debrief: compare predictions vs. findings. ===" -ForegroundColor Green
