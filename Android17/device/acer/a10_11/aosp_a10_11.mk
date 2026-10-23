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
PRODUCT_MODEL        := Iconia A10-11
PRODUCT_MARKETNAME   := Acer A10-11

# --- Make the model win over the Android 12 vendor's value -----------------
# UNTESTED on this device: verify with `adb shell getprop ro.product.model`.
PRODUCT_PRODUCT_PROPERTIES += \
    ro.product.property_source_order=system,product,system_ext,odm,vendor

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

#PRODUCT_PACKAGES += A1011BrandingOverlay
