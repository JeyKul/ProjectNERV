LOG_STEP_IN "- Improving WiFi/Mobile Data speeds"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "app/ConnectivityUxOverlay" 0 0 755 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "app/NetworkStackOverlay" 0 0 755 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Fixing camera notch position"
FOLDER_LIST="
DisplayCutoutEmulationCorner
DisplayCutoutEmulationDouble
DisplayCutoutEmulationHole
DisplayCutoutEmulationTall
DisplayCutoutEmulationWaterfall
"

for folder in $FOLDER_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "overlay/$folder" 0 0 755 "u:object_r:system_file:s0"
done

LOG_STEP_OUT

SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_3D_SURFACE_TRANSITION_FLAG" "FALSE"

