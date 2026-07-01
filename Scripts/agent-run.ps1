# agent-run.ps1
# Helper for AI agents to run commands inside the portable Linux environment (WSL2)
#
# Usage:
#   .\Scripts\agent-run.ps1 "git status"
#   .\Scripts\agent-run.ps1 "python3 -c 'print(42)'"

param(
    [Parameter(Mandatory=$true)]
    [string]$Command,

    [switch]$Background
)

$distro = "Ubuntu"

# Robust command that falls back if /mnt/f is not mounted
$bashCommand = @"
if [ -d /mnt/f/Workspace ]; then
    cd /mnt/f/Workspace
elif [ -d /mnt/c/Users ]; then
    echo 'Note: Using current directory (F: not mounted)'
else
    echo 'Note: Workspace path not found'
fi
$Command
"@

if ($Background) {
    Write-Host "Running in background: $Command" -ForegroundColor Yellow
    Start-Process -FilePath "wsl" -ArgumentList "-d", $distro, "-e", "bash", "-c", $bashCommand -WindowStyle Hidden
    Write-Host "Started in background."
} else {
    Write-Host ">>> Running on ${distro}:" -ForegroundColor Cyan
    wsl -d $distro -e bash -c $bashCommand
}
