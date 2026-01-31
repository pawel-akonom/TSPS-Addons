#!/bin/bash
APPDIR=$(dirname "$0")
CACERT="/etc/ssl/certs/ca-bundle.crt"
if ! [ -f "$CACERT" ]; then
  curl -Lk -o "$CACERT" https://curl.se/ca/cacert.pem
fi
cd $APPDIR
./screech &> debug.txt
