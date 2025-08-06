# 🎮 Predator Control Center

Simple, unified control for Acer Predator laptops on Linux.

## 🚀 Quick Start

```bash
# Interactive menu
./predator

# Quick presets
./predator gaming    # Gaming mode
./predator silent    # Quiet mode
./predator extreme   # Maximum performance

# Check status
./predator status
```

## 📋 Available Presets

| Preset | Power | Fans | Battery | Keyboard | Use Case |
|--------|-------|------|---------|----------|----------|
| **Silent** | Quiet (60W) | Auto | 80% limit | Dim white | Library/night work |
| **Work** | Balanced (80W) | Auto | 80% limit | Warm white | Office productivity |
| **Gaming** | Performance (100W) | 60/70% | 100% | Gaming RGB | Gaming sessions |
| **Extreme** | Turbo (125W) | Maximum | 100% | Fire effect | Benchmarks/rendering |
| **Travel** | Quiet (60W) | Auto | 100% | Off | Battery saving |
| **Movie** | Quiet (60W) | Auto | 80% limit | Ocean (dim) | Media consumption |
| **Coding** | Balanced (80W) | Auto | 80% limit | F-keys highlight | Development |
| **Creative** | Performance (100W) | 50/60% | 80% limit | Rainbow | Content creation |

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
- `vaporwave` - Pink and purple
- `nordic` - Nord theme colors
- `arctic` - Ice blues
- `galaxy` - Deep purples
- `toxic` - Neon greens
- `cherry` - Cherry blossom pink
- `halloween` - Orange and black
- `matrix` - Matrix greens
- `stealth` - Dark grays
- `miami` - Miami vice colors

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
./predator rgb static ff0000   # Red static
./predator rgb wave            # Wave effect
./predator rgb profile-fire    # Fire profile
./predator rgb off             # Turn off

# Battery management
./predator battery enable   # 80% limit
./predator battery disable  # 100% charge
```

### Individual Scripts
The system also includes individual control scripts:
- `predator-profile` - Power profile control
- `predator-fan` - Fan speed control
- `predator-keyboard` - RGB keyboard control
- `predator-battery` - Battery management
- `predator-preset` - Combined presets

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

## 🎯 Tips

1. **Quick Access**: Add to PATH or create alias:
   ```bash
   alias predator='/path/to/predator'
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
   predator travel
   ```

## ⚠️ Notes

- Power limits are hardware-enforced via WMI
- Fan speeds are percentages (0-100)
- Battery limiter helps extend battery lifespan
- RGB effects may impact battery slightly
- Some features require kernel module support

## 🐛 Troubleshooting

If commands don't work:
1. Check module is loaded: `lsmod | grep linuwu_sense`
2. Check sysfs exists: `ls /sys/devices/platform/acer-wmi/`
3. Run with sudo if permission denied
4. Check individual scripts are executable

---

*Created for Acer Predator PHN14-51 with Linuwu-Sense v6.13*