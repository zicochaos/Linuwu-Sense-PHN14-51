#!/bin/bash
#
# DKMS build wrapper script for Linuwu-Sense
# Auto-detects if kernel was built with LLVM/Clang (CachyOS)
#

KERNEL_SOURCE_DIR="$1"
MODULE_DIR="$2"

# Check if kernel was built with clang
if grep -q "CONFIG_CC_IS_CLANG=y" "${KERNEL_SOURCE_DIR}/.config" 2>/dev/null; then
    echo "Detected LLVM/Clang-built kernel, using LLVM=1"
    exec make LLVM=1 -C "${KERNEL_SOURCE_DIR}" M="${MODULE_DIR}" modules
else
    echo "Using standard GCC build"
    exec make -C "${KERNEL_SOURCE_DIR}" M="${MODULE_DIR}" modules
fi
