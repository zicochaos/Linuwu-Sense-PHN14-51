#!/bin/bash
#
# Kernel Update Compatibility Script for Linuwu-Sense
# Automatically handles kernel updates, installs headers, rebuilds and loads module
#
# Usage: ./kernel-update.sh [options]
#   Options:
#     --force     : Force rebuild even if module seems compatible
#     --verbose   : Show detailed output
#     --help      : Show this help message
#

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/kernel-update.log"
BACKUP_DIR="$SCRIPT_DIR/backups"
MODULE_NAME="linuwu_sense"
CURRENT_KERNEL="$(uname -r)"
VERBOSE=false
FORCE_REBUILD=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_REBUILD=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --force     : Force rebuild even if module seems compatible"
            echo "  --verbose   : Show detailed output"
            echo "  --help      : Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Logging functions
log() {
    echo -e "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "$1"
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

error_exit() {
    log "${RED}✗ Error: $1${NC}"
    exit 1
}

# Banner
show_banner() {
    echo -e "${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     ${BOLD}Kernel Update Compatibility Script${NC}${CYAN}           ║${NC}"
    echo -e "${CYAN}║     ${BOLD}Linuwu-Sense Module Manager${NC}${CYAN}                  ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=${ID:-unknown}
        OS_VERSION=${VERSION_ID:-unknown}
    else
        error_exit "Cannot detect operating system"
    fi
    log_verbose "Detected OS: $OS_NAME"
}

# Check if running as root when needed
check_sudo() {
    if [ "$EUID" -eq 0 ]; then
        log_verbose "Running as root"
    else
        log_verbose "Not running as root, will use sudo when needed"
    fi
}

# Step 1: Check current module status
check_module_status() {
    log "${BLUE}━━━ Checking Module Status ━━━${NC}"
    log "Current kernel: ${BOLD}$CURRENT_KERNEL${NC}"

    # Check if module is currently loaded
    if lsmod | grep -q "^$MODULE_NAME"; then
        log "${GREEN}✓ Module is currently loaded${NC}"
        local loaded=true
    else
        log "${YELLOW}○ Module is not currently loaded${NC}"
        local loaded=false
    fi

    # Check if module exists for current kernel
    if [ -f "/lib/modules/$CURRENT_KERNEL/kernel/drivers/platform/x86/${MODULE_NAME}.ko" ]; then
        log "${GREEN}✓ Module exists for current kernel${NC}"
        local exists=true
    else
        log "${YELLOW}○ Module not found for current kernel${NC}"
        local exists=false
    fi

    # Check if we can build
    if [ -f "$SCRIPT_DIR/src/${MODULE_NAME}.c" ]; then
        log "${GREEN}✓ Source code available${NC}"
    else
        error_exit "Source code not found at $SCRIPT_DIR/src/${MODULE_NAME}.c"
    fi

    # Determine if rebuild needed
    if [ "$FORCE_REBUILD" = true ]; then
        log "${YELLOW}! Force rebuild requested${NC}"
        return 1
    elif [ "$exists" = false ]; then
        log "${YELLOW}! Module needs to be built for kernel $CURRENT_KERNEL${NC}"
        return 1
    elif [ "$loaded" = false ]; then
        log "${YELLOW}! Module exists but not loaded${NC}"
        # Try to load it
        if sudo modprobe $MODULE_NAME 2>/dev/null; then
            log "${GREEN}✓ Module loaded successfully${NC}"
            return 0
        else
            log "${YELLOW}! Module failed to load, rebuild needed${NC}"
            return 1
        fi
    else
        log "${GREEN}✓ Module is working correctly${NC}"
        return 0
    fi
}

# Step 2: Install kernel headers
install_kernel_headers() {
    log ""
    log "${BLUE}━━━ Installing Kernel Headers ━━━${NC}"

    case "$OS_NAME" in
        ubuntu|debian|pop)
            local headers_pkg="linux-headers-$CURRENT_KERNEL"
            log "Installing $headers_pkg..."
            if ! dpkg -l | grep -q "^ii.*$headers_pkg"; then
                sudo apt update
                sudo apt install -y "$headers_pkg" build-essential dkms
                log "${GREEN}✓ Headers installed${NC}"
            else
                log "${GREEN}✓ Headers already installed${NC}"
            fi
            ;;

        cachyos)
            local headers_pkg="linux-cachyos-headers"
            log "Installing $headers_pkg..."
            if ! pacman -Q "$headers_pkg" &>/dev/null; then
                sudo pacman -S --noconfirm "$headers_pkg" base-devel clang llvm
                log "${GREEN}✓ Headers and LLVM installed${NC}"
            else
                log "${GREEN}✓ Headers already installed${NC}"
            fi
            # Set LLVM flag for CachyOS
            export LLVM=1
            ;;

        arch|manjaro|endeavouros)
            local headers_pkg="linux-headers"
            log "Installing $headers_pkg..."
            if ! pacman -Q "$headers_pkg" &>/dev/null; then
                sudo pacman -S --noconfirm "$headers_pkg" base-devel
                log "${GREEN}✓ Headers installed${NC}"
            else
                log "${GREEN}✓ Headers already installed${NC}"
            fi
            ;;

        fedora|rhel|centos)
            log "Installing kernel-devel..."
            sudo dnf install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r) gcc make
            log "${GREEN}✓ Headers installed${NC}"
            ;;

        opensuse*)
            log "Installing kernel-devel..."
            sudo zypper install -y kernel-devel kernel-default-devel gcc make
            log "${GREEN}✓ Headers installed${NC}"
            ;;

        *)
            log "${YELLOW}⚠ Unknown distribution: $OS_NAME${NC}"
            log "Please install kernel headers manually for kernel $CURRENT_KERNEL"
            read -p "Have you installed the headers? (y/n) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                error_exit "Kernel headers are required to continue"
            fi
            ;;
    esac

    # Verify headers are installed
    if [ ! -d "/lib/modules/$CURRENT_KERNEL/build" ]; then
        error_exit "Kernel headers not found at /lib/modules/$CURRENT_KERNEL/build"
    fi
    log_verbose "Headers verified at /lib/modules/$CURRENT_KERNEL/build"
}

