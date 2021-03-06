#
# Copyright (C) 2007 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_PLATFORM := sc8830
PLATDIR := device/sprd/scx35

TARGET_BOARD := scx35_core3
BOARDDIR := device/sprd/$(TARGET_BOARD)

BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_SEPARATED_DT := true

# copy media_profiles.xml before calling device.mk,
# because we want to use our file, not the common one
PRODUCT_COPY_FILES += $(BOARDDIR)/media_profiles.xml:system/etc/media_profiles.xml

ifeq ($(strip $(USE_SPRD_WCN)),true)
# call connectivity_configure_7730g.mk before calling device.mk
$(call inherit-product, vendor/sprd/open-source/res/productinfo/connectivity_configure_7730g.mk)
endif

# include general common configs
$(call inherit-product, $(PLATDIR)/device.mk)
$(call inherit-product, $(PLATDIR)/emmc/emmc_device.mk)
$(call inherit-product, $(PLATDIR)/proprietories.mk)

DEVICE_PACKAGE_OVERLAYS := $(BOARDDIR)/overlay $(PLATDIR)/overlay

PRODUCT_AAPT_CONFIG := hdpi

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mass_storage

PRODUCT_PROPERTY_OVERRIDES += \
	keyguard.no_require_sim=true \
	ro.com.android.dataroaming=false \
	ro.msms.phone_count=2 \
	persist.msms.phone_count=2 \
	persist.msms.phone_default=0 \
	ro.modem.w.count=2 \
        persist.sys.modem.diag=,gser \
        sys.usb.gser.count=4

# board-specific modules
PRODUCT_PACKAGES += \
        sensors.$(TARGET_PLATFORM) \
        fm.$(TARGET_PLATFORM) \
        ValidationTools

# board-specific files
PRODUCT_COPY_FILES += \
	$(BOARDDIR)/init.board.rc:root/init.board.rc \
       $(BOARDDIR)/init.recovery.board.rc:root/init.recovery.board.rc \
	$(BOARDDIR)/audio_params/tiny_hw.xml:system/etc/tiny_hw.xml \
	$(BOARDDIR)/audio_params/codec_pga.xml:system/etc/codec_pga.xml \
	$(BOARDDIR)/audio_params/audio_hw.xml:system/etc/audio_hw.xml \
	$(BOARDDIR)/audio_params/audio_para:system/etc/audio_para \
	$(BOARDDIR)/audio_params/audio_policy.conf:system/etc/audio_policy.conf \

$(call inherit-product, vendor/sprd/open-source/res/boot/boot_res_8830s.mk)
$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)
$(call inherit-product-if-exists, vendor/sprd/open-source/common_packages.mk)
$(call inherit-product-if-exists, vendor/sprd/open-source/plus_special_packages.mk)
$(call inherit-product, hardware/broadcom/wlan/bcmdhd/firmware/bcm4343s/device-bcm.mk)
$(call inherit-product, vendor/sprd/gps/CellGuide_2351/device-sprd-gps.mk)
#$(call inherit-product, vendor/sprd/partner/shark/bluetooth/device-shark-bt.mk)

# Overrides
PRODUCT_NAME := scx35_core3
PRODUCT_DEVICE := $(TARGET_BOARD)
PRODUCT_MODEL := SP7730A
PRODUCT_BRAND := Spreadtrum
PRODUCT_MANUFACTURER := Spreadtrum

PRODUCT_LOCALES := zh_CN zh_TW en_US
