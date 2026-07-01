# agent-run.ps1
# Simple helper for AI agents to run commands inside the portable Linux environment (WSL2)
#
# Usage examples:
#   .\Scripts\agent-run.ps1 "echo hello"
#   .\Scripts\agent-run.ps1 "cd /mnt/f/Workspace && git status"
#   .\Scripts\agent-run.ps1 "python3 --version"

param(
    [Parameter(Mandatory=$true)]
    [string]$Command,

    [switch]$Background
)

$distro = "Ubuntu"

# Build the full command
$fullCommand = "cd /mnt/f/Workspace 2>/dev/null || true; $Command"

if ($Background) {
    Write-Host "Running in background: $Command" -ForegroundColor Yellow
    Start-Process -FilePath "wsl" -ArgumentList "-d", $distro, "-e", "bash", "-c", $fullCommand -WindowStyle Hidden
    Write-Host "Started in background."
} else {
    Write-Host ">>> Running on $distro:" -ForegroundColor Cyan
    wsl -d $distro -e bash -c $fullCommand
}