# Step 3: Backup current module if it exists
backup_current_module() {
    if [ -f "$SCRIPT_DIR/src/${MODULE_NAME}.ko" ]; then
        log ""
        log "${BLUE}━━━ Backing Up Current Module ━━━${NC}"

        mkdir -p "$BACKUP_DIR"
        local backup_name="${MODULE_NAME}_$(date +%Y%m%d_%H%M%S)_$(uname -r).ko"
        cp "$SCRIPT_DIR/src/${MODULE_NAME}.ko" "$BACKUP_DIR/$backup_name"
        log "${GREEN}✓ Module backed up to $BACKUP_DIR/$backup_name${NC}"
    fi
}

# Step 4: Build the module
build_module() {
    log ""
    log "${BLUE}━━━ Building Module ━━━${NC}"

    cd "$SCRIPT_DIR"

    # Clean previous build
    log_verbose "Cleaning previous build..."
    make clean > /dev/null 2>&1

    # Determine build command based on distro
    local build_cmd="make"
    if [ "$OS_NAME" = "cachyos" ] || [ -n "${LLVM:-}" ]; then
        build_cmd="env LLVM=1 make"
        log "Using LLVM/Clang for build..."
    else
        log "Using GCC for build..."
    fi

    # Build the module
    log "Building module for kernel $CURRENT_KERNEL..."
    if $VERBOSE; then
        eval $build_cmd
    else
        if eval $build_cmd > "$LOG_FILE.build" 2>&1; then
            log "${GREEN}✓ Module built successfully${NC}"
        else
            log "${RED}✗ Build failed${NC}"
            log "Build output saved to $LOG_FILE.build"
            echo ""
            echo "Last 20 lines of build output:"
            tail -20 "$LOG_FILE.build"
            error_exit "Module build failed. Check $LOG_FILE.build for details"
        fi
    fi

    # Verify module was built
    if [ ! -f "$SCRIPT_DIR/src/${MODULE_NAME}.ko" ]; then
        error_exit "Module file not found after build"
    fi

    log_verbose "Module file created: $SCRIPT_DIR/src/${MODULE_NAME}.ko"
}

