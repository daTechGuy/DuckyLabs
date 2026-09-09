<#
Lab 11 cleanup — run on the victim VM. The staged executable runs
directly from the Ducky's own storage, so nothing is written to the
victim's disk; this just stops it if still running. Physically unplug
the Ducky and revert the VM snapshot for a full reset.
#>

Write-Host "Stopping p.exe if it's still running..." -ForegroundColor Yellow
Get-Process -Name "p" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "Done. Unplug the Ducky and revert the VM snapshot for a full reset." -ForegroundColor Green
