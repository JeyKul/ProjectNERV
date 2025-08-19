rm -f "$WORK_DIR/kernel/"*

LOG "- Replacing kernel binaries with Rio (Vanilla)"
cp -fa "$SRC_DIR/prebuilts/kernels/a73xq/"* "$WORK_DIR/kernel"

LOG_STEP_IN "- Removing kernel modules in vendor"
DELETE_FROM_WORK_DIR "vendor" "lib/modules"
LOG_STEP_OUT
