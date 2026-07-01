#!/bin/bash
# agent-run.sh
# Linux-side helper script for agents working inside the portable workspace

set -e

WORKSPACE="/mnt/f/Workspace"

if [ -d "$WORKSPACE" ]; then
    cd "$WORKSPACE"
else
    echo "Warning: $WORKSPACE not mounted. Working in current directory."
fi

echo "=== Agent Workspace Session ==="
echo "Current dir: $(pwd)"
echo "Command: $*"
echo "================================"

# Run the actual command
exec "$@"
