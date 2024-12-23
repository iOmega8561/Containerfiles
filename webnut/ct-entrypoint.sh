#!/usr/bin/env sh

upshost="${UPS_HOST:-host.containers.internal}"
upsport="${UPS_PORT:-3493}"
upsuser="${UPS_USER:-monuser}"
upspassword="${UPS_PASSWD:-secret}"

source .pyenv/bin/activate
cd webNUT/webnut

echo "server = '$upshost'" > config.py
echo "port = '$upsport'" >> config.py
echo "username = '$upsuser'" >> config.py
echo "password = '$upspassword'" >> config.py

exec pserve ../production.ini