# USB Portable Dual-OS Coding Workspace for Local AI Agents
**Linux + Optional macOS VMs on a Thumb Drive**  
**Headless Operation | No PC Reboot Required | Fully Portable**

**Purpose**: Your Windows PC stays running Windows. The USB drive holds complete Linux and macOS virtual machine disk images. Your local AI agents (OpenClaw, etc.) launch these VMs **headless**, perform all coding work inside clean Linux/macOS environments, and save every result back to the USB. Unplug the USB and the entire coding workspace travels with you. Plug it into any Windows machine and continue.

**Recommended Flow**: Linux VM first (fast & reliable). Add macOS VM later if needed for specific tasks.

---

## Prerequisites

- **USB Drive**: 128GB+ fast USB 3.2 Gen 2 or better (or USB-C external SSD in enclosure for best VM performance). Format as exFAT or NTFS for Windows compatibility.
- **Windows PC**: Virtualization enabled in BIOS/UEFI (Intel VT-x or AMD-V). Disable Hyper-V if using VirtualBox/QEMU.
- **Host Tools** (install on Windows):
  - QEMU (recommended for headless + macOS) or VirtualBox (easier GUI).
  - PowerShell 7+ (for agent scripts).
  - Optional: Git, 7-Zip.
- **For macOS VM only**: Basic familiarity with QEMU scripts or gibMacOS / OC4VM tools.
- Your local AI agents must be able to run PowerShell commands and SSH.

**Performance Tip**: USB 3.x+ or external SSD = acceptable VM speed. Slow USB = painful for large compiles.

---

## Step 1: Prepare the USB Drive Structure

