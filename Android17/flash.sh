#!/bin/sh
set -e
IMG=out/target/product/generic_arm64/system.img
adb reboot fastboot
fastboot snapshot-update cancel || true
fastboot flash system "$IMG"
fastboot reboot
