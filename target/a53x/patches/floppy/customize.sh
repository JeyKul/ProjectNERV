LATEST=$(curl -s https://api.github.com/repos/FlopKernel-Series/flop_s5e8825_kernel/releases/latest)
FLOPPY_TAR=$(echo "$LATEST" |
    jq -r '.assets[] | select(.name | test("OneUI.*Vanilla-exynos1280.*\\.tar$")) | .browser_download_url')

[ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

LOG "- Downloading $(basename "$FLOPPY_TAR")"
DOWNLOAD_FILE "$FLOPPY_TAR" "$TMP_DIR/floppy.tar"

LOG "- Extracting kernel binaries"
EVAL "tar xvf \"$TMP_DIR/floppy.tar\" -C \"$TMP_DIR\""
EVAL "lz4 -d \"$TMP_DIR/boot.img.lz4\" \"$TMP_DIR/boot.img\""
EVAL "lz4 -d \"$TMP_DIR/vendor_boot.img.lz4\" \"$TMP_DIR/vendor_boot.img\""

LOG_STEP_IN "- Replacing kernel binaries"
for i in "boot" "vendor_boot"; do
    (
        [ -f "$WORK_DIR/kernel/$i.img" ] && rm -rf "$WORK_DIR/kernel/$i.img"
        mv -f "$TMP_DIR/$i.img" "$WORK_DIR/kernel/$i.img"
    ) &
done
LOG_STEP_OUT

rm -rf "$TMP_DIR"
