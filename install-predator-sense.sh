#!/bin/bash
#
# Installation script for Predator Sense Power Profile Control
# For Acer Predator PHN14-51 with Linuwu-Sense v6.13
#

set -e

echo "========================================"
echo "Predator Sense Power Profile Installer"
echo "For Acer Predator PHN14-51"
echo "========================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please do not run this script as root/sudo"
   echo "The script will ask for sudo password when needed"
   exit 1
fi

# Install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y build-essential linux-headers-$(uname -r) dkms git gcc-12 g++-12

# Build module
echo ""
echo "Building kernel module..."
make clean
make

# Install module
echo ""
echo "Installing kernel module..."
sudo make install

# Install predator-profile script
echo ""
echo "Installing predator-profile command..."
sudo cp predator-profile /usr/local/bin/
sudo chmod +x /usr/local/bin/predator-profile

# Install systemd service (optional)
echo ""
read -p "Do you want to install systemd service for automatic performance mode at boot? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo cp predator-sense.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable predator-sense.service
    echo "Systemd service installed and enabled"
fi

# Test installation
echo ""
echo "Testing installation..."
if [ -f /sys/devices/platform/acer-wmi/predator_sense/power_profile ]; then
    echo "✓ Power profile interface detected"
    predator-profile status
else
    echo "✗ Power profile interface not found"
    echo "The module may need a reboot to work properly"
fi

echo ""
echo "========================================"
echo "Installation complete!"
echo ""
echo "Usage:"
echo "  predator-profile quiet       - Set to 80W GPU limit"
echo "  predator-profile balanced    - Set to 100W GPU limit"
echo "  predator-profile performance - Set to 125W GPU limit"
echo "  predator-profile status      - Show current profile"
echo ""
echo "The module will load automatically on boot."
echo "========================================"