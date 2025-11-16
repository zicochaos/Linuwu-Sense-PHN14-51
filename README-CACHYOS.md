# Predator Sense Control for CachyOS

## Quick Start

The Predator Sense control system has been successfully updated for CachyOS with kernel 6.16.7.

### Installation

```bash
# Run the installation script
./install-predator-sense.sh
```

The script will:

- Detect CachyOS and install appropriate dependencies (clang, llvm)
- Build the kernel module with LLVM toolchain
- Install all control scripts
- Configure the module to load at boot

### Usage

#### Interactive Control Center

```bash
predator              # Launch interactive menu
predator status       # Show system status
```

#### Quick Presets

```bash
predator silent       # Quiet mode (minimal noise)
predator gaming       # Gaming mode (optimized)
predator extreme      # Maximum performance
predator travel       # Battery saving mode
```

#### Power Profiles (GPU Power Limit)

```bash
predator-profile quiet        # 60W GPU limit
predator-profile balanced     # 80W GPU limit
predator-profile performance  # 100W GPU limit
predator-profile turbo        # 125W GPU limit (MAXIMUM)
predator-profile status       # Check current profile
```

#### Fan Control

```bash
predator-fan auto             # Automatic fan control
predator-fan max              # Maximum fan speed
predator-fan custom 50 60     # Custom (CPU 50%, GPU 60%)
```

#### Battery Protection

```bash
predator-battery enable       # Limit charging to 80%
predator-battery disable      # Allow charging to 100%
```

#### Keyboard RGB

```bash
predator-keyboard wave        # Wave effect
predator-keyboard static      # Static color
predator-keyboard off         # Turn off backlight
predator-keyboard profile-gaming   # Gaming profile
```

### Using with sudo password

If sudo requires a password, you can provide it like this:

```bash
echo "your_password" | sudo -S predator-profile turbo
```

### Module Status

Check if the module is loaded:

```bash
lsmod | grep linuwu_sense
```

Check available sysfs interfaces:

```bash
ls /sys/devices/platform/acer-wmi/predator_sense/
ls /sys/devices/platform/acer-wmi/four_zoned_kb/
```

### Troubleshooting

If the module doesn't load automatically:

```bash
sudo modprobe linuwu_sense
```

If you get permission errors:

```bash
# Make scripts executable
chmod +x predator*

# Run with sudo when needed
sudo predator-profile turbo
```

### Kernel Compatibility

This module has been patched for kernel 6.16+ compatibility with the new platform_profile API.
The module is built with LLVM/Clang on CachyOS to match the kernel's build system.

### Important Notes

- Password for sudo operations: Use the `-S` flag with echo or run interactively
- The module replaces the standard acer_wmi module
- GPU power limits are hardware-controlled via WMI interface
- Changes persist until reboot or manual change

---

_Updated for CachyOS kernel 6.16.7-2_
