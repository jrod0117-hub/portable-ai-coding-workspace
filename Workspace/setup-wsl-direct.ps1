# Portable AI Coding Workspace - Direct WSL2 Setup
# Run this PowerShell script to configure your Linux environment

Write-Host "=== Configuring WSL2 for AI Agent Coding ===" -ForegroundColor Cyan

# Start WSL and run setup
Write-Host "Installing packages in WSL2 Ubuntu..." -ForegroundColor Yellow

$setupCommands = @'
sudo apt-get update -y
sudo apt-get install -y openssh-server git docker.io build-essential curl wget

# Configure SSH
sudo service ssh start
echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
echo "agentpassword" | sudo chpasswd $(whoami)

# Create workspace symlink
mkdir -p ~/workspace
sudo ln -sf /mnt/f/Workspace ~/workspace 2>/dev/null || echo "Will mount F: drive later"

echo "Setup complete!"
'@

# Execute in WSL
wsl -d Ubuntu -e bash -c "$setupCommands"

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Green
Write-Host "1. Access WSL terminal: wsl -d Ubuntu"
Write-Host "2. SSH from Windows: ssh $(whoami)@localhost -p 22"
Write-Host "3. Password: agentpassword"
Write-Host ""
Write-Host "Workspace location: F:\Workspace (accessible from both Windows and WSL)" -ForegroundColor Cyan
