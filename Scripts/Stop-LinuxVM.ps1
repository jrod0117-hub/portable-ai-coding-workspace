$pidfile = "F:\VMs\Linux-Coding\qemu.pid"
if (Test-Path $pidfile) {
    $pid = Get-Content $pidfile
    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    Remove-Item $pidfile -Force
    Write-Host "Linux VM stopped." -ForegroundColor Yellow
} else {
    Write-Host "No running Linux VM found." -ForegroundColor Yellow
}
