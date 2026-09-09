<#
Lab 11 cleanup - remove the Device Installation Restriction policy set by
harden.ps1, restoring normal USB device installation. Run as Administrator.
#>

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"

if (Test-Path $regPath) {
    Remove-ItemProperty -Path $regPath -Name "DenyDeviceClasses" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $regPath -Name "DenyDeviceClassesRetroactive" -ErrorAction SilentlyContinue
    Write-Host "Removed the HID device installation restriction." -ForegroundColor Green
} else {
    Write-Host "Nothing to clean up - no policy was set." -ForegroundColor Yellow
}

Write-Host "A VM snapshot revert is still the cleanest full reset." -ForegroundColor Yellow
