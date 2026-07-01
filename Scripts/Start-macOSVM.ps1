$usb = "F:\VMs\macOS-Coding"
$shared = "F:\Workspace"

qemu-system-x86_64 `
    -name "macOS-Coding-Headless" `
    -m 8192 `
    -smp 8 `
    -enable-kvm `
    -cpu Penryn,vendor=GenuineIntel `
    -machine q35,accel=kvm `
    -drive file="$usb\macos-coding.qcow2",format=qcow2,media=disk `
    -net nic -net user,hostfwd=tcp::2223-:22,smb="$shared" `
    -daemonize `
    -pidfile "$usb\qemu.pid" `
    -nographic

Write-Host "macOS VM started headless. SSH with: ssh user@localhost -p 2223" -ForegroundColor Green
