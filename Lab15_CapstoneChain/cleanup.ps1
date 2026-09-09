<#
Lab 15 cleanup - combines Lab 09's and Lab 13's cleanup, since this
payload is those two techniques chained together. Run on the victim VM.
If "hard mode" (Lab 14) was also run, its effects (cleared logs) cannot
be undone by any script - revert the VM snapshot in that case.
#>

Write-Host "Removing HKCU Run key entry..." -ForegroundColor Yellow
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'WindowsSecurityHealth' -ErrorAction SilentlyContinue

Write-Host "Removing scheduled task..." -ForegroundColor Yellow
Unregister-ScheduledTask -TaskName 'WindowsUpdateCheck' -Confirm:$false -ErrorAction SilentlyContinue

Write-Host "Removing dropped script and the file it wrote..." -ForegroundColor Yellow
Remove-Item -Path "$env:APPDATA\update.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\persistence_ran.txt" -Force -ErrorAction SilentlyContinue

Write-Host "Done. Delete fake_secrets.txt from the Desktop and collected.log on" -ForegroundColor Green
Write-Host "your lab server if you want a fully clean slate for the next run." -ForegroundColor Green
Write-Host ""
Write-Host "If Lab 14 (hard mode) was also run: cleared event logs CANNOT be" -ForegroundColor Red
Write-Host "restored. Revert the VM snapshot for a clean log history." -ForegroundColor Red
