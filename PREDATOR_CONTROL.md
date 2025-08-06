# 🎮 Predator Control Center

Simple, unified control for Acer Predator laptops on Linux.

## 🚀 Quick Start

```bash
# Interactive menu (recommended)
./predator

# Quick presets
./predator gaming    # Gaming mode
./predator silent    # Quiet mode
./predator extreme   # Maximum performance

# Check status
./predator status
```

## 🎹 Interactive Menu Controls

When running `./predator`:
- **1-8**: Quick presets (Silent, Work, Gaming, etc.)
- **0**: Turn keyboard backlight off
- **+**: Increase keyboard brightness by 20%
- **-**: Decrease keyboard brightness by 20%
- **s**: Show current system status
- **a**: Advanced settings menu
- **q**: Quit

## 📋 Available Presets

| Preset | Power | Fans | Battery | Keyboard | Brightness | Use Case |
|--------|-------|------|---------|----------|------------|----------|
| **Silent** | Quiet (60W) | Auto | 80% limit | White | 20% | Library/night work |
| **Work** | Balanced (80W) | Auto | 80% limit | Warm white | 70% | Office productivity |
| **Gaming** | Performance (100W) | 60/70% | 100% | Gaming RGB | 100% | Gaming sessions |
| **Extreme** | Turbo (125W) | Maximum | 100% | Fire effect | 100% | Benchmarks/rendering |
| **Travel** | Quiet (60W) | Auto | 100% | Off | 0% | Battery saving |
| **Movie** | Quiet (60W) | Auto | 80% limit | Ocean | 30% | Media consumption |
| **Coding** | Balanced (80W) | Auto | 80% limit | F-keys highlight | 60% | Development |
| **Creative** | Performance (100W) | 50/60% | 80% limit | Rainbow | 100% | Content creation |

## 🎨 RGB Keyboard Profiles

### Gaming Profiles
- `gaming` - Red WASD zone, blue others
- `fps` - Highlight movement keys
- `moba` - Highlight QWER abilities
- `racing` - Arrow keys emphasis

### Aesthetic Profiles
- `rainbow` - Classic rainbow
- `fire` - Fire gradient
- `ocean` - Ocean blues
- `forest` - Forest greens
- `sunset` - Sunset colors
- `cyberpunk` - Cyan and magenta
- `vaporwave` - Pink and purple (80s aesthetic)
- `nordic` - Nord theme colors (muted blues)
- `arctic` - Ice blues
- `galaxy` - Deep purples
- `toxic` - Neon greens
- `cherry` - Cherry blossom pink
- `halloween` - Orange and black
- `matrix` - Matrix greens (gradient)
- `stealth` - Dark grays (50% brightness)
- `miami` - Miami vice colors
- `monochrome` - White to gray gradient (70% brightness)
- `minimal` - Dim white (30% brightness)

## 💻 Command Line Usage

### Direct Control
```bash
# Power profiles
./predator power quiet|balanced|performance|turbo

# Fan control
./predator fan auto
./predator fan max
./predator fan custom 50 60  # CPU 50%, GPU 60%

# RGB keyboard
./predator rgb static ff0000   # Red static color
./predator rgb wave            # Wave effect
./predator rgb profile-fire    # Fire profile
./predator rgb brightness 50   # Set brightness to 50%
./predator rgb off             # Turn off backlight

# Battery management
./predator battery enable   # 80% limit
./predator battery disable  # 100% charge
```

### Individual Scripts
The system also includes individual control scripts:
- `predator-profile` - Power profile control
- `predator-fan` - Fan speed control
- `predator-keyboard` - RGB keyboard control with brightness
- `predator-battery` - Battery management
- `predator-preset` - Combined presets

### Keyboard Brightness Control
```bash
# Set specific brightness
./predator rgb brightness 75         # 75% brightness
./predator-keyboard brightness 50    # 50% brightness

# Turn off/on
./predator rgb off                   # Turn off (0%)
./predator rgb brightness 100        # Full brightness

# Interactive menu shortcuts
# When in ./predator menu:
# Press '0' - Turn off backlight
# Press '+' - Increase by 20%
# Press '-' - Decrease by 20%
```

## 🔧 Requirements

- Acer Predator laptop (tested on PHN14-51)
- Linuwu-Sense kernel module installed
- Root/sudo access for sysfs writes

## 📁 File Structure

```
/sys/devices/platform/acer-wmi/
├── predator_sense/
│   ├── power_profile      # 0=Quiet, 1=Balanced, 2=Performance, 3=Turbo
│   ├── fan_speed          # CPU,GPU percentages
│   └── battery_limiter    # 0=disabled, 1=enabled (80%)
└── four_zoned_kb/
    ├── four_zone_mode     # Effects and settings
    └── per_zone_mode      # Per-zone colors
```

## 🎯 Tips & Tricks

1. **Quick Access**: Add to PATH or create alias:
   ```bash
   alias predator='/path/to/predator'
   alias pgaming='predator gaming'
   alias psilent='predator silent'
   ```

2. **Startup Preset**: Add to `.bashrc` or `.profile`:
   ```bash
   predator work  # Default to work mode
   ```

3. **Gaming Session**: Quick gaming setup:
   ```bash
   predator gaming && steam
   ```

4. **Battery Life**: For maximum battery:
   ```bash
   predator travel  # Turns off keyboard, quiet mode
   ```

5. **Night Mode**: Reduce eye strain:
   ```bash
   predator silent  # 20% keyboard brightness
   # Or manually:
   predator rgb brightness 10
   ```

6. **Quick Brightness Adjust**:
   - Run `./predator` then use `+`/`-` keys
   - Or direct: `./predator rgb brightness 50`

7. **Custom Gaming Profile**:
   ```bash
   # Set your favorite gaming colors
   predator rgb profile-cyberpunk
   predator power turbo
   predator fan custom 70 80
   ```

## ⚠️ Notes

- Power limits are hardware-enforced via WMI
- Fan speeds are percentages (0-100)
- Battery limiter helps extend battery lifespan
- RGB brightness affects battery life (lower = longer battery)
- Keyboard brightness is saved per-mode (effects vs zones)
- Some features require kernel module support
- Brightness changes are instant, no reboot needed

## 🐛 Troubleshooting

If commands don't work:
1. Check module is loaded: `lsmod | grep linuwu_sense`
2. Check sysfs exists: `ls /sys/devices/platform/acer-wmi/`
3. Run with sudo if permission denied
4. Check individual scripts are executable

---

*Created for Acer Predator PHN14-51 with Linuwu-Sense v6.13*