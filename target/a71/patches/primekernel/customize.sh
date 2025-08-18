SKIPUNZIP=1

# [
KERNEL_REPO="https://github.com/pascua28/android_kernel_samsung_sm7150/releases/download/upstream"

REPLACE_KERNEL_BINARIES()
 {
     [ -f "$WORK_DIR/kernel/boot.img" ] && rm -rf "$WORK_DIR/kernel/boot.img"
     echo "Downloading boot.img"
     curl -L -s -o "$WORK_DIR/kernel/boot.img" "$KERNEL_REPO/boot.img"

     [ -f "$WORK_DIR/kernel/dtbo.img" ] && rm -rf "$WORK_DIR/kernel/dtbo.img"
     echo "Downloading dtbo.img"
     curl -L -s -o "$WORK_DIR/kernel/dtbo.img" "$KERNEL_REPO/dtbo.img"
 }
# ]

REPLACE_KERNEL_BINARIES
