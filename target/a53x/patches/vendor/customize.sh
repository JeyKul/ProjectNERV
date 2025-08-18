SKIPUNZIP=1
TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"
TARGET_MODEL="$(echo "$TARGET_FIRMWARE" | cut -d'/' -f1)"

LOG_STEP_IN "- Adding support for other $TARGET_CODENAME models"

## Firmware
# Target Model
if [ ! -d "$WORK_DIR/vendor/firmware/$TARGET_MODEL" ]; then
    BLOBS=( "AP_AUDIO_SLSI" "APDV_AUDIO_SLSI" "calliope_sram" "mfc_fw" "os.checked" "NPU" "vts" )

    mkdir -p "$WORK_DIR/vendor/firmware/$TARGET_MODEL"
    for b in "${BLOBS[@]}"; do
        mv -f "$WORK_DIR/vendor/firmware/${b}.bin" "$WORK_DIR/vendor/firmware/$TARGET_MODEL/${b}.bin"
        touch "$WORK_DIR/vendor/firmware/${b}.bin"
    done
fi

# Other Models
cp -rfa "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/vendor/firmware" "$WORK_DIR/vendor"

## Init (init.a53x.unify.rc)
ADD_TO_WORK_DIR "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor" "vendor" "etc/init/init.${TARGET_CODENAME}.unify.rc" 0 0 644 "u:object_r:vendor_configs_file:s0"

## Tee
# Target Model
DELETE_FROM_WORK_DIR "vendor" "tee"
mkdir -p "$WORK_DIR/vendor/tee"
cp -rfa "$TARGET_FIRMWARE_PATH/vendor/tee" "$WORK_DIR/vendor/tee/$TARGET_MODEL"

# Other Models
cp -rfa "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/vendor/tee" "$WORK_DIR/vendor"

## Sepolicy
if ! grep -q "tee_file (dir (mounton" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
    echo "(allow init_31_0 tee_file (dir (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 tee_file (dir (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_fw_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_fw_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow init_31_0 vendor_npu_firmware_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
    echo "(allow priv_app_31_0 vendor_npu_firmware_file (file (getattr)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
fi

# file Context
cat "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/file_context-vendor" >> "$WORK_DIR/configs/file_context-vendor"

# fs Config
cat "$SRC_DIR/target/$TARGET_CODENAME/patches/vendor/fs_config-vendor" >> "$WORK_DIR/configs/fs_config-vendor"
LOG_STEP_OUT

