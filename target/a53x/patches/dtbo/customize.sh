EXTRACT() {
    local DTB="$TMP_DIR/dtb"
    local DTS="$TMP_DIR/dtsi"

    [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"
    
    mkdtboimg dump "$WORK_DIR/kernel/dtbo.img" -b "$DTB" &> /dev/null

    for i in $(seq 0 19); do
        fi="${DTB}.${i}"
        fo="${DTS}.${i}"
        if [ -f "$fi" ]; then
            dtc -I dtb -O dts "$fi" -o "$fo" &> /dev/null
            rm "$fi"
        else
            break
        fi
    done
}

APPLY_DTBO_PATCH() {
    local PATCH="$SRC_DIR/target/$TARGET_CODENAME/patches/dtbo/patches/$1"

    if [ ! -f "$PATCH" ]; then
        LOGE "File not found: ${PATCH//$SRC_DIR\//}"
        return 1
    fi

    LOG_STEP_IN "- Applying \"$(grep "^Subject:" "$PATCH" | sed "s/.*PATCH] //")\" to dtbo"
    EVAL "LC_ALL=C git apply --directory=\"$TMP_DIR\" --verbose --unsafe-paths \"$PATCH\"" || return 1
    LOG_STEP_OUT
}

CREATE_CFG() {
    {
        echo "a53x_eur_open_w00_r00.dtbo"
        echo "    custom0=0x00000000"
        echo "    custom1=0x00000000"
        echo ""
        echo "a53x_eur_open_w00_r01.dtbo"
        echo "    custom0=0x00000001"
        echo "    custom1=0x00000001"
        echo ""
        echo "a53x_eur_open_w00_r02.dtbo"
        echo "    custom0=0x00000002"
        echo "    custom1=0x00000004"
        echo ""
        echo "a53x_eur_open_w00_r05.dtbo"
        echo "    custom0=0x00000005"
        echo "    custom1=0x00000005"
        echo ""
        echo "a53x_eur_open_w00_r06.dtbo"
        echo "    custom0=0x00000006"
        echo "    custom1=0x00000020"
    } >> "$TMP_DIR/$TARGET_CODENAME.cfg"
}

PACK_TO_DTBO() {
    dtc -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r00.dtbo" "$TMP_DIR/dtsi.0" &> /dev/null
    dtc -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r01.dtbo" "$TMP_DIR/dtsi.1" &> /dev/null
    dtc -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r02.dtbo" "$TMP_DIR/dtsi.2" &> /dev/null
    dtc -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r05.dtbo" "$TMP_DIR/dtsi.3" &> /dev/null
    dtc -I dts -O dtb -o "$TMP_DIR/a53x_eur_open_w00_r06.dtbo" "$TMP_DIR/dtsi.4" &> /dev/null
}

PACK_TO_IMG() {
    mkdtboimg cfg_create "$TMP_DIR/dtbo.img" "$TMP_DIR/$TARGET_CODENAME.cfg" -d "$TMP_DIR" &> /dev/null
}

LOG_STEP_IN "- Extracting dtbo"
EXTRACT
LOG_STEP_OUT

APPLY_DTBO_PATCH "0001-Fix-Adaptive-Refresh-Rate-Color-Flickering.patch"

LOG_STEP_IN "- Repacking dtbo"
CREATE_CFG
PACK_TO_DTBO
PACK_TO_IMG
LOG_STEP_OUT

LOG_STEP_IN "- Copying new dtbo.img"
[ -f "$WORK_DIR/kernel/dtbo.img" ] && rm -rf "$WORK_DIR/kernel/dtbo.img"
cp -fa "$TMP_DIR/dtbo.img" "$WORK_DIR/kernel/dtbo.img"
rm -rf "$TMP_DIR"
LOG_STEP_OUT

