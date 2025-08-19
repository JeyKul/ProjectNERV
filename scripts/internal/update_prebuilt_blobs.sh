#!/usr/bin/env bash
#
# Copyright (C) 2023 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# shellcheck disable=SC2001

set -Ee

source "$SRC_DIR/scripts/utils/module_utils.sh" || exit 1
source "$SRC_DIR/scripts/utils/log_utils.sh" || exit 1

# [
GET_LATEST_FIRMWARE()
{
    curl -s --retry 5 --retry-delay 5 "https://fota-cloud-dn.ospserver.net/firmware/$REGION/$MODEL/version.xml" \
        | grep latest | sed 's/^[^>]*>//' | sed 's/<.*//'
}
#]

if [[ "$#" != 1 ]]; then
    LOG "Usage: update_prebuilt_blobs <path>"
    exit 1
fi

if [[ ! -d "$SRC_DIR/$1" ]]; then
    ABORT "Folder not found: \"$SRC_DIR/$1\""
fi

MODULE="$SRC_DIR/$1"
BLOBS=""
FIRMWARE=""

if [ -d "$MODULE/system" ]; then
    BLOBS+="$(find "$MODULE/system" -type f)"
    BLOBS="${BLOBS//$MODULE/system}"
fi
if [ -d "$MODULE/product" ]; then
    [[ "$BLOBS" ]] && BLOBS+=$'\n'
    BLOBS+="$(find "$MODULE/product" -type f)"
    BLOBS="${BLOBS//$MODULE\//}"
fi
if [ -d "$MODULE/vendor" ]; then
    [[ "$BLOBS" ]] && BLOBS+=$'\n'
    BLOBS+="$(find "$MODULE/vendor" -type f)"
    BLOBS="${BLOBS//$MODULE\//}"
fi
if [ -d "$MODULE/system_ext" ]; then
    [[ "$BLOBS" ]] && BLOBS+=$'\n'
    BLOBS+="$(find "$MODULE/system_ext" -type f)"
    BLOBS="${BLOBS//$MODULE\//}"
fi

case "$1" in
    "prebuilts/samsung/a05snsdxx")
        FIRMWARE="SM-A057F/INS/356480620213714"
        ;;
    "prebuilts/samsung/a16xxx")
        FIRMWARE="SM-A166B/EUX/352907210202024"
        ;;        
    "prebuilts/samsung/a36xqnaxx")
        FIRMWARE="SM-A366E/INS/357178223702799"
        ;;
    "prebuilts/samsung/a52sxqxx")
        FIRMWARE="SM-A528B/BTU/352599501234566"
        ;;
    "prebuilts/samsung/a73xqxx")
        FIRMWARE="SM-A736B/XME/352828291234563"
        ;;
    "prebuilts/samsung/b0sxxx")
        FIRMWARE="SM-S908B/BTE/350048581234569"
        ;;
    "prebuilts/samsung/b5qxxx")
        FIRMWARE="SM-F731B/EUX/350929871234569"
        ;;
    "prebuilts/samsung/dm3qxxx")
        FIRMWARE="SM-S918B/EUX/350196551234562"
        ;;
    "prebuilts/samsung/gts9fexx")
        FIRMWARE="SM-X516B/EUX/354136921234567"
        ;;
    "prebuilts/samsung/gts9xxx")
        FIRMWARE="SM-X716B/EUX/353439961234567"
        ;;
    "prebuilts/samsung/pa1qxx")
        FIRMWARE="SM-S931B/EUX/350466671872843"
        ;;
    "prebuilts/samsung/r0qxxx")
        FIRMWARE="SM-S901E/INS/350999641234561"
        ;;
    "prebuilts/samsung/r0sxxx")
        FIRMWARE="SM-S901B/EUX/350020271234563"
        ;;
    "prebuilts/samsung/r9qxxx")
        FIRMWARE="SM-G990B/EUX/353718681234563"
        ;;
    "prebuilts/samsung/r11sxxx")
        FIRMWARE="SM-S711B/EUX/358615311234564"
        ;;
    *)
        echo "Firmware not set for path $1"
        exit 1
        ;;
esac

MODEL=$(echo -n "$FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$FIRMWARE" | cut -d "/" -f 2)

[[ -z "$(GET_LATEST_FIRMWARE)" ]] && exit 1
if [[ -f "$MODULE/.current" ]]; then
    if [[ "$(GET_LATEST_FIRMWARE)" == "$(cat "$MODULE/.current")" ]]; then
        LOG "- Nothing to do."
        exit 0
    fi
fi

LOG_STEP_IN "- Updating $MODULE blobs"

bash "$SRC_DIR/scripts/download_fw.sh" --ignore-target --ignore-source "$FIRMWARE"
bash "$SRC_DIR/scripts/extract_fw.sh" --ignore-target --ignore-source "$FIRMWARE"

for i in $BLOBS; do
    if [[ "$i" == *[0-9] ]]; then
        i="${i%.*}"
    fi
    OUT="$MODULE/${i//system\/system\///system/}"

    [[ -e "$FW_DIR/${MODEL}_${REGION}/$i" ]] || continue

    if [[ "$(wc -c "$FW_DIR/${MODEL}_${REGION}/$i" | cut -d " " -f 1)" -gt "52428800" ]]; then
        rm "$OUT."*
        EVAL "split -d -b 52428800 \"$FW_DIR/${MODEL}_${REGION}/$i\" \"$OUT.\""
    else
        cp -fa "$FW_DIR/${MODEL}_${REGION}/$i" "$OUT"
    fi
done

cp -fa "$FW_DIR/${MODEL}_${REGION}/.extracted" "$MODULE/.current"

LOG_STEP_OUT

exit 0
