SKIPUNZIP=1

rm -f "$WORK_DIR/kernel/"*.img

LOG "- Replacing kernel binaries with Rio (Vanilla)"
cp -a "$SRC_DIR/prebuilts/kernels/a73xq/"* "$WORK_DIR/kernel"

LOG_STEP_IN "- Removing kernel modules in vendor"
DELETE_FROM_WORK_DIR "vendor" "lib/modules"
LOG_STEP_OUT
