<#
.SYNOPSIS
    One-click setup script for the complete Portable AI Coding Workspace on USB.
    Run this as Administrator on a freshly formatted USB drive.
    It creates the full folder structure, copies the guide, workflow, and generates all helper scripts.
#>

[CmdletBinding()]
param(
    [string]$UsbDriveLetter = "E"   # Change if your USB is not E:
)

$ErrorActionPreference = "Stop"

$usbRoot = "${UsbDriveLetter}:\"
Write-Host "Setting up Portable AI Coding Workspace on $usbRoot ..." -ForegroundColor Cyan

# Create full folder structure
$folders = @(
    "VMs\Linux-Coding",
    "VMs\macOS-Coding",
    "Workspace\Projects",
    "Workspace\Outputs",
    "Workspace\Agent-Logs",
    "Scripts",
    "repo-template\.github\workflows",
    "Docs"
)

foreach ($folder in $folders) {
    $path = Join-Path $usbRoot $folder
    New-Item -ItemType Directory -Force -Path $path | Out-Null
    Write-Host "Created: $path" -ForegroundColor Green
}

# Copy main guide
$guideSource = "USB-Coding-Workspace-Setup.md"
if (Test-Path $guideSource) {
    Copy-Item $guideSource -Destination (Join-Path $usbRoot "USB-Coding-Workspace-Setup.md") -Force
    Write-Host "Copied main guide" -ForegroundColor Green
} else {
    Write-Warning "Main guide not found in current directory. Please copy it manually."
}

# Copy GitHub workflow into repo-template
$workflowSource = ".github\workflows\validate-usb-workspace.yml"
if (Test-Path $workflowSource) {
    Copy-Item $workflowSource -Destination (Join-Path $usbRoot "repo-template\.github\workflows\validate-usb-workspace.yml") -Force
    Write-Host "Copied GitHub Actions workflow" -ForegroundColor Green
}

# Create the actual helper scripts inside Scripts\
$scripts = @{
    "Start-LinuxVM.ps1" = @'
$usb = "${UsbDriveLetter}:\VMs\Linux-Coding"
$shared = "${UsbDriveLetter}:\Workspace"

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
'@

    "Stop-LinuxVM.ps1" = @'
$pidfile = "${UsbDriveLetter}:\VMs\Linux-Coding\qemu.pid"
if (Test-Path $pidfile) {
    $pid = Get-Content $pidfile
    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    Remove-Item $pidfile -Force
    Write-Host "Linux VM stopped." -ForegroundColor Yellow
} else {
    Write-Host "No running Linux VM found." -ForegroundColor Yellow
}
'@

    "Start-macOSVM.ps1" = @'
$usb = "${UsbDriveLetter}:\VMs\macOS-Coding"
$shared = "${UsbDriveLetter}:\Workspace"

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
'@

    "Stop-macOSVM.ps1" = @'
$pidfile = "${UsbDriveLetter}:\VMs\macOS-Coding\qemu.pid"
if (Test-Path $pidfile) {
    $pid = Get-Content $pidfile
    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    Remove-Item $pidfile -Force
    Write-Host "macOS VM stopped." -ForegroundColor Yellow
} else {
    Write-Host "No running macOS VM found." -ForegroundColor Yellow
}
'@

    "Launch-Coding-Session.ps1" = @'
Write-Host "Starting Linux Coding Session..." -ForegroundColor Cyan
& "${UsbDriveLetter}:\Scripts\Start-LinuxVM.ps1"
Start-Sleep -Seconds 15
Write-Host "Session ready. Agents can now SSH on port 2222" -ForegroundColor Green
'@
}

foreach ($name in $scripts.Keys) {
    $content = $scripts[$name] -replace '\$\{UsbDriveLetter\}', $UsbDriveLetter
    $path = Join-Path $usbRoot "Scripts\$name"
    Set-Content -Path $path -Value $content -Encoding UTF8
    Write-Host "Created script: $name" -ForegroundColor Green
}

Write-Host "`n✅ USB Coding Workspace setup complete!" -ForegroundColor Cyan
Write-Host "Next steps for your AI agents:"
Write-Host "1. Create the Linux VM disk image (see USB-Coding-Workspace-Setup.md)"
Write-Host "2. Run Scripts\Launch-Coding-Session.ps1 when ready"
Write-Host "3. For GitHub sharing: copy the repo-template folder into a new repo" -ForegroundColor Yellow
