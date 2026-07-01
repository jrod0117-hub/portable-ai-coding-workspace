# Portable AI Coding Workspace

**A complete dual-OS (Linux + macOS) headless coding environment on a USB drive for local AI agents.**

- 🐧 **Linux-first** - WSL2 or QEMU-based Ubuntu VM
- 🍎 **macOS optional** - QEMU + OpenCore (documented, not required)
- 🚀 **Headless operation** - No PC reboot, no GUI needed
- 💾 **Fully portable** - Unplug USB, take your entire dev environment anywhere

---

## Quick Start

### 1. Clone to USB Drive

```bash
# Clone directly to your USB drive (e.g., F:)
git clone https://github.com/<your-username>/portable-ai-coding-workspace.git F:\
```

### 2. Run Setup Script

```powershell
# Open PowerShell as Administrator
cd F:\
.\Setup-USB-Workspace.ps1
```

### 3. Start Coding

**Option A: WSL2 (Recommended - Works Immediately)**
```powershell
# Direct WSL execution
wsl -d Ubuntu -e bash -c "cd /mnt/f/Workspace && <command>"
```

**Option B: QEMU VM (After SSH setup)**
```powershell
# Start Linux VM headless
.\Scripts\Start-LinuxVM.ps1

# SSH into VM
ssh agentuser@localhost -p 2222
```

---

## What's Included

```
F:\
├── VMs/
│   ├── Linux-Coding/       # Linux VM disk image (not in Git)
│   └── macOS-Coding/       # macOS VM disk image (optional, not in Git)
├── Workspace/
│   ├── Projects/           # Your code projects
│   ├── Outputs/            # Build artifacts, results
│   └── Agent-Logs/         # AI agent session logs
├── Scripts/
│   ├── Start-LinuxVM.ps1   # Launch Linux VM headless
│   ├── Stop-LinuxVM.ps1    # Shutdown Linux VM
│   └── SSH-Into-Linux.ps1  # Quick SSH connect
├── .github/workflows/
│   └── validate-usb-workspace.yml  # CI validation
├── Setup-USB-Workspace.ps1         # One-time setup
├── USB-Coding-Workspace-Setup.md   # Full documentation
└── README.md                       # This file
```

---

## For AI Agents

Your local AI agents (OpenClaw, etc.) can:

1. **Execute commands** in isolated Linux/macOS environments
2. **Read/write files** in `F:\Workspace` (shared between host and VMs)
3. **Use Git, Docker, Python, Node** natively in Linux
4. **Run headless** - no GUI or PC reboot required

### Agent Entry Points

**WSL2 (Immediate):**
```powershell
wsl -d Ubuntu -e bash -c "cd /mnt/f/Workspace/Projects && git clone <repo>"
```

**QEMU SSH (After setup):**
```bash
ssh agentuser@localhost -p 2222
# Password: <set during VM setup>
```

---

## Status

| Component | Status | Notes |
|-----------|--------|-------|
| WSL2 Linux | ✅ Operational | Git installed, SSH pending |
| QEMU Linux | ⏸️ Documented | Scripts ready, VM disk creation needed |
| macOS VM | 📋 Documented | Optional Phase 2 |
| GitHub Actions | ✅ Configured | Validates on every push |

---

## Development

### Validation

GitHub Actions automatically validates:
- PowerShell script linting (PSScriptAnalyzer)
- Markdown formatting (markdownlint)
- Required folder structure

Run locally:
```powershell
# Lint PowerShell scripts
Invoke-ScriptAnalyzer -Path .\Scripts -Recurse

# Validate folder structure
.\validate-usb-workspace.yml  # Or run in GitHub Actions
```

### Contributing

1. Fork the repo
2. Create a feature branch
3. Test changes with `validate-usb-workspace.yml`
4. Submit PR

---

## License

MIT - Use freely for personal and commercial projects.

---

**Built for local AI agents. Works offline. Travels with you.** 🚀
