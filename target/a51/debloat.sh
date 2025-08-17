#
# Copyright (C) 2025 Fede2782
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

# Debloat list for Galaxy A51 (a51)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# GameDriver
SYSTEM_DEBLOAT+="
system/priv-app/DevGPUDriver-EX2200
system/priv-app/GameDriver-EX2200
"

# system_ext clean-up
SYSTEM_DEBLOAT+="
system/etc/permissions/org.carconnectivity.android.digitalkey.rangingintent.xml
system/etc/permissions/org.carconnectivity.android.digitalkey.secureelement.xml
"
SYSTEM_EXT_DEBLOAT+="
framework/org.carconnectivity.android.digitalkey.rangingintent.jar
framework/org.carconnectivity.android.digitalkey.secureelement.jar
"

# Overlays
SYSTEM_DEBLOAT+="
system/app/WifiRROverlayAppQC
system/app/WifiRROverlayAppWifiLock
"
PRODUCT_DEBLOAT+="
overlay/SoftapOverlay6GHz
overlay/SoftapOverlayOWE
overlay/SoftapOverlayQC
"

# Camera SDK
SYSTEM_DEBLOAT+="
system/etc/default-permissions/default-permissions-com.samsung.android.globalpostprocmgr.xml
system/etc/default-permissions/default-permissions-com.samsung.petservice.xml
system/etc/default-permissions/default-permissions-com.samsung.videoscan.xml
system/etc/permissions/cameraservice.xml
system/etc/permissions/privapp-permissions-com.samsung.android.globalpostprocmgr.xml
system/etc/permissions/privapp-permissions-com.samsung.petservice.xml
system/etc/permissions/privapp-permissions-com.samsung.videoscan.xml
system/etc/permissions/sec_camerax_impl.xml
system/etc/permissions/sec_camerax_service.xml
system/framework/sec_camerax_impl.jar
system/framework/scamera_sep.jar
system/priv-app/GlobalPostProcMgr
system/priv-app/PetService
system/priv-app/SCameraSDKService
system/priv-app/sec_camerax_service
system/priv-app/VideoScan
"

# mAFPC
SYSTEM_DEBLOAT+="
system/bin/mafpc_write
"
# NFC
SYSTEM_DEBLOAT+="
system/priv-app/NfcNci
"

# Unused Camera Libs
SYSTEM_DEBLOAT+="
system/lib64/libsuperresolution_raw.arcsoft.so
system/lib64/libdualcam_refocus_image.so
system/lib64/libdualcam_portraitlighting_gallery_360.so
system/lib64/libdualcam_refocus_gallery_54.so
system/lib64/libdualcam_refocus_gallery_50.so
"

# Mediasearch
SYSTEM_DEBLOAT+="
system/etc/mediasearch
system/priv-app/MediaSearch
"

# Emoji
SYSTEM_DEBLOAT+="
system/priv-app/AREmoji
system/priv-app/AREmojiEditor
system/priv-app/AvatarEmojiSticker
"

# BixbyVision
SYSTEM_DEBLOAT+="
system/app/VisionIntelligence3.7
system/priv-app/BixbyVisionFramework3.5
"
