#!/bin/bash
APP_DIR=$(dirname "$0")
cd $APP_DIR
chmod -R 777 .

BGR_FILE="/mnt/SDCARD/System/res/background.png"
MSG_FONT="/mnt/SDCARD/System/res/DejaVuSansCondensed.ttf"

export PYSDL2_DLL_PATH="/usr/lib/"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/SDCARD/System/lib/
export PATH=/mnt/SDCARD/System/bin:$PATH

if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    EMUDROP_INFO="Internet connection detected"
    echo "$EMUDROP_INFO"
else
    EMUDROP_INFO="No internet connection"
    echo "$EMUDROP_INFO"
    timeout 4 sdl2imgshow -i "$BGR_FILE" -f $MSG_FONT -s 40 -c '255,255,255' -t "$EMUDROP_INFO"
    exit
fi

#sh app_ota.sh
sh db_ota.sh

echo performance >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 1608000 >/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1 > /tmp/stay_awake #keep screen awake

export ROMS_DIR="/mnt/SDCARD/Roms/"
export IMGS_DIR="/mnt/SDCARD/Imgs/{SYSTEM}/{IMAGE_NAME}.png"
export EXECUTABLES_DIR="$APP_DIR/assets/executables/"

"$APP_DIR/EmuDrop"
rm /tmp/stay_awake
