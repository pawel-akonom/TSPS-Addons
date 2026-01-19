#!/bin/sh

SAMBA_LOG_DIR="/var/log/samba"
SAMBA_LIB_DIR="/var/lib/samba/private"

SMB_USER="root"
SMB_PASS="trimui"

MSG_BACKGROUND="/mnt/SDCARD/System/res/background.png"
MSG_FONT="/mnt/SDCARD/System/res/DejaVuSansCondensed.ttf"
MSG_COLOR="255,218,3"

export PATH=/mnt/SDCARD/System/bin:$PATH
export LD_LIBRARY_PATH=/mnt/SDCARD/System/lib

if [ ! -d "$SAMBA_LOG_DIR" ]; then
  mkdir -p "$SAMBA_LOG_DIR"
fi

if [ ! -d "$SAMBA_LIB_DIR" ]; then
  mkdir -p "$SAMBA_LIB_DIR"
fi

if [ ! -f "/etc/samba/smb.conf" ]; then
  ln -s /mnt/SDCARD/System/etc/samba /etc/samba
fi

echo -e "$SMB_PASS\n$SMB_PASS" | smbpasswd -a -s "$SMB_USER"

if [ ! -f "/var/run/samba/smbd.pid" ]; then
  smbd -D
  nmbd -D
  timeout 3 sdl2imgshow -i $MSG_BACKGROUND -f $MSG_FONT -s 50 -c "$MSG_COLOR" -t "Samba server started"
else
  kill $(cat /var/run/samba/smbd.pid)
  kill $(cat /var/run/samba/nmbd.pid)
  smbd -D
  nmbd -D
  timeout 3 sdl2imgshow -i $MSG_BACKGROUND -f $MSG_FONT -s 50 -c "$MSG_COLOR" -t "Samba server restarted" 
fi


