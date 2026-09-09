<#
Lab 08 best-effort cleanup — run on the victim VM (as Administrator).

Prefer reverting a VM snapshot instead. This script does NOT undo the
`icacls c:* /grant ts:(OI)(CI)F` step: stripping a recursive ACE back out
of every top-level item on C:\ correctly is error-prone and risks leaving
the filesystem in a worse state than a stale ACE referencing a deleted
SID (which Windows tolerates fine). Only use this for a quick same-session
re-run where the residual ACE doesn't matter.
#>

Write-Host "Removing SMB share 'ts'..." -ForegroundColor Yellow
Remove-SmbShare -Name "ts" -Force -ErrorAction SilentlyContinue

Write-Host "Removing local user 'ts'..." -ForegroundColor Yellow
Remove-LocalUser -Name "ts" -ErrorAction SilentlyContinue

Write-Host "Re-disabling File and Printer Sharing firewall rule group..." -ForegroundColor Yellow
Set-NetFirewallRule -DisplayGroup "File and Printer Sharing" -Enabled False -ErrorAction SilentlyContinue

Write-Host "Done. NOTE: icacls grants on C:\ top-level items were left in place — revert the VM snapshot for a full reset." -ForegroundColor Red
