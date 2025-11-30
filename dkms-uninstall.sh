#!/bin/bash
#
# DKMS Uninstall Script for Linuwu-Sense
# Removes the module from DKMS
#

set -e

PACKAGE_NAME="linuwu-sense"
PACKAGE_VERSION="1.0.0"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Uninstalling Linuwu-Sense from DKMS...${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (sudo)${NC}"
    exit 1
fi

# Unload module if loaded
if lsmod | grep -q linuwu_sense; then
    echo "Unloading module..."
    modprobe -r linuwu_sense
fi

# Remove from DKMS
if dkms status | grep -q "${PACKAGE_NAME}"; then
    echo "Removing from DKMS..."
    dkms remove ${PACKAGE_NAME}/${PACKAGE_VERSION} --all
else
    echo "Module not found in DKMS"
fi

# Remove source directory
if [ -d "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}" ]; then
    echo "Removing source directory..."
    rm -rf "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
fi

echo ""
echo -e "${GREEN}DKMS Uninstallation Complete!${NC}"
echo ""
echo "Note: The blacklist for acer_wmi was NOT removed."
echo "To remove it: sudo rm /etc/modprobe.d/blacklist-acer_wmi.conf"
