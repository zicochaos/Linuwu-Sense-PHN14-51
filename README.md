# 🎮 Linuwu-Sense for Acer Predator Helios Neo 14 (PHN14-51)

Unofficial Linux Kernel Module for Acer Gaming Laptops with **Unified Predator Control Center**

**Branch**: `predator-control-system` (Based on v6.13 + Enhanced Control System)  
**Compatibility**: Pop!_OS 22.04, Kernel 6.12+, and other modern Linux distributions

## ✨ Features

- **🎯 Unified Control Center** - Simple `predator` command for all features
- **⚡ Power Profiles** - Quiet (60W), Balanced (80W), Performance (100W), Turbo (125W)
- **🌈 RGB Keyboard Control** - 20+ profiles, effects, brightness control, 4-zone support
- **🌀 Fan Control** - Auto, custom, and maximum speeds for CPU/GPU
- **🔋 Battery Management** - 80% charge limiter, calibration support
- **🎮 Quick Presets** - Gaming, Silent, Work, Extreme, Travel, and more

## 📦 What You Get

This branch (`predator-control-system`) includes:
- ✅ **Linuwu-Sense v6.13** - Full kernel module with all hardware support
- ✅ **Predator Control Center** - User-friendly unified control system
- ✅ **Enhanced Scripts** - Battery, fan, RGB keyboard management
- ✅ **20+ RGB Profiles** - Gaming and aesthetic keyboard themes
- ✅ **8 Quick Presets** - One-command system configurations

## 🚀 Quick Start

### Installation

```bash
# Check kernel version
uname -r

# Install Linux headers for your distribution:

# Ubuntu/Debian/Pop!_OS
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r) dkms git

# Fedora
sudo dnf install kernel-devel kernel-headers gcc make git

# Arch Linux/Manjaro
sudo pacman -S linux-headers base-devel git

# openSUSE
sudo zypper install kernel-devel gcc make git

# Clone and install
git clone https://github.com/zicochaos/Linuwu-Sense-PHN14-51.git
cd Linuwu-Sense-PHN14-51

# IMPORTANT: Use the enhanced branch (includes v6.13 + Control Center)
git checkout predator-control-system

# Build and install the kernel module
make
sudo make install
```

### Using the Predator Control Center

```bash
# Interactive menu (recommended)
./predator

# Quick presets
./predator gaming    # Gaming mode: Performance + RGB + Custom fans
./predator silent    # Silent mode: Quiet + Dim keyboard + Auto fans
./predator extreme   # Maximum everything!

# Check status
./predator status
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

| Preset | Power | Fans | Battery | RGB | Use Case |
|--------|-------|------|---------|-----|----------|
| **Silent** | 60W | Auto | 80% limit | Dim white (20%) | Library/night |
| **Work** | 80W | Auto | 80% limit | Warm white (70%) | Productivity |
| **Gaming** | 100W | 60/70% | 100% | Gaming RGB | Gaming sessions |
| **Extreme** | 125W | Max | 100% | Fire effect | Benchmarks |
| **Travel** | 60W | Auto | 100% | Off | Battery saving |
| **Movie** | 60W | Auto | 80% limit | Ocean (30%) | Media |
| **Coding** | 80W | Auto | 80% limit | F-keys (60%) | Development |
| **Creative** | 100W | 50/60% | 80% limit | Rainbow | Content creation |

## 💻 Command Line Usage

### Power Control
```bash
./predator power quiet       # 60W
./predator power balanced    # 80W
./predator power performance # 100W
./predator power turbo       # 125W
```

### RGB Keyboard
```bash
./predator rgb static ff0000      # Red static
./predator rgb wave               # Wave effect
./predator rgb profile-cyberpunk  # Cyberpunk theme
./predator rgb brightness 50      # 50% brightness
./predator rgb off                # Turn off
```

### Fan Control
```bash
./predator fan auto           # Automatic
./predator fan max            # Maximum speed
./predator fan custom 60 70   # CPU 60%, GPU 70%
```

### Battery Management
```bash
./predator battery enable    # 80% charge limit
./predator battery disable   # 100% charge
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
- **Pop!_OS** 22.04 LTS
- **Ubuntu** 22.04/24.04 LTS
- **Debian** 12 (Bookworm)
- **Arch Linux** (Rolling)
- **Manjaro** (Latest)
- **Fedora** 39/40
- **openSUSE** Tumbleweed

### Kernel Support
- Tested: 6.12, 6.13 (including zen)
- Minimum: 5.15+ (with DKMS)
- Recommended: 6.0+

## 🐛 Troubleshooting

1. **Module won't load**: Check `dmesg | grep linuwu` for errors
2. **No predator_sense directory**: Ensure your laptop model is supported
3. **Permission denied**: Use `sudo` for sysfs writes
4. **RGB not working**: Check if you have 4-zone keyboard support

## 📄 Documentation

See [PREDATOR_CONTROL.md](PREDATOR_CONTROL.md) for detailed usage guide.

## 🤝 Contributing

Contributions welcome! Please test changes thoroughly before submitting PRs.

---

*Based on Linuwu-Sense v6.13 with enhanced Predator Control Center*  
*Developed for Acer Predator Helios Neo 14 (PHN14-51)*  
*Compatible with Pop!_OS 22.04, Kernel 6.12+*