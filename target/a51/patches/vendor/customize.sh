LOG_STEP_IN "- Enabling Vulkan"
SET_PROP "vendor" "ro.hwui.use_vulkan" "true"
SET_PROP "vendor" "debug.hwui.renderer" "skiavk"
LOG_STEP_OUT

LOG_STEP_IN "- Setting ro.hardware.egl to mali"
SET_PROP "vendor" "ro.hardware.egl" "mali"
LOG_STEP_OUT

LOG_STEP_IN "- Removing NFC"
DELETE_FROM_WORK_DIR "vendor" "etc/init/nxp.android.hardware.nfc@1.1-service.rc"
DELETE_FROM_WORK_DIR "odm" "etc/vintf"
DELETE_FROM_WORK_DIR "odm" "etc/permissions"
LOG_STEP_OUT
