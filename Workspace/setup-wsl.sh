# Ubuntu WSL2 Setup Script for Portable Coding Workspace
# Run this in WSL: bash /mnt/f/Workspace/setup-wsl.sh

#!/bin/bash
set -e

echo "=== Setting up Ubuntu WSL2 for AI Agent Coding ==="

# Update package lists
echo "Updating package lists..."
sudo apt-get update -y

# Install essential packages
echo "Installing essential packages..."
sudo apt-get install -y \
    openssh-server \
    git \
    docker.io \
    build-essential \
    samba \
    curl \
    wget

# Configure SSH
echo "Configuring SSH server..."
sudo service ssh start
sudo systemctl enable ssh

# Allow password authentication
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set password for current user
echo "Setting user password..."
echo "$USER:agentpassword" | sudo chpasswd

# Add user to sudo group (should already be there)
sudo usermod -aG sudo $USER

# Configure Docker
echo "Configuring Docker..."
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

# Create workspace directory
echo "Creating workspace directory..."
mkdir -p /mnt/f/Workspace/Projects
mkdir -p /mnt/f/Workspace/Outputs
mkdir -p /mnt/f/Workspace/Agent-Logs

# Set up SSH key (optional - for passwordless access)
echo "Generating SSH key..."
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "agent@ubuntu-wsl"

echo ""
echo "=== Setup Complete! ==="
echo "SSH server is running on port 22"
echo "Username: $USER"
echo "Password: agentpassword"
echo ""
echo "To connect from Windows: ssh $USER@localhost -p 22"
echo "Workspace is mounted at /mnt/f/Workspace"
