#!/bin/bash
#
# Installation script for Predator Sense Control System
# For Acer Predator PHN14-51 with enhanced Linuwu-Sense module
#

set -e

echo "========================================"
echo "Predator Sense Control System Installer"
echo "For Acer Predator PHN14-51"
echo "========================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
   echo "Please do not run this script as root/sudo"
   echo "The script will ask for sudo password when needed"
   exit 1
fi

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$ID
    OS_VERSION=$VERSION_ID
else
    echo "Error: Cannot detect operating system"
    exit 1
fi

echo "Detected OS: $OS_NAME"
echo "Kernel: $(uname -r)"
echo ""

# Install dependencies based on distribution
echo "Installing dependencies..."
if [[ "$OS_NAME" == "pop" || "$OS_NAME" == "ubuntu" || "$OS_NAME" == "debian" ]]; then
    sudo apt update
    sudo apt install -y build-essential linux-headers-$(uname -r) dkms git
elif [[ "$OS_NAME" == "cachyos" ]]; then
    echo "Installing CachyOS specific dependencies..."
    sudo pacman -S --noconfirm linux-cachyos-headers base-devel git clang llvm
    export LLVM=1
    export CC=clang
elif [[ "$OS_NAME" == "arch" || "$OS_NAME" == "manjaro" ]]; then
    sudo pacman -S --noconfirm linux-headers base-devel git
else
    echo "Warning: Unknown distribution $OS_NAME"
    echo "Please ensure kernel headers and build tools are installed"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Build module
echo ""
echo "Building kernel module..."
make clean
if [[ "$OS_NAME" == "cachyos" ]]; then
    # CachyOS uses LLVM/Clang for kernel modules
    echo "Building with LLVM/Clang for CachyOS..."
    env LLVM=1 make
else
    make
fi

# Install module
echo ""
echo "Installing kernel module..."
# Remove any existing acer_wmi module
sudo rmmod acer_wmi 2>/dev/null || true
sudo rmmod linuwu_sense 2>/dev/null || true

# Install the module
sudo install -d /lib/modules/$(uname -r)/kernel/drivers/platform/x86
sudo install -m 644 src/linuwu_sense.ko /lib/modules/$(uname -r)/kernel/drivers/platform/x86/
sudo depmod -a

# Load the module
echo "Loading module..."
sudo modprobe linuwu_sense || sudo insmod src/linuwu_sense.ko

# Install control scripts
echo ""
echo "Installing Predator Control System commands..."
sudo cp predator /usr/local/bin/
sudo cp predator-profile /usr/local/bin/
sudo cp predator-fan /usr/local/bin/
sudo cp predator-battery /usr/local/bin/
sudo cp predator-keyboard /usr/local/bin/
sudo cp predator-preset /usr/local/bin/
sudo cp predator-settings /usr/local/bin/
sudo chmod +x /usr/local/bin/predator*

# Configure module to load at boot
echo ""
echo "Configuring module to load at boot..."
echo "linuwu_sense" | sudo tee /etc/modules-load.d/linuwu_sense.conf > /dev/null
echo "blacklist acer_wmi" | sudo tee /etc/modprobe.d/blacklist-acer_wmi.conf > /dev/null

# Optional systemd service
echo ""
read -p "Do you want to set a default power profile at boot? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Select default profile:"
    echo "1) Quiet (60W)"
    echo "2) Balanced (80W)"
    echo "3) Performance (100W)"
    echo "4) Turbo (125W)"
    read -p "Choice (1-4): " profile_choice

    profile_cmd="balanced"
    case $profile_choice in
        1) profile_cmd="quiet" ;;
        2) profile_cmd="balanced" ;;
        3) profile_cmd="performance" ;;
        4) profile_cmd="turbo" ;;
    esac

    cat <<EOF | sudo tee /etc/systemd/system/predator-profile.service > /dev/null
[Unit]
Description=Predator Profile Control
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/predator-profile $profile_cmd
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable predator-profile.service
    echo "Default profile ($profile_cmd) will be set at boot"
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
echo "  predator              - Interactive control center"
echo "  predator gaming       - Gaming preset"
echo "  predator status       - Show system status"
echo ""
echo "Power profiles:"
echo "  predator-profile quiet       - 60W GPU limit"
echo "  predator-profile balanced    - 80W GPU limit"
echo "  predator-profile performance - 100W GPU limit"
echo "  predator-profile turbo       - 125W GPU limit"
echo ""
echo "Settings persistence:"
echo "  predator save                - Save current settings"
echo "  predator auto-restore        - Enable auto-restore at boot"
echo ""
echo "Run 'predator help' for full command list"
echo ""
echo "The module will load automatically on boot."
echo "========================================"