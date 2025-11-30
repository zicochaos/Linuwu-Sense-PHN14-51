#!/bin/bash
#
# DKMS Install Script for Linuwu-Sense
# Installs the module with DKMS for automatic rebuilding on kernel updates
#

set -e

PACKAGE_NAME="linuwu-sense"
PACKAGE_VERSION="1.0.0"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Installing Linuwu-Sense with DKMS...${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (sudo)${NC}"
    exit 1
fi

# Check if DKMS is installed
if ! command -v dkms &> /dev/null; then
    echo -e "${RED}DKMS is not installed!${NC}"
    echo ""
    echo "Install it with:"
    echo "  Ubuntu/Debian: sudo apt install dkms"
    echo "  CachyOS/Arch:  sudo pacman -S dkms"
    echo "  Fedora:        sudo dnf install dkms"
    exit 1
fi

# Remove old DKMS installation if exists
if dkms status | grep -q "${PACKAGE_NAME}"; then
    echo "Removing old DKMS installation..."
    dkms remove ${PACKAGE_NAME}/${PACKAGE_VERSION} --all 2>/dev/null || true
fi

# Remove old source directory if exists
if [ -d "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}" ]; then
    echo "Removing old source directory..."
    rm -rf "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
fi

# Copy source to DKMS directory
echo "Copying source to /usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}/"
mkdir -p "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
cp -r "${SOURCE_DIR}/src" "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}/"
cp "${SOURCE_DIR}/Makefile" "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}/"
cp "${SOURCE_DIR}/dkms.conf" "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}/"
cp "${SOURCE_DIR}/dkms-build.sh" "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}/"
chmod +x "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}/dkms-build.sh"

# Add to DKMS
echo "Adding module to DKMS..."
dkms add -m ${PACKAGE_NAME} -v ${PACKAGE_VERSION}

# Build for current kernel
echo "Building module for kernel $(uname -r)..."
dkms build -m ${PACKAGE_NAME} -v ${PACKAGE_VERSION}

# Install (--force to override existing module)
echo "Installing module..."
dkms install -m ${PACKAGE_NAME} -v ${PACKAGE_VERSION} --force

# Blacklist acer_wmi if not already
if [ ! -f /etc/modprobe.d/blacklist-acer_wmi.conf ]; then
    echo "Blacklisting acer_wmi..."
    echo "blacklist acer_wmi" > /etc/modprobe.d/blacklist-acer_wmi.conf
fi

# Load the module
echo "Loading module..."
modprobe -r linuwu_sense 2>/dev/null || true
modprobe linuwu_sense

echo ""
echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}DKMS Installation Complete!${NC}"
echo -e "${GREEN}=======================================${NC}"
echo ""
echo "The module will automatically rebuild when kernel updates."
echo ""
echo "DKMS Status:"
dkms status | grep ${PACKAGE_NAME}
echo ""
echo "Useful commands:"
echo "  dkms status                    - Check DKMS module status"
echo "  sudo dkms remove ${PACKAGE_NAME}/${PACKAGE_VERSION} --all  - Remove module"
