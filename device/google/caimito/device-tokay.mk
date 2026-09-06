#
# SPDX-FileCopyrightText: 2021 The Android Open-Source Project
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: The Calyx Institute
# SPDX-License-Identifier: Apache-2.0
#

# Kernel
TARGET_LINUX_KERNEL_VERSION := 6.1
TARGET_KERNEL_DEVICE := caimito
TARGET_KERNEL_DIR := device/google/$(TARGET_KERNEL_DEVICE)-kernels/$(TARGET_LINUX_KERNEL_VERSION)
TARGET_KERNEL_PLATFORM_SOURCE := google/gs-$(TARGET_LINUX_KERNEL_VERSION)

ifneq ($(TARGET_BOOTS_16K),true)
PRODUCT_16K_DEVELOPER_OPTION := true
endif

# Shipping API level
SHIPPING_API_LEVEL := 34

# Inherit from zumapro
include device/google/zumapro/common.mk

# Overlays
PRODUCT_PACKAGES += \
    ConnectivityResourcesOverlayCaimitoOverride \
    FrameworkResOverlayProductCaimito \
    FrameworkResOverlayVendorCaimito \
    PixelNfcOverlayCaimito \
    PixelWifiOverlay2024Caimito \
    SafetyRegulatoryInfoOverlayProductCaimito \
    SettingsGoogleOverlayProductCaimito \
    SystemUIGoogleOverlayVendorCaimito \
    TeleServiceOverlayVendorCaimito \
    TelecomOverlayProductCaimito

PRODUCT_PACKAGES += \
    DMServiceOverlayVendorTokay \
    FrameworkResOverlayVendorTokay \
    PixelDisplayServiceOverlayProductTokay \
    PixelNfcOverlayTokay \
    SettingsGoogleOverlayVendorTokay \
    SettingsTokayOverlay \
    SystemUIGoogleOverlayVendorTokay

PRODUCT_PACKAGES += \
    ApertureOverlayTokay

# PowerShare
include hardware/google/pixel/powershare/device.mk

# Properties
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/$(DEVICE_CODENAME)/product.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/$(DEVICE_CODENAME)/vendor.prop

# Recovery
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.tokay.rc

PRODUCT_PACKAGES += \
    init.recovery.caimito.touch.rc

# Satellite
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/conf/allowlist_satellite.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/allowlist_satellite.xml \
    frameworks/native/data/etc/android.hardware.telephony.satellite.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.satellite.xml

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# VINTF
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += \
    $(DEVICE_PATH)/vintf/device_framework_matrix_product.xml

# Window extensions
$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# MY EDITs



# 1. Enable Developer Options by default and Mute the Ringer on new Flash
PRODUCT_PRODUCT_PROPERTIES += \
    # 1. Developer Options Enabled by Default
    ro.debuggable=1 \
    persist.sys.development_settings_enabled=1 \

    # 2. Sound Defaults (Volume & Silent Mode)
    ro.config.media_vol_default=0 \
    ro.config.alarm_vol_default=0 \
    ro.config.notification_vol_default=0 \
    ro.config.ring_vol_default=0 \
    ro.config.vc_call_vol_default=0 \
    persist.sys.ringer_mode=0

# 2. Default the USB connection to File Transfer (MTP) while keeping ADB active
 PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp,adb
    ro.sys.usb.default.config=mtp,adb \

# 3. Force the build to use my device/google/caimito overlays; it was using zumapro.    
# 3. Tell this dingleberry to use my caimito tokay overlays instead of zumapro which I haven't touched.
PRODUCT_PACKAGE_OVERLAYS += \
    device/google/caimito/overlay \
    vendor/lineage/overlay/common

# 4. Remove the stock packages I despise
PRODUCT_PACKAGES_REMOVE += \
    AudioFX \
    Jelly \
    Aperture \
    Eleven \
    HotwordEnrollmentOKGoogleHEXAGON \
    HotwordEnrollmentXGoogleHEXAGON \
    Twelve \
    Etar

# 5. Packages I'm adding
PRODUCT_PACKAGES += \
    Cromite \
    AdAway \
    ColorBlendr \
    ProShot \
    Tailscale \
    ProtonVPN \
    FDroid \
    KeePassDX \
    ProtonMail \
    SimpleGallery \
    Snapseed \
    Syncthing \
    ytheekshanaDeviceInfo \
    GoogleCamera \
    privapp-permissions-google-camera \
    PixelParts


# REMOVED / UNUSED / MISC:

# 1. Set Sounds Default to Silent / Mute on first boot (I had this repeated for some reason)
# PRODUCT_PRODUCT_PROPERTIES += \
#    ro.config.alarm_vol_default=0 \
#    ro.config.media_vol_default=0 \
#    ro.config.notification_vol_default=0 \
#    ro.config.vc_call_vol_default=0 \
#    ro.config.ring_vol_default=0

# Disable Lineage Trust warnings (ain't work)
# PRODUCT_PRODUCT_PROPERTIES += \
#    persist.lineage.trust.warning.keys=0 \
#    persist.lineage.trust.warning.selinux=0 \
#    persist.lineage.trust.warning.unlocked=0

# 2. init.custom.rc setup
# Copy init.custom.rc into etc/init/init.custom.rc on tokay
# PRODUCT_COPY_FILES += \
#    device/google/caimito/init.custom.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/init.custom.rc

# Allowing init.custom.rc through the build
#PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
#    system/etc/init/init.custom.rc