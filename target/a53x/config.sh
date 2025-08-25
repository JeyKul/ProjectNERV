#
# Copyright (C) 2025 Ksawlii
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

# Device configuration file for Galaxy A53 5G (a53x)
TARGET_NAME="Galaxy A53 5G"
TARGET_CODENAME="a53x"
TARGET_ASSERT_MODEL=("SM-A5360" "SM-A536B" "SM-A536E")
TARGET_FIRMWARE="SM-A536B/EUX/350498050045386"

# API
TARGET_API_LEVEL=35
TARGET_PRODUCT_FIRST_API_LEVEL=31
TARGET_VENDOR_API_LEVEL=31

# File System
TARGET_OS_FILE_SYSTEM="erofs"

# Single system image
TARGET_SINGLE_SYSTEM_IMAGE="essi"

# Super
TARGET_SUPER_PARTITION_SIZE=11744051200
TARGET_SUPER_GROUP_SIZE=11739856896
TARGET_HAS_SYSTEM_EXT="false"

# Features
# Audio
TARGET_AUDIO_SUPPORT_ACH_RINGTONE="false"
TARGET_AUDIO_SUPPORT_DUAL_SPEAKER="true"
TARGET_AUDIO_SUPPORT_VIRTUAL_VIBRATION="false"

# Camera
TARGET_HAS_MASS_CAMERA_APP="false"

# Display
TARGET_HAS_QHD_DISPLAY="false"
TARGET_AUTO_BRIGHTNESS_TYPE="5"

# DVFS/SSRM
TARGET_DVFS_CONFIG_NAME="dvfs_policy_s5e8825_xx"
TARGET_SSRM_CONFIG_NAME="siop_a53x_s5e8825"

# eSIM
TARGET_IS_ESIM_SUPPORTED="false"

# HFR
TARGET_HFR_MODE="2"
TARGET_HFR_DEFAULT_REFRESH_RATE="120"
TARGET_HFR_SUPPORTED_REFRESH_RATE="60,120"

# Fingerprint
TARGET_FP_SENSOR_CONFIG="optical"

# MDNIE
TARGET_HAS_HW_MDNIE="false"
TARGET_MDNIE_SUPPORTED_MODES="37905"
TARGET_MDNIE_WEAKNESS_SOLUTION_FUNCTION="0"

# Misc
TARGET_SUPPORT_CUTOUT_PROTECTION="true"
TARGET_MULTI_MIC_MANAGER_VERSION="07010"
