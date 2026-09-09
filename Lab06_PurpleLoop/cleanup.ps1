# ============================================================
# Lab 06 (PURPLE) - Cleanup
# Deletes the YOU_WERE_HERE.txt file this lab drops on the Desktop.
# Safe: it only removes that one lab file if it exists.
# ============================================================
$target = "$env:USERPROFILE\Desktop\YOU_WERE_HERE.txt"
if (Test-Path $target) {
    Remove-Item -Path $target -Force
    Write-Host "Removed $target" -ForegroundColor Green
} else {
    Write-Host "Nothing to clean up - $target not found." -ForegroundColor Yellow
}
