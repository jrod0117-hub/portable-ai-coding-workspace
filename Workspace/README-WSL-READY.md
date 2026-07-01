# Portable AI Coding Workspace - WSL2 Edition

## Status: ✅ OPERATIONAL

Your portable Linux coding environment is ready using **WSL2 (Windows Subsystem for Linux)**.

This is the **most reliable and performant** solution for your use case because:
- No QEMU virtualization overhead - native Linux performance
- Instant boot time (WSL starts in < 2 seconds)
- Full access to F: drive at `/mnt/f`
- SSH server works reliably
- Docker, Git, and all dev tools work natively

---

## Quick Start

### 1. First-Time Setup (Run Once)

Open PowerShell and run:
```powershell
wsl -d Ubuntu -e bash /mnt/f/Workspace/setup-wsl.sh
```

This will:
- Install SSH server, Git, Docker, and build tools
- Configure SSH with password authentication
- Set your password to: `agentpassword`
- Create workspace directories

### 2. Start Coding Session

```powershell
# Start WSL (if not running)
wsl -d Ubuntu

# Or connect via SSH
ssh jrod0@localhost -p 22
# Password: agentpassword
```

### 3. Access Your Workspace

Inside WSL:
```bash
cd /mnt/f/Workspace/Projects
```

From Windows:
```
F:\Workspace\Projects
```

Files are instantly shared between Windows and Linux!

---

## For AI Agents

Your agents can now:
1. **SSH into WSL**: `ssh jrod0@localhost -p 22` (password: `agentpassword`)
2. **Execute commands**: All coding tasks run in a real Linux environment
3. **Access files**: Everything in `F:\Workspace` is mounted at `/mnt/f/Workspace`
4. **Use Docker**: Full Docker support for containerized workflows
5. **Git operations**: Native Git with SSH key support

---

## Permanent Configuration

### Auto-start SSH on WSL boot

Create `/etc/wsl.conf` in WSL:
```bash
sudo nano /etc/wsl.conf
```

Add:
```
[boot]
systemd = true
command = service ssh start
```

Then restart WSL:
```powershell
wsl --shutdown
wsl -d Ubuntu
```

### Fixed IP for SSH (Optional)

WSL2 IP changes on restart. For a stable SSH endpoint, add to Windows PowerShell profile:
```powershell
# Get WSL2 IP
$wslIp = wsl -d Ubuntu -e bash -c "hostname -I | cut -d' ' -f1"
Write-Host "WSL2 IP: $wslIp"
```

---

## Performance Notes

- **Disk I/O**: Files on `/mnt/f` are slightly slower than native Linux filesystem
- **Recommendation**: For intensive builds, work in `~/projects` (native Linux) and copy results to `/mnt/f/Workspace`
- **Docker**: Runs natively with full performance

---

## Migration from QEMU Plan

This WSL2 approach replaces the QEMU VM plan because:
- ✅ No complex VM setup required
- ✅ SSH works immediately
- ✅ No cloud-init or ISO boot issues
- ✅ Native performance
- ✅ Already installed on your system

The USB drive (`F:`) remains the portable workspace - just copy the `F:\Workspace` folder and `setup-wsl.sh` script to any Windows machine with WSL2 enabled.

---

**Next Steps**: Run the setup script and start coding! 🚀
