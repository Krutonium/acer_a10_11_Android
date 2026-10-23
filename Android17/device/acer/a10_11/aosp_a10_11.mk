# Product definition for the Acer A10-11 (Android 17 GSI-style build).
#
# Build with:  lunch aosp_a10_11 aosp_current userdebug

# --- Base product ----------------------------------------------------------
$(call inherit-product, device/generic/common/gsi_arm64.mk)

# --- Identity --------------------------------------------------------------
PRODUCT_NAME         := aosp_a10_11
# Keep generic_arm64 so the existing BoardConfig is reused and output stays in
# out/target/product/generic_arm64/.
PRODUCT_DEVICE       := generic_arm64

PRODUCT_BRAND        := Acer
PRODUCT_MANUFACTURER := Acer
PRODUCT_MODEL        := Tattoo A10-11
PRODUCT_MARKETNAME   := Acer A10-11

# --- Make the system partition report the Acer identity ---------------------
PRODUCT_SYSTEM_MODEL        := $(PRODUCT_MODEL)
PRODUCT_SYSTEM_BRAND        := $(PRODUCT_BRAND)
PRODUCT_SYSTEM_MANUFACTURER := $(PRODUCT_MANUFACTURER)

# --- Make the model win over the Android 12 vendor's value -----------------
PRODUCT_PRODUCT_PROPERTIES += \
    ro.product.property_source_order=product,system_ext,odm,vendor,system

# --- Remove default apps ---------------------------------------------------
# Browser2                -> org.chromium.webview_shell
# UsbDisableDebugger      -> com.android.usb.testing.debuggertool.datasignal
PRODUCT_PACKAGES := $(filter-out \
    Browser2 \
    UsbDisableDebugger, \
    $(PRODUCT_PACKAGES))

# --- Branding --------------------------------------------------------------
# Defined in device/acer/a10_11/Android.bp. Must come after the filter-out.
PRODUCT_PACKAGES += bootanimation-a10-11
PRODUCT_PACKAGE_OVERLAYS += device/acer/a10_11/overlay
