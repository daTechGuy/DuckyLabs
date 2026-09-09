<#
Lab 07 detection script — run on the victim VM (as Administrator) after
the payload has executed. Surfaces artifacts left by payload.txt without
assuming prior knowledge of what it did.
#>

Write-Host "`n== Local users created in the last hour ==" -ForegroundColor Cyan
Get-LocalUser | Where-Object { $_.PasswordLastSet -gt (Get-Date).AddHours(-1) } |
    Select-Object Name, Enabled, PasswordLastSet

Write-Host "`n== Administrators group membership ==" -ForegroundColor Cyan
Get-LocalGroupMember -Group "Administrators" | Select-Object Name, PrincipalSource

Write-Host "`n== Non-default SMB shares ==" -ForegroundColor Cyan
Get-SmbShare | Where-Object { $_.Name -notin @('ADMIN$','C$','IPC$') } |
    Select-Object Name, Path, Description

Write-Host "`n== File and Printer Sharing firewall rule group ==" -ForegroundColor Cyan
Get-NetFirewallRule -DisplayGroup "File and Printer Sharing" |
    Select-Object DisplayName, Enabled, Direction | Where-Object Enabled -eq $true

Write-Host "`n== Security log: account creation / group membership / share events ==" -ForegroundColor Cyan
$ids = 4720, 4732, 4728, 5142
Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = $ids; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Sort-Object TimeCreated |
    Select-Object TimeCreated, Id, Message |
    Format-List

Write-Host "`n== PowerShell script block log (event 4104), if enabled ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-PowerShell/Operational'; Id = 4104; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'saps|net User|net LocalGroup|net share|icacls' } |
    Select-Object TimeCreated, Message | Format-List

Write-Host "`n== Sysmon Event ID 1 (process creation) for powershell/cmd/net/icacls, if Sysmon is installed ==" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; Id = 1; StartTime = (Get-Date).AddHours(-1) } -ErrorAction SilentlyContinue |
    Where-Object { $_.Message -match 'powershell\.exe|net\.exe|icacls\.exe|netsh\.exe' } |
    Select-Object TimeCreated, Message | Format-List
