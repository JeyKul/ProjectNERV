TWOTHREE_TARGETS=""
TWOFOUR_TARGETS="a52sxq a51 a53x a73xq m52xq r8q r9q r9q2"

if echo "$TWOTHREE_TARGETS" | grep -q -w "$TARGET_CODENAME"; then
    cp -a --preserve=all "$SRC_DIR/unica/mods/bootanim/2340x1080/"* "$WORK_DIR/system/system/media"
elif echo "$TWOFOUR_TARGETS" | grep -q -w "$TARGET_CODENAME"; then
    cp -a --preserve=all "$SRC_DIR/unica/mods/bootanim/2400x1080/"* "$WORK_DIR/system/system/media"
else
    echo "Unknown boot animation resolution for \"$TARGET_CODENAME\""
fi

LOG_STEP_IN "- Adding S25 Sounds"
DELETE_FROM_WORK_DIR "system" "system/media/audio"
ADD_TO_WORK_DIR "pa1qxx" "system" "system/media/audio"
SET_PROP "vendor" "ro.config.ringtone" "ACH_Galaxy_Bells.ogg"
SET_PROP "vendor" "ro.config.notification_sound" "ACH_Brightline.ogg"
SET_PROP "vendor" "ro.config.alarm_alert" "ACH_Morning_Xylophone.ogg"
SET_PROP "vendor" "ro.config.media_sound" "Media_preview_Touch_the_light.ogg"
SET_PROP "vendor" "ro.config.ringtone_2" "ACH_Atomic_Bell.ogg"
SET_PROP "vendor" "ro.config.notification_sound_2" "ACH_Three_Star.ogg" 
LOG_STEP_OUT

