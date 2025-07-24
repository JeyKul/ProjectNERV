SKIPUNZIP=1

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "etc/fstab.qcom"

sed -i '/^\(product\|vendor\|odm\)[[:space:]]\+\/\(product\|vendor\|odm\)[[:space:]]\+ext4/ {
  p
  s/ext4/erofs/
}' $WORK_DIR/vendor/etc/fstab.qcom

sed -i 's/fileencryption=ice/fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized/g' $WORK_DIR/vendor/etc/fstab.qcom

echo "Remove DualDAR mount points"
sed -i "/keydata/d" "$WORK_DIR/vendor/etc/fstab.qcom"
sed -i "/keyrefuge/d" "$WORK_DIR/vendor/etc/fstab.qcom"