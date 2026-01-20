#!/bin/sh

SAMBA_LOG_DIR="/var/log/samba"
SAMBA_LIB_DIR="/var/lib/samba/private"

SMB_USER="root"
SMB_PASS="trimui"
SMB_HOST=$(grep -E '^[[:blank:]]*netbios name' /mnt/SDCARD/System/etc/samba/smb.conf | awk '{print $4}')
HOST_IP=$(ifconfig wlan0 | grep -E '^[[:blank:]]*inet ' | awk '{print $2}' | cut -d: -f2)

BGR_FILE="/mnt/SDCARD/System/res/background.png"
SMB_FILE="/mnt/SDCARD/System/res/samba-info.png"
MSG_FONT="/mnt/SDCARD/System/res/DejaVuSansCondensed.ttf"
MSG_COLOR_HEX="#FFDA03"
INFO_COLOR_HEX="#FFFFFF"

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
  MSG_TEXT="Samba server started"
else
  kill $(cat /var/run/samba/smbd.pid)
  kill $(cat /var/run/samba/nmbd.pid)
  smbd -D
  nmbd -D
  MSG_TEXT="Samba server restarted"
fi

SMB_INFO="NetBios name:  $SMB_HOST                           
IP address:        $HOST_IP                                      
Login:                $SMB_USER                                     
Password:          $SMB_PASS"                                    
                                                            
convert "$BGR_FILE" -font "$MSG_FONT" -pointsize 40 -fill "$INFO_COLOR_HEX" -gravity SouthWest -annotate +360+80 "$SMB_INFO" "$SMB_FILE"
convert "$SMB_FILE" -font "$MSG_FONT" -pointsize 60 -fill "$MSG_COLOR_HEX" -gravity North -annotate +0+140 "$MSG_TEXT" "$SMB_FILE"
timeout 5 sdl2imgshow -i "$SMB_FILE" -f $MSG_FONT -s 10 -c '0,0,0' -t ' '