# Step 5: Install and load the module
install_module() {
    log ""
    log "${BLUE}━━━ Installing Module ━━━${NC}"

    # Unload old module if loaded
    if lsmod | grep -q "^$MODULE_NAME"; then
        log "Unloading current module..."
        sudo rmmod $MODULE_NAME 2>/dev/null || true
    fi

    # Remove acer_wmi if loaded (conflicts with our module)
    if lsmod | grep -q "^acer_wmi"; then
        log "Removing conflicting acer_wmi module..."
        sudo rmmod acer_wmi 2>/dev/null || true
    fi

    # Install the module
    log "Installing module to system..."
    sudo make install > /dev/null 2>&1

    # Ensure module loads at boot
    echo "$MODULE_NAME" | sudo tee /etc/modules-load.d/${MODULE_NAME}.conf > /dev/null
    echo "blacklist acer_wmi" | sudo tee /etc/modprobe.d/blacklist-acer_wmi.conf > /dev/null

    # Load the module
    log "Loading module..."
    if sudo modprobe $MODULE_NAME; then
        log "${GREEN}✓ Module loaded successfully${NC}"
    else
        # Try direct insmod as fallback
        log_verbose "modprobe failed, trying insmod..."
        if sudo insmod "$SCRIPT_DIR/src/${MODULE_NAME}.ko"; then
            log "${GREEN}✓ Module loaded via insmod${NC}"
        else
            error_exit "Failed to load module"
        fi
    fi
}

# Step 6: Verify functionality
verify_functionality() {
    log ""
    log "${BLUE}━━━ Verifying Functionality ━━━${NC}"

    # Check if module is loaded
    if ! lsmod | grep -q "^$MODULE_NAME"; then
        error_exit "Module not loaded after installation"
    fi
    log "${GREEN}✓ Module loaded${NC}"

    # Check for sysfs interfaces
    if [ -d "/sys/devices/platform/acer-wmi/predator_sense" ]; then
        log "${GREEN}✓ Predator Sense interface detected${NC}"
    elif [ -d "/sys/devices/platform/acer-wmi/nitro_sense" ]; then
        log "${GREEN}✓ Nitro Sense interface detected${NC}"
    else
        log "${YELLOW}⚠ No Predator/Nitro sense interface found${NC}"
        log "This might be normal for your hardware model"
    fi

    # Check for RGB keyboard interface
    if [ -d "/sys/devices/platform/acer-wmi/four_zoned_kb" ]; then
        log "${GREEN}✓ RGB keyboard interface detected${NC}"
    else
        log_verbose "No RGB keyboard interface found"
    fi

    # Try to check power profile if available
    if [ -f "/sys/devices/platform/acer-wmi/predator_sense/power_profile" ]; then
        local profile=$(cat /sys/devices/platform/acer-wmi/predator_sense/power_profile)
        case $profile in
            0) log "${GREEN}✓ Power profile: Quiet (60W)${NC}" ;;
            1) log "${GREEN}✓ Power profile: Balanced (80W)${NC}" ;;
            2) log "${GREEN}✓ Power profile: Performance (100W)${NC}" ;;
            3) log "${GREEN}✓ Power profile: Turbo (125W)${NC}" ;;
            *) log "${GREEN}✓ Power profile: $profile${NC}" ;;
        esac
    fi

    # Check if control scripts work
    if [ -x "$SCRIPT_DIR/predator-profile" ]; then
        if "$SCRIPT_DIR/predator-profile" status > /dev/null 2>&1; then
            log "${GREEN}✓ Control scripts working${NC}"
        else
            log "${YELLOW}⚠ Control scripts may need sudo${NC}"
        fi
    fi

    # Restore settings if they exist
    if [ -f "/etc/predator-sense/settings.conf" ] && [ -x "$SCRIPT_DIR/predator-settings" ]; then
        log ""
        log "${BLUE}━━━ Restoring Saved Settings ━━━${NC}"
        if sudo "$SCRIPT_DIR/predator-settings" restore > /dev/null 2>&1; then
            log "${GREEN}✓ Settings restored${NC}"
        else
            log "${YELLOW}⚠ Could not restore settings${NC}"
        fi
    fi
}

