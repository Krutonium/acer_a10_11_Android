env SOONG_INCREMENTAL_ANLYSIS=true
source build/envsetup.sh
lunch aosp_a10_11 aosp_current userdebug
m systemimage
