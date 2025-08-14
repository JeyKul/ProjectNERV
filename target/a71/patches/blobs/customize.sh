echo "Applying Legacy stack"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/apex/com.android.runtime.apex" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/apex/com.android.i18n.apex" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/bin/bootstrap" 0 2000 751 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/bin/insthk" 0 2000 755 "u:object_r:insthk_exec:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/bin/linker" 0 2000 755 "u:object_r:system_linker_exec:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/bin/linker_asan" 0 2000 755 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/bin/remotedisplay" 0 2000 755 "u:object_r:remotedisplay_exec:s0"
ADD_TO_WORK_DIR "r9qxxx" "system" "system/lib" 0 0 755 "u:object_r:system_lib_file:s0"

cp -a --preserve=all "$SRC_DIR/prebuilts/samsung/r9qxxx/system/system_ext/lib" "$WORK_DIR/system/system/system_ext"
cat "$SRC_DIR/prebuilts/samsung/r9qxxx/fs_config-system" | grep -F "system/system_ext/lib" >> "$WORK_DIR/configs/fs_config-system"
cat "$SRC_DIR/prebuilts/samsung/r9qxxx/file_context-system" | grep -F "system/system_ext/lib" >> "$WORK_DIR/configs/file_context-system"
echo "system/system_ext/lib 0 0 755 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-system"
echo "/system/system_ext/lib u:object_r:system_lib_file:s0" >> "$WORK_DIR/configs/file_context-system"

ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/libSlowShutter_jni.media.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib64/libSlowShutter_jni.media.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib64/libsamsung_videoengine_9_0.so" 0 0 644 "u:object_r:system_lib_file:s0"

LOG_STEP_IN "- Add a73 WFD blobs"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhdcp_client_aidl.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.hdcp.wifidisplay-V2-ndk.so"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/bin/insthk" 0 2000 755 "u:object_r:insthk_exec:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/bin/remotedisplay" 0 2000 755 "u:object_r:remotedisplay_exec:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libhdcp2.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libremotedisplay.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libremotedisplay_wfd.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libremotedisplayservice.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libsecuibc.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libstagefright_hdcp.so" 0 0 644 "u:object_r:system_lib_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Add a73 wpa_supplicant"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "bin/hw/wpa_supplicant"
LOG_STEP_OUT

LOG_STEP_IN "- Add stock SoundBooster libs"
DELETE_FROM_WORK_DIR "system" "system/lib/lib_SoundBooster_ver1100.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundBooster_ver1100.so"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/lib_SoundBooster_ver1050.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib64/lib_SoundBooster_ver1050.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Fix MIDAS"
DELETE_FROM_WORK_DIR "vendor" "etc/midas"
DELETE_FROM_WORK_DIR "vendor" "etc/VslMesDetector"
ADD_TO_WORK_DIR "a52qnsxx" "vendor" "etc/midas" 0 2000 755 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "vendor" "etc/VslMesDetector" 0 2000 755 "u:object_r:vendor_configs_file:s0"
sed -i "s/ro.product.device/ro.product.vendor.device/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"
LOG_STEP_OUT

LOG_STEP_IN "- Fix RIL"
sed -i "s/1.4::IRadio/1.5::IRadio/g" "$WORK_DIR/vendor/etc/vintf/manifest.xml"
LOG_STEP_OUT

LOG_STEP_IN "- Fix face unlock"
DELETE_FROM_WORK_DIR "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@2.0-service"
DELETE_FROM_WORK_DIR "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@2.0-service.rc"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@3.0-service"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@3.0-service.rc"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib/vendor.samsung.hardware.biometrics.face@2.0.so"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib/vendor.samsung.hardware.biometrics.face@3.0.so"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib64/vendor.samsung.hardware.biometrics.face@2.0.so"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib64/vendor.samsung.hardware.biometrics.face@3.0.so"
LOG_STEP_OUT

LOG_STEP_IN "- Fixing autobrightness"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "bin/hw/vendor.samsung.hardware.light-service"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib64/android.hardware.light-V1-ndk_platform.so"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib64/vendor.samsung.hardware.light-V1-ndk_platform.so"
LOG_STEP_OUT

LOG_STEP_IN "- Add stock rscmgr.rc"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/init/rscmgr.rc" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Add stock CameraLightSensor app"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/etc/permissions/privapp-permissions-com.samsung.adaptivebrightnessgo.cameralightsensor.xml" \
    0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/priv-app/CameraLightSensor/CameraLightSensor.apk" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Add stock FM Radio app"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/etc/permissions/privapp-permissions-com.sec.android.app.fm.xml" \
    0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/etc/sysconfig/preinstalled-packages-com.sec.android.app.fm.xml" \
    0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/priv-app/HybridRadio/HybridRadio.apk" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/libfmradio_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib64/libfmradio_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "lib/fm_helium.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "lib/libbeluga.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "lib/libfm-hci.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "lib/vendor.qti.hardware.fm@1.0.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "lib64/fm_helium.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "lib64/libbeluga.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "lib64/libfm-hci.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "lib64/vendor.qti.hardware.fm@1.0.so" 0 0 644 "u:object_r:system_lib_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Add A73 vintf manifest"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/etc/vintf/manifest.xml" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Add stock system features"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.samsung.feature.audio_fast_listenback.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.samsung.feature.audio_listenback.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.cover.clearcameraviewcover.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.cover.flip.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.nsflp_level_601.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.pocketsensitivitymode_level1.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.sensorhub_level29.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.wirelesscharger_authentication.xml"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.minisviewwalletcover.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.nsflp_level_600.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.pocketmode_level6.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.sensorhub_level34.xml" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Add stock TUI app"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/etc/sysconfig/preinstalled-packages-com.qualcomm.qti.services.secureui.xml" \
    0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system_ext" "app/com.qualcomm.qti.services.secureui/com.qualcomm.qti.services.secureui.apk" \
    0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Nuking NFC"
DELETE_FROM_WORK_DIR "vendor" "etc/init/nxp.android.hardware.nfc@1.1-service.rc"
DELETE_FROM_WORK_DIR "odm" "etc/vintf"
DELETE_FROM_WORK_DIR "odm" "etc/permissions"
LOG_STEP_OUT
