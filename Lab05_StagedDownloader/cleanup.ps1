<#
Lab 05 cleanup — run on the victim VM. Unlike Lab 04, this payload's
effects are fully reversible: kill the dropped process if still running
and delete the dropped file from %TEMP%.
#>

Write-Host "Stopping calc.exe if it's running from %TEMP%..." -ForegroundColor Yellow
Get-Process -Name "calc" -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -like "$env:TEMP\*" } |
    Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "Removing dropped file..." -ForegroundColor Yellow
Remove-Item -Path "$env:TEMP\calc.exe" -Force -ErrorAction SilentlyContinue

Write-Host "Done." -ForegroundColor Green
