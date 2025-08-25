TARGET_FIRMWARE_PATH="$FW_DIR/$(echo -n "$TARGET_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"


# Fix portrait mode
if [[ -f "$TARGET_FIRMWARE_PATH/vendor/lib64/libDualCamBokehCapture.camera.samsung.so" ]]; then
    if grep -q "ro.build.flavor" "$TARGET_FIRMWARE_PATH/vendor/lib64/libDualCamBokehCapture.camera.samsung.so"; then
        SET_PROP "system" "ro.build.flavor" "$(GET_PROP "$TARGET_FIRMWARE_PATH/system/system/build.prop" "ro.build.flavor")"
    elif grep -q "ro.product.name" "$TARGET_FIRMWARE_PATH/vendor/lib64/libDualCamBokehCapture.camera.samsung.so"; then
        sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib/libDualCamBokehCapture.camera.samsung.so" && \
            sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib/liblivefocus_capture_engine.so" && \
            sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib/liblivefocus_preview_engine.so" && \
            sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib64/libDualCamBokehCapture.camera.samsung.so" && \
            sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib64/liblivefocus_capture_engine.so" && \
            sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/vendor/lib64/liblivefocus_preview_engine.so"
        echo -e "\nro.unica.camera u:object_r:build_prop:s0 exact string" >> "$WORK_DIR/system/system/etc/selinux/plat_property_contexts"
        SET_PROP "system" "ro.unica.camera" "$(GET_PROP "$TARGET_FIRMWARE_PATH/system/system/build.prop" "ro.product.system.name")"
    fi
fi

# Enable camera cutout protection
if [[ "$SOURCE_SUPPORT_CUTOUT_PROTECTION" != "$TARGET_SUPPORT_CUTOUT_PROTECTION" ]]; then
    DECODE_APK "system_ext" "priv-app/SystemUI/SystemUI.apk"

    FTP="$APKTOOL_DIR/system_ext/priv-app/SystemUI/SystemUI.apk/res/values/bools.xml"
    R="\ \ \ \ <bool name=\"config_enableDisplayCutoutProtection\">$TARGET_SUPPORT_CUTOUT_PROTECTION</bool>"

    sed -i "$(sed -n "/config_enableDisplayCutoutProtection/=" "$FTP") c$R" "$FTP"
fi

# Set custom Display ID prop
SET_PROP "system" "ro.build.display.id" "Terracotta Rom | Based on UN1CA and Project NERV | $(echo -n ${ROM_VERSION} | cut -d "-" -f1)-${ROM_CODENAME} - ${TARGET_DEVICE} [$(GET_PROP "system" "ro.build.display.id")]"

# Crok's RAM Managment Fix
# https://github.com/crok/crokrammgmtfix/blob/master/service.sh#L27-L32
[ -f "$WORK_DIR/system/system/etc/init/ram_mgmt_fix.rc" ] && rm -f "$WORK_DIR/system/system/etc/init/ram_mgmt_fix.rc"
{
    echo "on post-fs-data"
    echo "    exec_background -- /system/bin/cmd device_config set_sync_disabled_for_tests persistent"
    echo "    exec_background -- /system/bin/cmd device_config put activity_manager max_cached_processes 256"
    echo "    exec_background -- /system/bin/cmd device_config put activity_manager max_phantom_processes 2147483647"
    echo "    exec_background -- /system/bin/cmd settings put global settings_enable_monitor_phantom_procs false"
    echo "    exec_background -- /system/bin/cmd device_config put activity_manager max_empty_time_millis 43200000"
    echo "    exec_background -- /system/bin/cmd"
} >> "$WORK_DIR/system/system/etc/init/ram_mgmt_fix.rc"
SET_METADATA "system" "system/etc/init/ram_mgmt_fix.rc" 0 0 644 "u:object_r:system_file:s0"

LOG_STEP_IN "- Fixing Edge lighting corner radius"
MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
SET_PROP "system" "ro.factory.model" "$MODEL"
LOG_STEP_OUT

LOG_STEP_IN "- Setting Floating Feature values for Now Brief"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_COMMON_CONFIG_AI_VERSION" "20251"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_PERSONALIZED_DATA_CORE" "TRUE"
LOG_STEP_OUT
