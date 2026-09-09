<#
Lab 09 cleanup - run on the victim VM. Removes the Run key, the scheduled
task, the dropped script, and the file it wrote. Fully reversible.
#>

Write-Host "Removing HKCU Run key entry..." -ForegroundColor Yellow
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'WindowsSecurityHealth' -ErrorAction SilentlyContinue

Write-Host "Removing scheduled task..." -ForegroundColor Yellow
Unregister-ScheduledTask -TaskName 'WindowsUpdateCheck' -Confirm:$false -ErrorAction SilentlyContinue

Write-Host "Removing dropped script..." -ForegroundColor Yellow
Remove-Item -Path "$env:APPDATA\update.ps1" -Force -ErrorAction SilentlyContinue

Write-Host "Removing the file the script wrote, if it ran..." -ForegroundColor Yellow
Remove-Item -Path "$env:TEMP\persistence_ran.txt" -Force -ErrorAction SilentlyContinue

Write-Host "Done." -ForegroundColor Green
