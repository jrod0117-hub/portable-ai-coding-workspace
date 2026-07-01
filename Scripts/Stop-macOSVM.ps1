$pidfile = "F:\VMs\macOS-Coding\qemu.pid"
if (Test-Path $pidfile) {
    $pid = Get-Content $pidfile
    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    Remove-Item $pidfile -Force
    Write-Host "macOS VM stopped." -ForegroundColor Yellow
} else {
    Write-Host "No running macOS VM found." -ForegroundColor Yellow
}
