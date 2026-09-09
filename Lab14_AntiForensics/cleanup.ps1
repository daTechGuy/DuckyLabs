<#
Lab 14 cleanup - there is no cleanup for cleared event logs. They cannot
be un-cleared by this or any script; that irreversibility IS the lab.
#>

Write-Host "Cleared event logs cannot be restored by this or any script." -ForegroundColor Red
Write-Host "This payload created no files, accounts, or persistence - a VM snapshot" -ForegroundColor Yellow
Write-Host "revert is the only way to get your logs back for a clean re-run." -ForegroundColor Yellow
