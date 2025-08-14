CURR_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

LOG_STEP_IN "Copying boot.img and dtbo.img"
cp $CURR_DIR/kernel/boot.img $WORK_DIR/kernel/boot.img
cp $CURR_DIR/kernel/dtbo.img $WORK_DIR/kernel/dtbo.img
LOG_STEP_OUT
