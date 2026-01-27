# TSPS-Addons
Additional emulators, applications, tools and features for Trimui Smart Pro S

# Installation

Copy all files and directories to the micro SD card for Trimui Smart Pro S

# Add-ons

## Emualtors

- DOS : Added support for running DOS games with already build in RetroArch Libretro DOSBox-pure emualator
- SFC : Added support for running SNES games with already build in RetroArch Libretro SNES9x emulator

## Applications

- EmuDrop: Added EmuDrop v2.1.5. It has been compiled with pyinstaller and python 3.10 with all required libraries to one single binary
- File Manager : Added DinguxCommander file manager
- Samba : Added samba server for copying data via Windows file share. Application show the server name, server IP and the credentials for login

## Command line tools

All extra command line tool from System/bin directory are avialble when ssh to the Trimui Smart Pro S after setting following environment variables:
```
export PATH=/mnt/SDCARD/System/bin:$HOME/bin:$PATH
export LD_LIBRARY_PATH=/mnt/SDCARD/System/lib
```
