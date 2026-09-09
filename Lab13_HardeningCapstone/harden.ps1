<#
Lab 13 - Apply a Device Installation Restriction policy that blocks NEW
HID-class devices (keyboards, including a Rubber Ducky) from ever
installing their driver on this machine.

SAFETY - READ BEFORE RUNNING:
  DenyDeviceClassesRetroactive is set to 0 (disabled) on purpose. This
  means the policy only blocks devices that have NEVER been installed on
  this machine before. Your VM's existing virtual keyboard/mouse are
  already installed and are NOT affected - you will not lock yourself out.
  Only a "new" device (like a Ducky enumerating for the first time) gets
  blocked.

  Run this ONLY on your disposable advanced-track VM. Revert the VM
  snapshot afterward, or run cleanup.ps1 to remove the policy.

  Must run as Administrator.
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
$hidClassGuid = "{745a17a0-74d3-11d0-b6fe-00a0c90f57da}"   # Human Interface Device class

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

Write-Host "Denying installation of new devices in the HID class..." -ForegroundColor Yellow
New-ItemProperty -Path $regPath -Name "DenyDeviceClasses" -PropertyType MultiString -Value @($hidClassGuid) -Force | Out-Null

Write-Host "Setting DenyDeviceClassesRetroactive = 0 (do NOT touch already-installed devices)..." -ForegroundColor Yellow
New-ItemProperty -Path $regPath -Name "DenyDeviceClassesRetroactive" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host ""
Write-Host "Policy applied. Your existing keyboard/mouse are unaffected." -ForegroundColor Green
Write-Host "Unplug and replug your Ducky now - Windows should refuse to install its" -ForegroundColor Green
Write-Host "HID interface. Check Device Manager for an unrecognized/failed device," -ForegroundColor Green
Write-Host "then run check.ps1 to look for the corresponding log entry." -ForegroundColor Green
