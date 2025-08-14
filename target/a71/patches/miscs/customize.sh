LOG_STEP_IN "- Fix up /product/etc/build.prop"
sed -i "/# Removed by /d" "$WORK_DIR/product/etc/build.prop" \
    && sed -i "s/#bluetooth./bluetooth./g" "$WORK_DIR/product/etc/build.prop" \
    && sed -i "s/?=/=/g" "$WORK_DIR/product/etc/build.prop" \
    && sed -i "$(sed -n "/provisioning.hostname/=" "$WORK_DIR/product/etc/build.prop" | sed "2p;d")d" "$WORK_DIR/product/etc/build.prop"
LOG_STEP_OUT

LOG_STEP_IN "- Add display refresh rate props"
sed -i \
    "/max_frame_buffer_acquired_buffers/a ro.surface_flinger.enable_frame_rate_override=false\nro.surface_flinger.use_content_detection_for_refresh_rate=false" \
    "$WORK_DIR/vendor/default.prop"
LOG_STEP_OUT
