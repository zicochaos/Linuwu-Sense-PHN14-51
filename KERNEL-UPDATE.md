# 🔄 Kernel Update Automation Script

The `kernel-update.sh` script automatically handles kernel updates by detecting changes, installing headers, rebuilding the module, and loading it.

## Features

- **Automatic Detection**: Detects when module needs rebuilding after kernel update
- **Distribution Support**: Works with CachyOS, Ubuntu, Arch, Fedora, openSUSE, and more
- **Header Installation**: Automatically installs required kernel headers
- **Smart Building**: Uses LLVM for CachyOS, GCC for others
- **Backup System**: Creates backups before updates
- **Settings Restoration**: Restores your saved settings after update
- **Error Recovery**: Comprehensive error handling and logging

## Usage

### Basic Usage
```bash
# Run after kernel update
./kernel-update.sh

# Force rebuild even if module seems OK
./kernel-update.sh --force

# Show detailed output
./kernel-update.sh --verbose

# Show help
./kernel-update.sh --help
```

### What It Does

1. **Checks Module Status**
   - Detects current kernel version
   - Checks if module is loaded
   - Verifies if module exists for current kernel

2. **Installs Headers** (if needed)
   - Detects your distribution
   - Installs appropriate kernel headers package
   - Verifies installation

3. **Backs Up Current Module**
   - Saves working module before rebuild
   - Stored in `backups/` directory

4. **Builds Module**
   - Uses LLVM for CachyOS
   - Uses GCC for other distributions
   - Logs build output

5. **Installs & Loads Module**
   - Removes conflicting modules
   - Installs to system directories
   - Loads module
   - Configures auto-load at boot

6. **Verifies Functionality**
   - Checks sysfs interfaces
   - Tests control scripts
   - Restores saved settings

## Automatic Updates

### Enable Auto-Updates
The script can set up automatic module updates after kernel upgrades:

```bash
# Run once to enable
./kernel-update.sh
# Answer 'y' when asked about automatic updates
```

This creates:
- Systemd service for automatic updates
- Pacman hook (Arch/CachyOS) that triggers on kernel updates

### Manual Trigger
If auto-update is enabled, you can manually trigger it:
```bash
sudo systemctl start linuwu-sense-kernel-update.service
```

### Check Auto-Update Status
```bash
systemctl status linuwu-sense-kernel-update.service
```

## Supported Distributions

| Distribution | Headers Package | Compiler |
|-------------|----------------|----------|
| CachyOS | linux-cachyos-headers | LLVM/Clang |
| Ubuntu/Pop!_OS | linux-headers-$(uname -r) | GCC |
| Arch/Manjaro | linux-headers | GCC |
| Fedora | kernel-devel-$(uname -r) | GCC |
| openSUSE | kernel-devel | GCC |

## Logs and Backups

- **Log File**: `kernel-update.log`
- **Build Log**: `kernel-update.log.build`
- **Backups**: `backups/` directory

## Troubleshooting

### Script Fails to Build Module
```bash
# Check build log
cat kernel-update.log.build

# Try verbose mode
./kernel-update.sh --verbose --force
```

### Module Doesn't Load
```bash
# Check kernel messages
dmesg | tail -20

# Try manual load
sudo insmod src/linuwu_sense.ko
```

### Headers Not Found
```bash
# Manually install headers
# CachyOS
sudo pacman -S linux-cachyos-headers

# Ubuntu
sudo apt install linux-headers-$(uname -r)
```

### Wrong Compiler Used
```bash
# Force LLVM for CachyOS
LLVM=1 ./kernel-update.sh --force

# Force GCC for others
CC=gcc ./kernel-update.sh --force
```

## Examples

### After System Update
```bash
# After pacman -Syu or apt upgrade
./kernel-update.sh

# Output:
╔═══════════════════════════════════════════════════╗
║     Kernel Update Compatibility Script           ║
║     Linuwu-Sense Module Manager                  ║
╚═══════════════════════════════════════════════════╝

━━━ Checking Module Status ━━━
Current kernel: 6.16.9-1-cachyos
○ Module not found for current kernel
! Module needs to be built for kernel 6.16.9-1-cachyos

━━━ Module Update Required ━━━
Installing kernel headers...
Building module...
✓ Module built successfully
✓ Module loaded successfully
✓ Settings restored
```

### Regular Check
```bash
# Check if module is working
./kernel-update.sh

# Output:
✓ Module is currently loaded
✓ Module exists for current kernel
✓ Module is working correctly
✓ No update needed for kernel 6.16.7-2-cachyos
```

## Integration with System

### Pacman Hook (Arch/CachyOS)
Located at `/etc/pacman.d/hooks/linuwu-sense.hook`
Triggers automatically after kernel updates

### Systemd Service
Located at `/etc/systemd/system/linuwu-sense-kernel-update.service`
Runs the update script when triggered

### Manual Run
Can always be run manually after kernel updates

## Safety Features

- **Backups**: Previous working modules are backed up
- **Verification**: Each step is verified before proceeding
- **Logging**: Complete logs for troubleshooting
- **Fallback**: Direct insmod if modprobe fails
- **Recovery**: Can restore from backups if needed

---

*This script ensures your Predator Control System continues working seamlessly across kernel updates!*