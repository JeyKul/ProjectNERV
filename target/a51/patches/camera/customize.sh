LOG_STEP_IN "- Fixing AI Photo Editor"
cp -a --preserve=all \
    "$WORK_DIR/system/system/cameradata/portrait_data/single_bokeh_feature.json" \
    "$WORK_DIR/system/system/cameradata/portrait_data/nexus_bokeh_feature.json"
SET_METADATA "system" "system/cameradata/portrait_data/nexus_bokeh_feature.json" 0 0 644 "u:object_r:system_file:s0"
sed -i "s/MODEL_TYPE_INSTANCE_CAPTURE/MODEL_TYPE_OBJ_INSTANCE_CAPTURE/g" \
    "$WORK_DIR/system/system/cameradata/portrait_data/single_bokeh_feature.json"
sed -i \
    's/system\/cameradata\/portrait_data\/single_bokeh_feature.json/system\/cameradata\/portrait_data\/nexus_bokeh_feature.json\x00/g' \
    "$WORK_DIR/system/system/lib64/libPortraitSolution.camera.samsung.so"

LOG_STEP_OUT
