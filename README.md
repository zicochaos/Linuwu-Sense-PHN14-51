# 🎮 Linuwu-Sense for Acer Predator Helios Neo 14 (PHN14-51)

Unofficial Linux Kernel Module for Acer Gaming Laptops with **Unified Predator Control Center**

**Version**: Enhanced v6.16-compat with Kernel 6.16+ support and Settings Persistence
**Compatibility**: Kernel 6.12+ including 6.16+, CachyOS, Pop!\_OS, Ubuntu, Arch, and other modern Linux distributions

## 📌 Branch Information

- **main** (this branch): Enhanced version with Kernel 6.16+ support and all features
- **upstream-v6.13-original**: Original Linuwu-Sense v6.13 fork (preserved for reference)
- **Latest Release**: [v6.16-compat](https://github.com/zicochaos/Linuwu-Sense-PHN14-51/releases/tag/v6.16-compat)

## ✨ Features

- **🎯 Unified Control Center** - Simple `predator` command for all features
- **⚡ Power Profiles** - Quiet (60W), Balanced (80W), Performance (100W), Turbo (125W)
- **🌈 RGB Keyboard Control** - 20+ profiles, effects, brightness control, 4-zone support
- **🌀 Fan Control** - Auto, custom, and maximum speeds for CPU/GPU
- **🔋 Battery Management** - 80% charge limiter, calibration support
- **🎮 Quick Presets** - Gaming, Silent, Work, Extreme, Travel, and more
- **💾 Settings Persistence** - Save and auto-restore settings across reboots
- **🐧 Kernel 6.16+ Support** - Full compatibility with latest kernels

## 📦 What's Included

- ✅ **Enhanced Linuwu-Sense Module** - Kernel 6.16+ compatible with all hardware support
- ✅ **Predator Control Center** - User-friendly unified control system
- ✅ **Settings Manager** - Save and restore configurations across reboots
- ✅ **Enhanced Scripts** - Battery, fan, RGB keyboard management
- ✅ **20+ RGB Profiles** - Gaming and aesthetic keyboard themes
- ✅ **8 Quick Presets** - One-command system configurations

## 🚀 Quick Start

### Upgrading from Previous Versions

If you have an older version installed:

```bash
# Uninstall old version first
sudo make uninstall

# Then follow the installation steps below
```

### Installation

```bash
# Clone the repository
git clone https://github.com/zicochaos/Linuwu-Sense-PHN14-51.git
cd Linuwu-Sense-PHN14-51

# Run the automatic installer (detects your distribution)
./install-predator-sense.sh
```

#### Manual Installation

```bash
# Check kernel version
uname -r

# Install Linux headers for your distribution:

# Ubuntu/Debian/Pop!_OS
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r) dkms git gcc-12 g++-12

# CachyOS (requires LLVM/Clang)
sudo pacman -S --noconfirm linux-cachyos-headers base-devel git clang llvm

# Arch Linux/Manjaro
sudo pacman -S linux-headers base-devel git

# Fedora
sudo dnf install kernel-devel kernel-headers gcc make git

# openSUSE
sudo zypper install kernel-devel gcc make git

# Build the module
make  # For standard kernels
# OR
env LLVM=1 make  # For CachyOS/clang-built kernels

# Install
sudo make install
```

### Using the Predator Control Center

```bash
# Interactive menu (recommended)
predator

# Quick presets
predator gaming    # Gaming mode: Performance + RGB + Custom fans
predator silent    # Silent mode: Quiet + Dim keyboard + Auto fans
predator extreme   # Maximum everything!

# Check status
predator status

# Settings persistence (NEW!)
predator save           # Save current settings
predator restore        # Restore saved settings
predator auto-restore   # Enable auto-restore at boot
```

## 📱 Interactive Menu

When running `./predator`:

- **1-8**: Quick presets (Silent, Work, Gaming, Extreme, Travel, Movie, Coding, Creative)
- **0**: Turn keyboard backlight off
- **+/-**: Adjust keyboard brightness
- **s**: Show current status
- **a**: Advanced settings
- **q**: Quit

## 🎨 Available Presets

| Preset       | Power | Fans   | Battery   | RGB              | Use Case         |
| ------------ | ----- | ------ | --------- | ---------------- | ---------------- |
| **Silent**   | 60W   | Auto   | 80% limit | Dim white (20%)  | Library/night    |
| **Work**     | 80W   | Auto   | 80% limit | Warm white (70%) | Productivity     |
| **Gaming**   | 100W  | 60/70% | 100%      | Gaming RGB       | Gaming sessions  |
| **Extreme**  | 125W  | Max    | 100%      | Fire effect      | Benchmarks       |
| **Travel**   | 60W   | Auto   | 100%      | Off              | Battery saving   |
| **Movie**    | 60W   | Auto   | 80% limit | Ocean (30%)      | Media            |
| **Coding**   | 80W   | Auto   | 80% limit | F-keys (60%)     | Development      |
| **Creative** | 100W  | 50/60% | 80% limit | Rainbow          | Content creation |

## 💻 Command Line Usage

### Power Control

```bash
predator power quiet       # 60W GPU limit
predator power balanced    # 80W GPU limit
predator power performance # 100W GPU limit
predator power turbo       # 125W GPU limit (MAXIMUM)

# Or use the direct script
predator-profile turbo
predator-profile status    # Check current profile
```

### 💾 Settings Persistence (NEW!)

```bash
# Save your current configuration
predator save

# Enable automatic restore at boot
predator auto-restore

# Manually restore saved settings
predator restore

# Check saved vs current settings
predator-settings status
```

### RGB Keyboard

```bash
predator rgb static ff0000      # Red static
predator rgb wave               # Wave effect
predator rgb profile-cyberpunk  # Cyberpunk theme
predator rgb brightness 50      # 50% brightness
predator rgb off                # Turn off

# Or use the direct script
predator-keyboard wave
predator-keyboard profile-gaming
predator-keyboard brightness 75
```

### Fan Control

```bash
predator fan auto           # Automatic
predator fan max            # Maximum speed
predator fan custom 60 70   # CPU 60%, GPU 70%

# Or use the direct script
predator-fan auto
predator-fan max
predator-fan custom 50 60
```

### Battery Management

```bash
predator battery enable    # 80% charge limit (protect battery)
predator battery disable   # 100% charge

# Or use the direct script
predator-battery enable
predator-battery status
```

## 🌈 RGB Keyboard Profiles

**Gaming**: `gaming`, `fps`, `moba`, `racing`  
**Aesthetic**: `rainbow`, `fire`, `ocean`, `forest`, `sunset`, `cyberpunk`, `vaporwave`, `nordic`, `arctic`, `galaxy`, `toxic`, `cherry`, `halloween`, `matrix`, `stealth`, `miami`  
**Productivity**: `coding`, `typing`, `minimal`

## 🛠️ Advanced Usage (Direct sysfs)

For **Predator** laptops: `/sys/devices/platform/acer-wmi/predator_sense/`  
For **Nitro** laptops: `/sys/devices/platform/acer-wmi/nitro_sense/`

### Power Profile (0=Quiet, 1=Balanced, 2=Performance, 3=Turbo)

```bash
echo 3 | sudo tee /sys/devices/platform/acer-wmi/predator_sense/power_profile
```

### Fan Speed (CPU,GPU percentages)

```bash
echo 50,70 | sudo tee /sys/devices/platform/acer-wmi/predator_sense/fan_speed
```

### Battery Limiter (0=disabled, 1=enabled)

```bash
echo 1 | sudo tee /sys/devices/platform/acer-wmi/predator_sense/battery_limiter
```

### RGB Keyboard (4-zone)

```bash
# Effects: mode,speed,brightness,direction,r,g,b
echo 3,1,100,0,255,0,0 | sudo tee /sys/devices/platform/acer-wmi/four_zoned_kb/four_zone_mode

# Per-zone colors: zone1,zone2,zone3,zone4,brightness
echo ff0000,00ff00,0000ff,ffff00,100 | sudo tee /sys/devices/platform/acer-wmi/four_zoned_kb/per_zone_mode
```

## 🔄 Settings Persistence

Your settings now survive reboots! The system automatically saves and restores:

- Power profile (60W/80W/100W/125W)
- Fan settings (auto/manual speeds)
- Battery limiter (80% protection)
- RGB keyboard configuration

```bash
# Save current settings
predator save

# Enable auto-restore at boot (run once)
predator auto-restore

# Your settings will now persist across reboots!
```

Settings are stored in `/etc/predator-sense/settings.conf`

## 📋 All sysfs Features

### predator_sense directory

- `backlight_timeout` - RGB timeout after 30s idle (0/1)
- `battery_calibration` - Start/stop calibration (0/1)
- `battery_limiter` - 80% charge limit (0/1)
- `boot_animation_sound` - Boot animation/sound (0/1)
- `fan_speed` - CPU,GPU fan speeds (0-100)
- `lcd_override` - Reduce LCD latency (0/1)
- `power_profile` - Power mode (0-3)
- `usb_charging` - USB power when off (0/1)

### four_zoned_kb directory

- `four_zone_mode` - RGB effects and settings
- `per_zone_mode` - Individual zone colors

## 🔧 Uninstallation

```bash
make uninstall
```

## ⚠️ Warning

**Use at your own risk!** This driver is independently developed through reverse engineering the official PredatorSense app, without any involvement from Acer. It interacts with low-level WMI methods, which may not be tested across all models.

## 🙏 Credits

Inspired by [acer-predator-turbo](https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module). This project extends functionality with:

- Unified control system
- Power profile support (including Turbo mode)
- Enhanced RGB control with brightness
- Battery management
- Custom fan curves
- User-friendly interface

## 📝 Tested Hardware & Systems

### Hardware

- **Acer Predator Helios Neo 14 (PHN14-51)** with NVIDIA GPU
- Other Acer Predator/Nitro models may work (test carefully)

### Operating Systems

- **CachyOS** (with kernel 6.16.7+) ✅
- **Pop!\_OS** 22.04 LTS ✅
- **Ubuntu** 22.04/24.04 LTS ✅
- **Debian** 12 (Bookworm) ✅
- **Arch Linux** (Rolling) ✅
- **Manjaro** (Latest) ✅
- **Fedora** 39/40 ✅
- **openSUSE** Tumbleweed ✅

### Kernel Support

- **Fully tested**: 6.16.7+ (CachyOS), 6.12, 6.13
- **Compatible**: 5.15+ with appropriate headers
- **Recommended**: 6.0+ for best compatibility
- **Special support**: Kernel 6.16+ platform_profile API

## ⚠️ Known Issues

### RGB Keyboard STATIC Mode
- **Issue**: STATIC mode (solid colors) displays as breathing/fading on kernel 6.17+
- **Cause**: EC firmware bug after kernel/BIOS updates
- **Solution**: Automatically uses BREATHE mode with speed=0 as workaround
- **Impact**: Subtle breathing effect instead of truly static colors
- **Details**: See [RGB_KEYBOARD_ISSUES.md](RGB_KEYBOARD_ISSUES.md)

## 🐛 Troubleshooting

1. **Module won't load**:
   - Check `dmesg | grep linuwu` for errors
   - Ensure acer_wmi is blacklisted: `echo "blacklist acer_wmi" | sudo tee /etc/modprobe.d/blacklist-acer_wmi.conf`

2. **Build fails on CachyOS/Arch**:
   - Use LLVM: `env LLVM=1 make`
   - Install clang: `sudo pacman -S clang llvm`

3. **No predator_sense directory**:
   - Ensure your laptop model is supported
   - Try: `sudo modprobe linuwu_sense`

4. **Permission denied**:
   - Use `sudo` for sysfs writes
   - Or install control scripts: `sudo make install`

5. **RGB not working**:
   - Check if you have 4-zone keyboard support
   - Try: `ls /sys/devices/platform/acer-wmi/four_zoned_kb/`
   - **Known Issue**: STATIC mode broken on kernel 6.17+ (uses BREATHE mode as workaround)
   - See [RGB_KEYBOARD_ISSUES.md](RGB_KEYBOARD_ISSUES.md) for details

6. **Settings don't persist**:
   - Run: `predator auto-restore` to enable persistence
   - Check: `systemctl status predator-restore.service`

## 📄 Documentation

- [PREDATOR_CONTROL.md](PREDATOR_CONTROL.md) - Detailed control system guide
- [README-CACHYOS.md](README-CACHYOS.md) - CachyOS specific instructions
- [Releases](https://github.com/zicochaos/Linuwu-Sense-PHN14-51/releases) - Download specific versions

## 📝 Changelog

### Latest Release (v6.16-compat)

- **NEW**: Settings persistence across reboots
- **NEW**: Kernel 6.16+ compatibility (platform_profile API)
- **NEW**: CachyOS support with LLVM/Clang build
- **NEW**: Multi-distribution installer
- **NEW**: Auto-restore settings at boot
- Enhanced error handling in all scripts
- Improved documentation

### v6.13-enhanced

- Added unified Predator Control Center (`predator` command)
- Implemented 20+ RGB keyboard profiles
- Added interactive menu with colored output
- Created 8 quick presets for common scenarios
- Added keyboard brightness control (+/- keys)
- Integrated battery limiter and calibration
- Added fan control (auto/manual/max)
- Full support for 4-zone RGB keyboards
- Power profiles: Quiet (60W), Balanced (80W), Performance (100W), Turbo (125W)

### v6.13 (Base)

- Initial kernel module support
- Basic sysfs interfaces
- Hardware compatibility layer

## 🤝 Contributing

Contributions welcome! Please test changes thoroughly before submitting PRs.

---

_Enhanced Linuwu-Sense with Kernel 6.16+ Support and Settings Persistence_
_Developed for Acer Predator Helios Neo 14 (PHN14-51)_
_Compatible with CachyOS, Pop!\_OS, Ubuntu, Arch, and other modern Linux distributions_
_Tested on Kernel 6.16.7 (CachyOS) with full feature support_
