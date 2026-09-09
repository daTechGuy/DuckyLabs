<#
Lab 11 - Verify the policy is active and look for the resulting driver
installation failure in the System event log. Reads only, changes nothing.
Run as Administrator (needed to read some event log entries reliably).
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"

Write-Host ""
Write-Host "=== 1. Current Device Installation Restriction policy ===" -ForegroundColor Cyan
if (Test-Path $regPath) {
    Get-ItemProperty -Path $regPath | Select-Object DenyDeviceClasses, DenyDeviceClassesRetroactive
} else {
    Write-Host "  (no policy set - run harden.ps1 first)"
}

Write-Host ""
Write-Host "=== 2. Recent driver installation failures (Kernel-PnP, System log) ===" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'System'; ProviderName = 'Microsoft-Windows-Kernel-PnP'; StartTime = (Get-Date).AddMinutes(-15) } -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Id, Message |
    Format-List
Write-Host "  (Event IDs for driver install failures vary by Windows build - look for"
Write-Host "  anything mentioning a device failing to start or install in this window.)"

Write-Host ""
Write-Host "=== 3. Sanity check: your existing keyboard still works ===" -ForegroundColor Cyan
Write-Host "  If you're reading this output, it did - DenyDeviceClassesRetroactive=0"
Write-Host "  means already-installed devices were never touched."

Write-Host ""
Write-Host "=== Done. ===" -ForegroundColor Green
