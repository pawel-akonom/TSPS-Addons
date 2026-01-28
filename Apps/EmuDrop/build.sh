#!/bin/bash

SYS_PATH="/mnt/SDCARD/System"
TMP_DIR="/mnt/SDCARD/System/tmp"
EMUDROP_VERSION="2.1.5"

pip3 --help &> /dev/null
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  if [ $EXIT_CODE -eq 127 ]; then
    echo "pip3 not found"
  else
    echo "pip3 is crashing:"
    pip3 --help
  fi
  exit 1
fi

if ! [ -d "$TMP_DIR" ]; then
  mkdir "$TMP_DIR"
fi
cd "$TMP_DIR"
wget --no-check-certificate "https://github.com/ahmadteeb/EmuDrop/archive/refs/tags/v${EMUDROP_VERSION}.zip"
unzip "v${EMUDROP_VERSION}.zip"
cd "EmuDrop-${EMUDROP_VERSION}"
pip3 install -r requirements.txt -t "${SYS_PATH}/python/lib/python3.10/"
pyinstaller --onefile --noconsole --name EmuDrop --hidden-import=sdl2 --hidden-import=sdl2.ext --hidden-import=sdl2.sdlimage --hidden-import=sdl2.sdlmixer --hidden-import=sdl2.sdlttf --hidden-import=sdl2.sdlgfx --hidden-import=requests --hidden-import=PIL --hidden-import=PIL.Image --collect-all sdl2 --collect-all requests --collect-all PIL main.py
