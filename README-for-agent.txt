PORTABLE AI CODING WORKSPACE - AGENT INSTRUCTIONS
==================================================

GOAL: Build a complete dual-OS (Linux + optional macOS) headless coding environment on a USB drive that your local AI agents can use.

YOU ONLY NEED TO DO THESE 4 THINGS:

1. Format a USB drive (128GB+ recommended, exFAT or NTFS).

2. Copy these files to the ROOT of the USB:
   - Setup-USB-Workspace.ps1
   - USB-Coding-Workspace-Setup.md
   - validate-usb-workspace.yml   (or the whole .github folder)
   - This README-for-agent.txt

3. Open PowerShell **as Administrator** and run from the USB root:
   .\Setup-USB-Workspace.ps1

4. After the script finishes, read the main guide:
   Open USB-Coding-Workspace-Setup.md and follow the remaining steps
   (mainly creating the Linux VM disk image - one time only).

That's it. The full workspace with all scripts will be ready.

After setup, agents can start a coding session with:
   .\Scripts\Launch-Coding-Session.ps1

All code and outputs will be saved in the Workspace folder on the USB.

For GitHub sharing: Use the repo-template folder when creating the repo.
