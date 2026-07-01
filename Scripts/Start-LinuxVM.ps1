$usb = "F:\VMs\Linux-Coding"
$shared = "F:\Workspace"

qemu-system-x86_64 `
    -name "Linux-Coding-Headless" `
    -m 8192 `
    -smp 8 `
    -enable-kvm `
    -cpu host `
    -drive file="$usb\linux-coding.qcow2",format=qcow2,if=virtio `
    -net nic,model=virtio -net user,hostfwd=tcp::2222-:22,smb="$shared" `
    -daemonize `
    -pidfile "$usb\qemu.pid" `
    -nographic `
    -serial none -parallel none

Write-Host "Linux VM started headless. SSH with: ssh user@localhost -p 2222" -ForegroundColor Green
