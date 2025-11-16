# Linuwu-Sense PHN14-51 Fork

Enhanced Linux kernel module for Acer Predator PHN14-51 laptops with GPU power profile control.

## Features

- **GPU Power Profile Control**: Control NVIDIA GPU power limits (80W/100W/125W)
- **Predator Sense Integration**: Full support for Predator Sense features
- **Fan Speed Control**: Manual and automatic fan control
- **Battery Management**: Battery limiter and calibration
- **RGB Keyboard**: Four-zone RGB keyboard support
- **Thermal Profiles**: Quiet, Balanced, and Performance modes

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/Linuwu-Sense-PHN14-51.git
cd Linuwu-Sense-PHN14-51

# Run the installation script
./install-predator-sense.sh
```

### Usage

Control GPU power profiles:

```bash
# Set to Performance mode (125W GPU limit)
predator-profile performance

# Set to Balanced mode (100W GPU limit)
predator-profile balanced

# Set to Quiet mode (80W GPU limit)
predator-profile quiet

# Check current profile
predator-profile status
```

### Manual Control via Sysfs

```bash
# Set power profile directly (0=Quiet, 1=Balanced, 2=Performance)
echo 2 | sudo tee /sys/devices/platform/acer-wmi/predator_sense/power_profile

# Read current profile
cat /sys/devices/platform/acer-wmi/predator_sense/power_profile
```

## Power Profiles

| Profile         | GPU Power Limit | Use Case                          |
| --------------- | --------------- | --------------------------------- |
| Quiet (0)       | 80W             | Battery saving, light tasks       |
| Balanced (1)    | 100W            | General use, moderate gaming      |
| Performance (2) | 125W            | Maximum performance, heavy gaming |

## Other Predator Sense Features

### Fan Control

```bash
# Set fan speeds (CPU,GPU in percentage)
echo "50,70" | sudo tee /sys/devices/platform/acer-wmi/predator_sense/fan_speed
```

### Battery Limiter

```bash
# Enable battery charge limiter (80% max)
echo 1 | sudo tee /sys/devices/platform/acer-wmi/predator_sense/battery_limiter
```

### LCD Overdrive

```bash
# Enable LCD overdrive
echo 1 | sudo tee /sys/devices/platform/acer-wmi/predator_sense/lcd_override
```

## Building from Source

```bash
# Install dependencies
sudo apt install build-essential linux-headers-$(uname -r) gcc-12

# Build
make clean
make

# Install
sudo make install
```

## Troubleshooting

### Module not loading

```bash
# Check if module is loaded
lsmod | grep linuwu_sense

# Check kernel messages
sudo dmesg | grep linuwu_sense

# Manually load module
sudo modprobe linuwu_sense
```

### Power profile not working

```bash
# Verify sysfs interface exists
ls /sys/devices/platform/acer-wmi/predator_sense/

# Check WMI support
sudo dmesg | grep -i wmi
```

## System Requirements

- Acer Predator PHN14-51 laptop
- Linux kernel 5.15 or newer
- NVIDIA GPU with proprietary drivers
- Pop!\_OS 22.04 or compatible distribution

## Credits

Based on [Linuwu-Sense](https://github.com/0x7375646F/Linuwu-Sense) v6.13 by 0x7375646F

## License

GPL-2.0-or-later

## Disclaimer

This module modifies hardware power limits. Use at your own risk. Always monitor temperatures when using Performance mode.