# Step 7: Create systemd service for automatic updates
create_auto_update_service() {
    log ""
    log "${BLUE}━━━ Setting Up Auto-Update Service ━━━${NC}"

    local service_file="/etc/systemd/system/linuwu-sense-kernel-update.service"
    local service_content="[Unit]
Description=Linuwu-Sense Kernel Update Check
After=multi-user.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_DIR/kernel-update.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target"

    echo "$service_content" | sudo tee "$service_file" > /dev/null

    # Create hook for kernel updates (for pacman-based systems)
    if [ "$OS_NAME" = "arch" ] || [ "$OS_NAME" = "cachyos" ] || [ "$OS_NAME" = "manjaro" ]; then
        local hook_file="/etc/pacman.d/hooks/linuwu-sense.hook"
        sudo mkdir -p /etc/pacman.d/hooks

        cat <<EOF | sudo tee "$hook_file" > /dev/null
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux*

[Action]
Description = Updating Linuwu-Sense module for new kernel...
When = PostTransaction
Exec = /usr/bin/systemctl start linuwu-sense-kernel-update.service
EOF
        log "${GREEN}✓ Pacman hook created${NC}"
    fi

    # Enable service
    sudo systemctl daemon-reload
    sudo systemctl enable linuwu-sense-kernel-update.service 2>/dev/null || true

    log "${GREEN}✓ Auto-update service configured${NC}"
}

# Main execution
main() {
    show_banner

    # Initialize log
    echo "=== Kernel Update Check Started ===" >> "$LOG_FILE"
    echo "Date: $(date)" >> "$LOG_FILE"
    echo "Kernel: $CURRENT_KERNEL" >> "$LOG_FILE"

    # Detect distribution
    detect_distro
    check_sudo

    # Check if module needs updating
    if check_module_status; then
        log ""
        log "${GREEN}━━━ Module is Compatible ━━━${NC}"
        log "${GREEN}✓ No update needed for kernel $CURRENT_KERNEL${NC}"

        # Still verify settings are restored
        if [ -f "/etc/predator-sense/settings.conf" ] && [ -x "$SCRIPT_DIR/predator-settings" ]; then
            if sudo "$SCRIPT_DIR/predator-settings" restore > /dev/null 2>&1; then
                log "${GREEN}✓ Settings verified${NC}"
            fi
        fi
    else
        log ""
        log "${YELLOW}━━━ Module Update Required ━━━${NC}"

        # Perform update
        install_kernel_headers
        backup_current_module
        build_module
        install_module
        verify_functionality

        log ""
        log "${GREEN}━━━ Update Complete ━━━${NC}"
        log "${GREEN}✓ Module successfully updated for kernel $CURRENT_KERNEL${NC}"
    fi

    # Ask about auto-update service
    if [ ! -f "/etc/systemd/system/linuwu-sense-kernel-update.service" ]; then
        echo ""
        read -p "Enable automatic module updates after kernel upgrades? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            create_auto_update_service
        fi
    fi

    log ""
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "Log saved to: $LOG_FILE"

    # Show quick status
    if [ -x "$SCRIPT_DIR/predator" ]; then
        echo ""
        "$SCRIPT_DIR/predator" status 2>/dev/null || true
    fi
}

# Run main function
main "$@"