Create this folder structure on the USB (example drive letter `E:\`):

```
E:\
├── VMs\
│   ├── Linux-Coding\
│   │   └── linux-coding.qcow2          (or .vdi)
│   └── macOS-Coding\
│       └── macos-coding.qcow2
├── Workspace\                          (shared folder visible in Windows + VMs)
│   ├── Projects\
│   ├── Outputs\
│   └── Agent-Logs\
├── Scripts\
│   ├── Start-LinuxVM.ps1
│   ├── Stop-LinuxVM.ps1
│   ├── Start-macOSVM.ps1
│   └── SSH-Into-Linux.ps1
└── README.md                           (this file or copy)
```

Create the folders manually in Windows Explorer.

---

## Step 2: Install Host Virtualization Tools on Windows

### Option A: QEMU (Recommended for Headless + macOS)
1. Download QEMU for Windows from https://qemu.weilnetz.de/w64/
2. Install it. Add `C:\Program Files\qemu\` to your PATH.
3. Test: Open PowerShell and run `qemu-system-x86_64 --version`

### Option B: VirtualBox (Easier GUI for first setup)
1. Download VirtualBox + Extension Pack from virtualbox.org
2. Install both.
3. Optional but useful: Enable command-line tools.

**Recommendation for agents**: Use QEMU for pure headless scripting. Use VirtualBox if you want occasional GUI inspection.

---

## Step 3: Create Linux VM (Primary — Do This First)

### Using QEMU (Headless-Friendly)
1. Open PowerShell **as Administrator**.
2. Create the VM disk on the USB:
   ```powershell
   $usb = "E:\VMs\Linux-Coding"   # Change to your USB path
   New-Item -ItemType Directory -Force -Path $usb
   qemu-img create -f qcow2 "$usb\linux-coding.qcow2" 60G
   ```
3. Download Ubuntu Server ISO (or Debian minimal) to a temp folder.
4. First boot / install (one-time, can use GUI):
   ```powershell
   qemu-system-x86_64 `
     -m 4096 `
     -smp 4 `
     -enable-kvm `
     -cpu host `
     -drive file="$usb\linux-coding.qcow2",format=qcow2 `
     -cdrom "C:\path\to\ubuntu-24.04-live-server-amd64.iso" `
     -boot d `
     -net nic -net user,hostfwd=tcp::2222-:22 `
     -vga std
   ```
   - Install Ubuntu Server.
   - During install: Enable OpenSSH server.
   - Set a strong password or set up SSH keys.
   - After install, shut down.

5. **Headless daily launch script** (`E:\Scripts\Start-LinuxVM.ps1`):
   ```powershell
   $usb = "E:\VMs\Linux-Coding"
   $shared = "E:\Workspace"

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

   Write-Host "Linux VM started headless. SSH: ssh user@localhost -p 2222"
   Write-Host "Shared folder mounted inside VM at /mnt/host or similar (configure Samba or 9p)."
   ```

6. **Stop script** (`Stop-LinuxVM.ps1`):
   ```powershell
   $pidfile = "E:\VMs\Linux-Coding\qemu.pid"
   if (Test-Path $pidfile) {
       $pid = Get-Content $pidfile
       Stop-Process -Id $pid -Force
       Remove-Item $pidfile
       Write-Host "Linux VM stopped."
   }
   ```

7. Inside Linux VM (one-time setup):
   - `sudo apt update && sudo apt install -y openssh-server git docker.io build-essential`
   - Configure SSH key auth from your Windows machine / agents.
   - Mount shared folder (use 9p or Samba). Example in `/etc/fstab` or script.

**Test**: Run Start script → `ssh user@localhost -p 2222` from another PowerShell window. You should get a Linux shell. Code away. Files in `/home/user` persist on the `.qcow2` on USB.

---

## Step 4: Create macOS VM (Optional — Advanced)

Use QEMU + helper scripts (more reliable for headless than VirtualBox hacks).

**Which macOS version should the agents download?**  
**The latest stable version** (currently **macOS Tahoe** as of June 2026).  
This gives your agents the newest dev tools (latest Xcode, Swift, frameworks, etc.). Use gibMacOS or macrecovery.py to fetch the current latest stable build automatically. Avoid betas unless you have a specific reason.

1. Install prerequisites (in WSL or native PowerShell where possible):
   - Python, git.
2. Use tools like:
   - `gibMacOS` (corpnewt/gibMacOS) — easiest way to download the latest recovery or full installer.
   - Or `macrecovery.py` from OpenCorePkg for the latest:
     ```powershell
     python macrecovery.py -b Mac-CFF7D910A743CAAF -m 00000000000000000 -os latest download
     ```
3. Create disk on USB:
   ```powershell
   qemu-img create -f qcow2 "E:\VMs\macOS-Coding\macos-coding.qcow2" 80G
   ```
4. Follow a current 2026 QEMU macOS Tahoe guide (search "QEMU macOS Tahoe Windows" or use OC4VM / macOS-Simple-KVM).
5. Typical launch (headless example after setup):
   ```powershell
   qemu-system-x86_64 `
     -m 8192 -smp 8 -enable-kvm -cpu Penryn,vendor=GenuineIntel `
     -machine q35,accel=kvm `
     -drive file="E:\VMs\macOS-Coding\macos-coding.qcow2",format=qcow2,media=disk `
     -net nic -net user,hostfwd=tcp::2223-:22 `
     -nographic `
     -daemonize `
     -pidfile "E:\VMs\macOS-Coding\qemu.pid"
   ```
6. Create similar `Start-macOSVM.ps1` and `Stop-macOSVM.ps1` scripts.

**Note**: macOS in VM on Windows requires specific CPU patches and may need occasional fixes after updates. Performance is lower than Linux VM. Use only if you need Xcode or macOS-specific tools. Test on your hardware.

---

## Step 5: Shared Workspace Between Windows + VMs

- The `E:\Workspace` folder on USB is visible in Windows.
- Inside VMs: Mount it via Samba (Linux) or Shared Folders (VirtualBox) / 9p (QEMU).
- Agents write all code/projects/outputs to this folder.
- When VM is stopped, Windows sees the new files immediately.

**Simple Samba setup in Linux VM** (one-time):
```bash
sudo apt install samba
# Edit /etc/samba/smb.conf to share /home/user/Workspace or the mounted host folder
sudo smbpasswd -a youruser
sudo systemctl restart smbd
```
Then from Windows: `\\localhost\share` or map drive.

---

## Step 6: Agent-Ready Scripts (Drop These on USB)

Create the `.ps1` files in `E:\Scripts\`.

Example master agent launcher (PowerShell):
```powershell
# Launch-Linux-Coding.ps1
& "E:\Scripts\Start-LinuxVM.ps1"
Start-Sleep -Seconds 10
ssh user@localhost -p 2222 "cd /workspace && ./your-agent-coding-script.sh"
```

Your local AI agents can call these scripts via tool use or subprocess.

---

## Step 7: Full Agent Workflow (What Your AI Agents Should Do)

1. Detect USB is plugged in (or assume path `E:\`).
2. Run `Start-LinuxVM.ps1` (or macOS version).
3. Wait for VM ready (check SSH port or sleep 15-30s).
4. SSH into VM and execute coding tasks (git clone, build, test, generate code with local LLMs, etc.).
5. All output written to `/workspace` (maps to `E:\Workspace`).
6. Run `Stop-*.ps1`.
7. Optional: Agent reads results from `E:\Workspace\Outputs` directly in Windows.
8. Unplug USB when done — entire environment + code travels.

**One-command example for agents**:
```powershell
E:\Scripts\Launch-Coding-Session.ps1
```

---

## Troubleshooting

- **VM won't start headless**: Check KVM enabled, enough RAM/CPU allocated, correct paths.
- **SSH fails**: Firewall in VM, wrong port forward, keys not set.
- **Slow performance**: Use faster USB/SSD or reduce VM RAM/CPU if host is struggling.
- **macOS issues**: CPU compatibility, update OpenCore/QEMU scripts.
- **Shared folder not visible**: Re-mount or use Samba instead of 9p.
- **USB drive letter changes**: Use volume label or PowerShell to detect USB by name.

---

## Making It Available for Everyone (GitHub + Actions)

Your local setup works without GitHub.  
But to make the entire workspace (scripts, .md guide, folder structure) available for your team, other machines, or publicly, put everything in a GitHub repository.

### Quick Setup for Sharing
1. Create a new GitHub repo (e.g. `portable-ai-coding-workspace`).
2. Push this `.md` file + the `Scripts/` folder + the folder structure template.
3. Add the GitHub Actions workflow below (create `.github/workflows/validate-usb-workspace.yml`).

### GitHub Actions Workflow (Validation + CI)
Copy this into `.github/workflows/validate-usb-workspace.yml`:

```yaml
name: Validate USB Coding Workspace

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  validate:
    runs-on: windows-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup PowerShell
        uses: actions/setup-powershell@v1
        with:
          pwsh-version: '7.x'

      - name: Install PSScriptAnalyzer
        run: |
          Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser -AllowClobber
        shell: pwsh

      - name: Lint all PowerShell scripts
        run: |
          Invoke-ScriptAnalyzer -Path ./Scripts -Recurse -Severity @('Error','Warning') -EnableExit
        shell: pwsh

      - name: Lint Markdown files
        uses: DavidAnson/markdownlint-cli2-action@v16
        with:
          globs: |
            **/*.md
            !node_modules/**

      - name: Verify folder structure exists
        run: |
          $required = @(
            "VMs/Linux-Coding",
            "VMs/macOS-Coding",
            "Workspace",
            "Scripts"
          )
          foreach ($folder in $required) {
            if (-not (Test-Path $folder)) {
              Write-Error "Missing required folder: $folder"
              exit 1
            }
          }
          Write-Host "All required folders present."
        shell: pwsh

      - name: Summary
        run: |
          Write-Host "✅ USB Coding Workspace validation passed!"
        shell: pwsh
```

This workflow runs automatically on every push/PR and validates:
- PowerShell script quality
- Markdown formatting
- Required folder structure

Your system already connects to GitHub Actions, so your agents can trigger or monitor these workflows if needed.

### How Agents Use the GitHub Version
1. Clone the repo to the USB: `git clone https://github.com/yourname/portable-ai-coding-workspace.git E:\`
2. Follow the updated `.md` in the repo root.
3. The workflow keeps everything clean and consistent for everyone.

This makes the full dual-OS headless coding workspace instantly available to anyone with the repo link while keeping the local USB experience unchanged.

---

## Final Notes for Your Agents

- Linux VM is production-ready for almost all coding tasks.
- macOS VM is for when you specifically need it.
- Everything important lives on the USB → truly portable.
- Test the full cycle (start → code → stop → files visible in Windows) before giving to production agents.
- Update this .md as you refine scripts.

**Created for your local AI agent infrastructure.**  
Plug USB → Agents code in clean dual-OS envs → Results on USB → Back to Windows.

Copy this entire file to `E:\USB-Coding-Workspace-Setup.md` on your USB for the agents to reference.

---

**Next Actions for You / Agents**:
1. Buy / prepare the fast USB.
2. Run Step 2 (install QEMU).
3. Execute Step 3 Linux setup.
4. Test headless SSH + shared folder.
5. Add macOS only if needed.
6. Integrate the `.ps1` scripts into your agent tool-calling loop.

This gives your agents a clean, isolated, portable Linux (and macOS) coding environment that lives entirely on the thumb drive. 

Ready when you are — drop the next command or ask for refinements to any script.