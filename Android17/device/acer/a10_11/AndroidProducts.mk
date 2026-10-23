# Registers the Acer A10-11 product with the AOSP build system.
# Lives in device/acer/a10_11/ (AOSP scans device/*/*/AndroidProducts.mk).

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/aosp_a10_11.mk

COMMON_LUNCH_CHOICES := \
    aosp_a10_11-aosp_current-userdebug \
    aosp_a10_11-aosp_current-user
