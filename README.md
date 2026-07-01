# Portable AI Coding Workspace

**A portable Linux coding environment for local AI agents that lives on a USB drive.**

- 🐧 **Primary**: WSL2 Ubuntu (fast, works today)
- 🖥️ **Alternative**: QEMU-based Linux VM (scripts included)
- 🚀 **Headless-friendly** — designed for AI agents
- 💾 **Portable** — take your entire dev environment anywhere

---

## Current Status

| Feature              | Status     | Notes |
|----------------------|------------|-------|
| Run Linux commands   | ✅ Working | Use `agent-run.ps1` or direct `wsl` |
| Git                  | ✅ Working | Available inside WSL |
| Python               | ✅ Working | 3.12.3 |
| Workspace sync       | ⚠️ Partial | `/mnt/f/Workspace` when F: is mounted |
| SSH server           | ❌ Pending | apt installs often time out |
| Docker               | ⚠️ Partial | Works on Windows host |

**Recommended way for agents right now**: Use the `agent-run.ps1` helper.

---

## Quick Start for Agents

```powershell
# Run any command inside the Linux environment
.\Scripts\agent-run.ps1 "git status"
.\Scripts\agent-run.ps1 "python3 -c 'print(\"hello from linux\")'"
.\Scripts\agent-run.ps1 "ls -la"

# Background task
.\Scripts\agent-run.ps1 "long_build_command" -Background
```

Direct alternative:
```powershell
wsl -d Ubuntu -e bash -c "cd /mnt/f/Workspace && <your command>"
```

---

## Project Structure

```
F:\
├── Workspace/                  # Main shared folder for projects & outputs
│   ├── Projects/
│   ├── Outputs/
│   └── Agent-Logs/
├── Scripts/
│   ├── agent-run.ps1           # ← Main entry point for agents
│   ├── agent-run.sh
│   └── Start-LinuxVM.ps1       # (for QEMU method)
├── .github/workflows/          # Validation on every push
└── README.md
```

---

## For AI Agents

Your agents can:

- Execute Linux commands without a full VM
- Access a persistent workspace on the USB
- Use Git and Python immediately
- Run long tasks in the background

All results written to `F:\Workspace` are visible from both Windows and Linux.

---

## Future / Optional

- Full SSH access into the Linux environment
- Docker inside Linux
- QEMU-based isolated VM (alternative to WSL2)
- macOS VM support (documented but not required)

See `Workspace/STATUS.md` for the latest detailed status.

---

**Goal**: Give your local AI agents a reliable, portable Linux coding environment they can use on any Windows machine.