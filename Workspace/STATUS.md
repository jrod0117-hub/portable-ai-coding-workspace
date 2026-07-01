# Portable AI Coding Workspace - Current Status

**Repo**: https://github.com/jrod0117-hub/portable-ai-coding-workspace

## Current State (as of latest update)

### Linux Environment
- **Primary method**: WSL2 Ubuntu 24.04
- **Git**: Installed and working (v2.43.0)
- **Python**: Installed (3.12.3)
- **Workspace access**: Use `cd /mnt/f/Workspace` when F: drive is mounted
- **SSH server**: Not installed yet (repeated apt timeouts)
- **Docker**: Available on Windows host via Docker Desktop (WSL integration not enabled)

### Agent Interface
Agents can run Linux commands using:

**Recommended (Windows side):**
```powershell
.\Scripts\agent-run.ps1 "git status"
.\Scripts\agent-run.ps1 "python3 -c 'print(\"hello\")'"
```

**Direct:**
```powershell
wsl -d Ubuntu -e bash -c "cd /mnt/f/Workspace && <your command>"
```

### Known Limitations
- F: drive mounting inside WSL is inconsistent in some shells
- Package installation (apt) frequently times out
- No reliable SSH server yet

### Files Committed
Core scripts, documentation, and structure are on GitHub. Large disk images and ISOs are excluded.

## Next Priorities
1. Make workspace mounting more reliable
2. Get core dev packages installed (build-essential, etc.)
3. Improve agent helper scripts
4. Document current best practices for agents
5. (Optional later) Re-attempt QEMU or full SSH setup

## How to Use Today
Agents should use the `agent-run.ps1` wrapper or direct `wsl` commands targeting the `/mnt/f/Workspace` path.
